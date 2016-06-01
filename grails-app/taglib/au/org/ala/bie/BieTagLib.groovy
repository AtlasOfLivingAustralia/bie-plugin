package au.org.ala.bie

import groovy.json.JsonSlurper
import org.apache.commons.lang.StringEscapeUtils
import au.org.ala.names.parser.PhraseNameParser
import org.springframework.web.servlet.support.RequestContextUtils

class BieTagLib {
    def grailsApplication

    static namespace = 'bie'     // namespace for headers and footers

    static languages = null      // Lazy iniitalisation

    /**
     * Format a scientific name with appropriate italics depending on rank
     *
     * @attr nameFormatted OPTIONAL The HTML formatted scientific name
     * @attr nameComplete OPTIONAL The complete, unformatted scientific name
     * @attr acceptedName OPTIONAL The accepted name
     * @attr name REQUIRED the scientific name
     * @attr rankId REQUIRED The rank ID
     */
    def formatSciName = { attrs ->
        def nameFormatted = attrs.nameFormatted
        def rankId = attrs.rankId ?: 0
        def name = attrs.nameComplete ?: attrs.name
        def rank = cssRank(rankId)
        def accepted = attrs.acceptedName
        def parsed = { n, r, incAuthor ->
            PhraseNameParser pnp = new PhraseNameParser()
            try {
                def pn = pnp.parse(n) // attempt to parse phrase name
                log.debug "name = ${n} || rankId = ${pn.canonicalName()}"
                def author = incAuthor ? " <span class=\"author\">${pn.authorshipComplete()}</span>" : ""
                n = "<span class=\"scientific-name rank-${r}\"><span class=\"name\">${pn.canonicalName()}</span>${author}</span>"
            } catch (Exception ex) {
                log.warn "Error parsing name (${n}): ${ex}", ex
            }
            n
        }

        if (nameFormatted)
            out << nameFormatted
        else {
            def output = "<span class=\"scientific-name rank-${rank}\"><span class=\"name\">${name}</span></span>"
            if (rankId >= 6000)
                output = parsed(name, rank, true)
             out << output
        }
        if (accepted) {
            accepted = parsed(accepted, rank, false)
            out << " <span class=\"accepted-name\">(accepted name:&nbsp;${accepted})</span> "
        }
    }

    /**
     * Constructs a link to EYA from this locality.
     */
    def constructEYALink = {  attrs, body ->

       def group = attrs.result.centroid =~ /([\d.-]+) ([\d.-]+)/
       def bieUrl = grailsApplication.config.biocache.baseURL

       def parsed = group && group[0] && group[0].size() == 3
       if(parsed){
           def latLong = group[0]
           out <<  "<a href='" + bieUrl + "/explore/your-area#" +
                   latLong[2] + "|" + latLong[1] + "|12|ALL_SPECIES'>"
       }

       out << body()

       if(parsed){
           out << "</a>"
       }
    }

    /**
     * Output the colour name for a given conservationstatus
     *
     * @attr status REQUIRED the conservation status
     */
    def colourForStatus = { attrs ->
//        <g:if test="${status.status ==~ /extinct$/}"><span class="iucn red"><g:message code="region.${regionCode}"/><!--EX--></span></g:if>
//        <g:elseif test="${status.status ==~ /(?i)wild/}"><span class="iucn red"><g:message code="region.${regionCode}"/><!--EW--></span></g:elseif>
//        <g:elseif test="${status.status ==~ /(?i)Critically/}"><span class="iucn yellow"><g:message code="region.${regionCode}"/><!--CR--></span></g:elseif>
//        <g:elseif test="${status.status ==~ /(?i)^Endangered/}"><span class="iucn yellow"><g:message code="region.${regionCode}"/><!--EN--></span></g:elseif>
//        <g:elseif test="${status.status ==~ /(?i)Vulnerable/}"><span class="iucn yellow"><g:message code="region.${regionCode}"/><!--VU--></span></g:elseif>
//        <g:elseif test="${status.status ==~ /(?i)Near/}"><span class="iucn green"><g:message code="region.${regionCode}"/><!--NT--></span></g:elseif>
//        <g:elseif test="${status.status ==~ /(?i)concern/}"><span class="iucn green"><g:message code="region.${regionCode}"/><!--LC--></span></g:elseif>
//        <g:else><span class="iucn green"><g:message code="region.${regionCode}"/><!--LC--></span></g:else>
        def status = attrs.status
        def colour

        switch ( status ) {
            case ~/(?i)extinct/:
                colour = "extinct"
                break
            case ~/(?i).*extinct.*/:
                colour = "black"
                break
            case ~/(?i)critically\sendangered.*/:
                colour = "red"
                break
            case ~/(?i)endangered.*/:
                colour = "orange"
                break
            case ~/(?i)vulnerable.*/:
                colour = "yellow"
                break
            case ~/(?i)near\sthreatened.*/:
                colour = "near-threatened"
                break
            //case ~/(?i)least\sconcern.*/:
            default:
                colour = "green"
                break
        }

        out << colour
    }

