package au.org.ala.bie

class BiocacheService {

    def grailsApplication
    def webService

    def getSoundsForTaxon(taxonName){
        def queryUrl = grailsApplication.config.biocacheService.baseURL + "/occurrences/search?q=" + URLEncoder.encode(taxonName, "UTF-8") + "&fq=multimedia:\"Sound\""
        def data = webService.getJson(queryUrl)
        //log.debug "sound data => " + data
        if(data.size() && data.has("occurrences") && data.get("occurrences").size()){
            def recordUrl = grailsApplication.config.biocacheService.baseURL + "/occurrence/" + data.get("occurrences").get(0).uuid
            webService.getJson(recordUrl)
        } else {
            null
        }
    }

    /**
     * Enum for image categories
     */
    public enum ImageCategory {
        TYPE, SPECIMEN, OTHER
    }
}
