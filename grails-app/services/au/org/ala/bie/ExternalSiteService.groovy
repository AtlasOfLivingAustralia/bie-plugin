package au.org.ala.bie

import au.org.ala.citation.BHLAdaptor
import grails.config.Config
import grails.converters.JSON
import grails.core.support.GrailsConfigurationAware
import grails.transaction.Transactional
import groovy.json.JsonSlurper

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


    @Override
    void setConfiguration(Config config) {
        bhlApi = config.literature.bhl.api
        bhlApiKey = config.literature.bhl.apikey
        bhlPageSize = config.literature.bhl.pageSize.toInteger()
        bhlExtend = config.literature.bhl.extend.toBoolean()
    }

    /**
     * Search the BHL for terms
     *
     * @param search The terms to search for
     * @param start The start position
     * @param rows The number of rows
     * @param fulltext Do a full text search if true (very slow)
     *
     * @return A map containing
     */
    def searchBhl(List<String> search, int start = 0, int rows = 10, boolean fulltext = false) {
        def searchtype = fulltext ? 'F' : 'C'
        def page = (start / bhlPageSize) + 1 as Integer
        def from = start % bhlPageSize
        def max = 0
        def more = false
        def adaptor = new BHLAdaptor()
        def results = []
        if (bhlApiKey && bhlApi) {
            def searchTerms = URLEncoder.encode('"' + search.join('" OR "') + '"', 'UTF-8')
            def url = "${bhlApi}?op=PublicationSearch&searchterm=${searchTerms}&searchtype=${searchtype}&page=${page}&apikey=${bhlApiKey}&format=json"
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

}
