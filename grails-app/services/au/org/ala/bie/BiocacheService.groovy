package au.org.ala.bie

import org.apache.commons.httpclient.util.URIUtil
import org.grails.web.json.JSONObject


class BiocacheService {

    def grailsApplication
    def webService

    /**
     * Retrieve the available sounds for this taxon.
     *
     * @param taxonName
     * @return
     */
    def getSoundsForTaxon(taxonName){
        JSONObject jsonObj = new JSONObject()
        if (!grailsApplication.config.biocacheService.baseURL)
            return jsonObj
        def queryUrl = grailsApplication.config.biocacheService.baseURL + "/occurrences/search?q=" + URIUtil.encodeWithinQuery(taxonName, "UTF-8") + "&fq=multimedia:Sound"

        log.debug "calling url = ${queryUrl}"
        def data = webService.getJson(queryUrl)

        if (data.size() && data.has("occurrences") && data.get("occurrences").size()) {
            def recordUrl = grailsApplication.config.biocacheService.baseURL + "/occurrence/" + data.get("occurrences").get(0).uuid
            jsonObj = webService.getJson(recordUrl)
        }

        jsonObj
    }

    /**
     * Enum for image categories
     */
    public enum ImageCategory {
        TYPE, SPECIMEN, OTHER
    }
}
