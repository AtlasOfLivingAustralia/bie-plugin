package au.org.ala.bie

import au.org.ala.citation.BHLAdaptor
import grails.config.Config
import grails.core.support.GrailsConfigurationAware
import groovy.json.JsonOutput
import groovy.json.JsonSlurper
import org.owasp.html.HtmlPolicyBuilder
import org.owasp.html.PolicyFactory

import java.text.MessageFormat
import java.util.regex.Pattern

/**
 * Get information from external sites
 */
class ExternalSiteService implements GrailsConfigurationAware {
    /** Base URL of BHL web services */
    String bhlApiKey
    /** API Key to use when accessing BHL */
    String bhlApi
    /** The fixed BHL search page size */
    int bhlPageSize
    /** Extend BHL information with DOIs and citations */
    boolean bhlExtend
    /** The EoL search service patterm */
    String eolSearchService
    /** The EoL page service pattern */
    String eolPageService
    /** Sanitize the EoL pages */
    boolean eolSanitise
    /** Accept these languages for the EoL pages */
    String eolLanguage
    /** The file containing elements to update */
    String updateFile
    /** Allowed elements for HTML */
    String allowedElements
    /** Allowed attributes for HTML */
    String allowedAttributes
    /** Blacklist for external sites */
    Blacklist blacklist;


    @Override
    void setConfiguration(Config config) {
        bhlApi = config.getProperty("literature.bhl.api")
        bhlApiKey = config.getProperty("literature.bhl.apikey")
        bhlPageSize = config.getProperty("literature.bhl.pageSize", Integer)
        bhlExtend = config.getProperty("literature.bhl.extend", Boolean)
        eolSearchService = config.getProperty("external.eol.search.service")
        eolPageService = config.getProperty("external.eol.page.service")
        eolSanitise =  config.getProperty("eol.sanitise", Boolean, false)
        eolLanguage = config.getProperty("eol.lang")
        updateFile = config.getProperty("update.file.location")
        allowedElements = config.getProperty("eol.html.allowedElements")
        allowedAttributes = config.getProperty("eol.html.allowAttributes")
        def blacklistURL = config.getProperty('external.blacklist', URL)
        blacklist = blacklistURL ? Blacklist.read(blacklistURL) : null
    }

    /**
     * Search the BHL for terms (PublicationSearch)
     *
     * @param search The terms to search for
     * @param start The start position
     * @param rows The number of rows
     * @param fulltext Do a full text search if true (very slow)
     *
     * @return A map containing
     */
    def searchBhl(List<String> search, int start = 0, int rows = 10, boolean fulltext = false) {
        //https://www.biodiversitylibrary.org/docs/api3.html
        // searchtype - 'C' for a catalog-only search; 'F' for a catalog+full-text search
        def searchtype = fulltext ? 'F' : 'C'
        def page = (start / bhlPageSize) + 1 as Integer
        def from = start % bhlPageSize
        def max = 0
        def more = false
        def adaptor = new BHLAdaptor()
        def results = []
        if (bhlApiKey && bhlApi) {
            def searchTerms = URLEncoder.encode('"' + search.join('" OR "') + '"', 'UTF-8')
            def encodedKey = URLEncoder.encode(bhlApiKey, 'UTF-8')
            def url = "${bhlApi}?op=PublicationSearch&searchterm=${searchTerms}&searchtype=${searchtype}&page=${page}&apikey=${encodedKey}&format=json"
            def js = new JsonSlurper()
            try {
                def json = js.parse(new URL(url))
                if (!json.Status || json.Status != 'ok') {
                    log.warn "Unable to retrieve data for ${url}, status: ${json.Status}, error: ${json.ErrorMessage}"
                } else {
                    more = json.Result.size() == bhlPageSize
                    max = (page - 1) * bhlPageSize + json.Result.size()
                    def res = json.Result?.drop(from)?.take(rows)
                    res.each { result ->
                        def cite = adaptor.convert(result)
                        if (bhlExtend) {
                            def action = null
                            def id = null
                            switch (result.BHLType) {
                                case 'Item':
                                    action = 'GetItemMetadata'
                                    id = result.ItemID
                                    break
                                case 'Part':
                                    action = 'GetPartMetadata'
                                    id = result.PartID
                                    break
                                default:
                                    break
                            }
                            if (action && id) {
                                def murl = "${bhlApi}?op=${action}&id=${id}&&pages=f&names=f&apikey=${bhlApiKey}&format=json"
                                try {
                                    def mjson = js.parse(new URL(murl))
                                    if (mjson && mjson.Status == 'ok' && mjson.Result) {
                                        cite.DOI = mjson.Result[0].Doi
                                        cite.thumbnailUrl = mjson.Result[0].ItemThumbUrl
                                    }
                                } catch (Exception ex) {
                                    log.info "Error retrieving ${murl}: ${ex.message}"
                                }
                            }
                        }
                        results << cite
                    }
                }
            } catch (Exception ex) {
                log.warn "Error retrieving ${url}: ${ex.message}"
            }
        }
        return [start: start, rows: rows, search: search, max: max, more: more, results: results]
    }