    /**
     * Tag to output the navigation links for search results
     *
     *  @attr totalRecords REQUIRED
     *  @attr startIndex REQUIRED
     *  @attr pageSize REQUIRED
     *  @attr lastPage REQUIRED
     *  @attr title
     */
    def searchNavigationLinks = { attr ->
        log.debug "attr = " + attr
        def lastPage = attr.lastPage?:1
        def pageSize = attr.pageSize?:10
        def totalRecords = attr.totalRecords
        def startIndex = attr.startIndex?:0
        def title = attr.title?:""
        def pageNumber = (attr.startIndex / attr.pageSize) + 1
        def trimText = params.q?.trim()
        def fqList = params.list("fq")
        def coreParams = (fqList) ? "?q=${trimText}&fq=${fqList.join('&fq=')}" : "?q=${trimText}"
        def startPageLink = 0
        if (pageNumber < 6 || attr.lastPage < 10) {
            startPageLink = 1
        } else if ((pageNumber + 4) < lastPage) {
            startPageLink = pageNumber - 4
        } else {
            startPageLink = lastPage - 8
        }
        if (pageSize > 0) {
            lastPage = (totalRecords / pageSize) + ((totalRecords % pageSize > 0) ? 1 : 0);
        }
        def endPageLink = (lastPage > (startPageLink + 8)) ? startPageLink + 8 : lastPage

        // Uses MarkupBuilder to create HTML
        def mb = new groovy.xml.MarkupBuilder(out)
        mb.ul {
            li(id:"prevPage") {
                if (startIndex > 0) {
                    mkp.yieldUnescaped("<a href=\"${coreParams}&start=${startIndex - pageSize}&title=${title}\">&laquo; Previous</a>")
                } else {
                    mkp.yieldUnescaped("<span>&laquo; Previous</span>")
                }
            }
            (startPageLink..endPageLink).each { pageLink ->
                if (pageLink == pageNumber) {
                    mkp.yieldUnescaped("<li class=\"currentPage\">${pageLink}</li>")
                } else {
                    mkp.yieldUnescaped("<li><a href=\"${coreParams}&start=${(pageLink * pageSize) - pageSize}&title=${title}\">${pageLink}</a></li>")
                }
            }
            li(id:"nextPage") {
                if (!(pageNumber == endPageLink)) {
                    mkp.yieldUnescaped("<a href=\"${coreParams}&start=${startIndex + pageSize}&title=${title}\">Next &raquo;</a>")
                } else {
                    mkp.yieldUnescaped("<span>Next &raquo;</span>")
                }
            }
        }
    }

    /**
     * Mark a phrase with language, optionally with a specific language marker
     *
     * @attr text The text to mark
     * @attr lang The language code (ISO)
     * @attr mark Mark the language in text (defaults to true)
     */
    def markLanguage = { attrs ->
        Locale defaultLocale = RequestContextUtils.getLocale(request)
        String text = attrs.text ?: ""
        Locale lang = Locale.forLanguageTag(attrs.lang ?: defaultLocale.language)
        boolean mark = attrs.mark ?: true

        out << "<span lang=\"${lang}\">${text}"
        if (mark && defaultLocale.language != lang.language) {
            String name = languageName(lang.language)
            out << "&nbsp;<span class=\"annotation annotation-language\" title=\"${lang}\">${name}</span>"
        }
        out << "</span>"
    }

    /**
     * Custom function to escape a string for JS use
     *
     * @param value
     * @return
     */
    def static escapeJS(String value) {
        return StringEscapeUtils.escapeJavaScript(value);
    }

    /**
     * Get a default rank grouping for a rank ID.
     * <p>
     * See bie-index taxonRanks.properties for the rank structure
     *
     * @param rankId The rank identifier
     *
     * @return The grouping
     */
    private def cssRank(int rankId) {
        if (rankId <= 0)
            return "unknown"
        if (rankId <= 1200)
            return "kingdom"
        if (rankId <= 2200)
            return "phylum"
        if (rankId <= 3400)
            return "class"
        if (rankId <= 4400)
            return "order"
        if (rankId <= 5700)
            return "famnily"
        if (rankId < 7000)
            return "genus"
        if (rankId < 8000)
            return "species"
        return "subspecies"
    }

    private String languageName(String lang) {
        synchronized (this.class) {
            if (languages == null) {
                JsonSlurper slurper = new JsonSlurper()
                def ld = slurper.parse(new URL(grailsApplication.config.languageCodesUrl))
                languages = [:]
                ld.codes.each { code ->
                    if (languages.containsKey(code.code))
                        log.warn "Duplicate language code ${code.code}"
                    languages[code.code] = code
                    if (code.part2b && !languages.containsKey(code.part2b))
                        languages[code.part2b] = code
                    if (code.part2t && !languages.containsKey(code.part2t))
                        languages[code.part2t] = code
                    if (code.part1 && !languages.containsKey(code.part1))
                        languages[code.part1] = code
                }
            }
        }
        return languages[lang]?.name ?: lang
    }
}