package au.org.ala.bie
import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONObject

class BieService {

    def webService
    def grailsApplication

    def searchBie(SearchRequestParamsDTO requestObj) {




        def json = webService.get(grailsApplication.config.bie.index.url + "/search?" + requestObj.getQueryString() +"&facets="+grailsApplication.config.facets)
        return JSON.parse(json)
    }

    def getSpeciesList(guid){
        if(!guid){
            return null
        }
        try {
            def json = webService.get(grailsApplication.config.speciesList.baseURL + "/ws/species/" + guid.replaceAll(/\s+/,'+') + "?isBIE=true", true)
            return JSON.parse(json)
        } catch(Exception e){
            //handles the situation where time out exceptions etc occur.
            log.error("Error retrieving species list.", e)
            return []
        }
    }

    def getTaxonConcept(guid) {
        if (!guid && guid != "undefined") {
            return null
        }
        def json = webService.get(grailsApplication.config.bie.index.url + "/taxon/" + guid.replaceAll(/\s+/,'+'))
        //log.debug "ETC json: " + json
        try{
            JSON.parse(json)
        } catch (Exception e){
            log.warn "Problem retrieving information for Taxon: " + guid
            null
        }
    }

    def getExtraImages(tc) {
        def images = []

        if (tc?.taxonConcept?.rankID && tc?.taxonConcept?.rankID < 7000 /*&& tc?.taxonConcept?.rankID % 1000 == 0*/) {
            // only lookup for higher taxa of major ranks
            // /ws/higherTaxa/images
            images = webService.getJson(grailsApplication.config.bie.baseURL + "/ws/higherTaxa/images.json?scientificName=" + tc?.taxonConcept?.nameString + "&taxonRank=" + tc?.taxonConcept?.rankString)
        }

        if (images.hasProperty("error")) {
            images = []
        }
        log.debug "images = " + images

        return images
    }

    def getClassificationForGuid(guid) {
//        String url = grailsApplication.config.bie?.baseURL + "/ws/classification/" + guid.replaceAll(/\s+/,'+')
        String url = grailsApplication.config.bie.index.url + "/classification/" + guid.replaceAll(/\s+/,'+')
        def json = webService.getJson(url)
        log.debug "json type = " + json
        if (json instanceof JSONObject && json.has("error")) {
            log.warn "classification request error: " + json.error
            return [:]
        } else {
            log.debug "classification json: " + json
            return json
        }
    }

    def getChildConceptsForGuid(guid) {
        //String url = grailsApplication.config.bie?.baseURL + "/ws/childConcepts/" + guid.replaceAll(/\s+/,'+')
        String url = grailsApplication.config.bie.index.url + "/childConcepts/" + guid.replaceAll(/\s+/,'+')
        def json = webService.getJson(url).sort() { it.rankID?:0 }

        if (json instanceof JSONObject && json.has("error")) {
            log.warn "child concepts request error: " + json.error
            return [:]
        } else {
            log.debug "child concepts json: " + json
            return json
        }
    }

    /**
     * Lookup against biocache for isAustralian property
     * FIXME - rename to isNative...
     * @param guid
     * @return
     */
    def getIsAustralian(guid) {
        Boolean isAustralian = null
        def ausTaxon = webService.getJson(grailsApplication.config.biocache.baseURL + "/ws/australian/taxon/" + guid.replaceAll(/\s+/,'+'))

        if (ausTaxon instanceof JSONObject && ausTaxon.containsKey("isAustralian")) {
            isAustralian = ausTaxon.get("isAustralian")
        }
        log.debug("isAustralian lookup: " + isAustralian)
        return isAustralian
    }
}