    def searchEol(String name, String filter) {
        def nameEncoded = URLEncoder.encode(name, 'UTF-8')
        def filterString  = URLEncoder.encode(filter ?: '', 'UTF-8')
        def search =  MessageFormat.format(eolSearchService, nameEncoded, filterString)
        log.debug "Initial EOL url = ${search}"
        def js = new JsonSlurper()
        def jsonText = new URL(search).text
        def json = js.parseText(jsonText ?: '{}')
        def result = [:]

        //get first pageId
        if (json.results) {
            def match = json.results.find { it.title.equalsIgnoreCase(name) }
            if (match) {
                def pageId = match.id
                def page = MessageFormat.format(eolPageService, pageId, eolLanguage ?: "")
                log.debug("EOL page url = ${page}")
                def pageText = new URL(page).text ?: '{}'
                pageText = updateEolOutput(pageText)
                pageText = eolSanitise ? sanitiseEolOutput(pageText) : pageText
                // Select on language
                result = js.parseText(pageText)
                if (result?.taxonConcept) {
                    def dataObjects = result?.taxonConcept?.dataObjects ?: []
                    if (eolLanguage) {
                        dataObjects = dataObjects.findAll { dto -> dto.language && dto.language == eolLanguage }
                    }
                    if (blacklist) {
                        dataObjects = dataObjects.findAll { dto -> !blacklist.isBlacklisted(name, dto.source, dto.title) }
                    }
                    result.taxonConcept.dataObjects = dataObjects
                }
            }
        }
        return result
    }

    /**
     * Update EOL content before rendering, rules specified in an external file.
     */
    String updateEolOutput(String text){
        if (updateFile != null && new File(updateFile).exists()){
            new File(updateFile).eachLine { line ->
                if (!line.startsWith("#")) {
                    String[] valuePairs = line.split('--')
                    String replacement = valuePairs.length==1 ? "''" :valuePairs[1]
                    text = text.replace(valuePairs[0], replacement)
                }
            }
        }
        text
    }

    /**
     * Sanitise EOL response with defined policy.
     * @param text EOL response
     * @return processed EOL response
     */
    String sanitiseEolOutput(String text) {
        def json = new JsonSlurper().parseText(text)

        if(json.taxonConcept?.dataObjects){
            PolicyFactory policy = getPolicyFactory()
            json.taxonConcept.dataObjects.each { dataObject ->
                String desc = dataObject.description
                String processedDesc = sanitiseBodyText(policy, desc)
                dataObject.description = processedDesc
            }
        }
        JsonOutput.toJson(json)
    }

    /**
     * Utility to sanitise HTML text and only allow links to be kept, removing any
     * other HTML markup.
     * @param policy PolicyFactory
     * @param input HTML String
     * @return output sanitized HTML String
     */
    String sanitiseBodyText(PolicyFactory policy, String input) {
        // Sanitize the HTML based on given policy
        String sanitisedHtml = policy.sanitize(input)
        sanitisedHtml
    }

    private PolicyFactory getPolicyFactory(){
        HtmlPolicyBuilder builder = new HtmlPolicyBuilder()
                .allowStandardUrlProtocols()
                .requireRelNofollowOnLinks()

        if (allowedElements){
            String[] elements = allowedElements.split(",")
            elements.each {
                builder.allowElements(it)
            }
        }

        if (allowedAttributes){
            String[] attributes = allowedAttributes.split(",")
            attributes.each { attribute ->
                String[] values = attribute.split (";")
                if (values.length == 2){
                    builder.allowAttributes(values[0]).onElements(values[1])
                } else {
                    builder.allowAttributes(values[0]).matching(Pattern.compile(values[2], Pattern.CASE_INSENSITIVE)).onElements(values[1])
                }

            }
        }

        builder.toFactory()
    }

}
