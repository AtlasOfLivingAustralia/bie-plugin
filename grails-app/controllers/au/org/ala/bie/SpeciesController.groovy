/**
 * Copyright (C) 2016 Atlas of Living Australia
 * All Rights Reserved.
 *
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 */
package au.org.ala.bie

import au.org.ala.bie.webapp2.SearchRequestParamsDTO
import grails.config.Config
import grails.converters.JSON
import grails.core.support.GrailsConfigurationAware
import groovy.json.JsonSlurper
import org.grails.web.json.JSONObject

/**
 * Species Controller
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
class SpeciesController implements GrailsConfigurationAware {
    // Caused by the grails structure eliminating the // from http://x.y.z type URLs
    static BROKEN_URLPATTERN = /^[a-z]+:\/[^\/].*/

    def bieService
    def utilityService
    def biocacheService
    def authService

    /** Pull selected categories into a separate section */
    boolean pull
    /** The set of categories to pull */
    Set<String> pullCategories

    @Override
    void setConfiguration(Config config) {
        pull = config.getProperty('vernacularName.pull.active', Boolean, false)
        pullCategories = config.getProperty('vernacularName.pull.categories', String, '').split(',').collect({ it.trim() }) as Set
    }

    def geoSearch = {

        def searchResults = []
        try {
            def googleMapsKey = grailsApplication.config.googleMapsApiKey
            def url = "https://maps.googleapis.com/maps/api/geocode/json?key=${googleMapsKey}&address=" +
                    URLEncoder.encode(params.q, 'UTF-8')
            def response = new URL(url).text
            def js = new JsonSlurper()
            def json = js.parseText(response)

            if(json.results){
                json.results.each {
                    searchResults << [
                            name: it.formatted_address,
                            latitude: it.geometry.location.lat,
                            longitude: it.geometry.location.lng
                    ]
                }
            }
        } catch (Exception e) {
            log.error(e.getMessage(), e)
        }

        JSON.use('deep') {
            render searchResults as JSON
        }
    }

    /**
     * Search page - display search results fro the BIE (includes results for non-species pages too)
     */
    def search = {
        def query = params.q?:"".trim()
        if(query == "*") query = ""
        def filterQuery = params.list('fq') // will be a list even with only one value
        def startIndex = params.offset?:0
        def rows = params.rows?:10
        def sortField = params.sortField?:""
        def sortDirection = params.dir?:"desc"

        if (params.dir && !params.sortField) {
            sortField = "score" // default sort (field) of "score" when order is defined on its own
        }

        def requestObj = new SearchRequestParamsDTO(query, filterQuery, startIndex, rows, sortField, sortDirection)
        def searchResults = bieService.searchBie(requestObj)
        log.debug "SearchRequestParamsDTO = " + requestObj

        // empty search -> search for all records
        if (query.isEmpty()) {
            //render(view: '../error', model: [message: "No search term specified"])
            query = "*:*";
        }

        if (filterQuery.size() > 1 && filterQuery.findAll { it.size() == 0 }) {
            // remove empty fq= params IF more than 1 fq param present
            def fq2 = filterQuery.findAll { it } // excludes empty or null elements
            redirect(action: "search", params: [q: query, fq: fq2, start: startIndex, rows: rows, score: sortField, dir: sortDirection])
        }

        if (searchResults instanceof JSONObject && searchResults.has("error")) {
            log.error "Error requesting taxon concept object: " + searchResults.error
            render(view: '../error', model: [message: searchResults.error])
        } else {
            render(view: 'search', model: [
                    searchResults: searchResults?.searchResults,
                    facetMap: utilityService.addFacetMap(filterQuery),
                    query: query?.trim(),
                    filterQuery: filterQuery,
                    idxTypes: utilityService.getIdxtypes(searchResults?.searchResults?.facetResults),
                    isAustralian: false,
                    collectionsMap: utilityService.addFqUidMap(filterQuery)
            ])
        }
    }

    /**
     * Species page - display information about the requested taxa
     *
     * TAXON: a taxon is 'any group or rank in a biological classification in which organisms are related.'
     * It is also any of the taxonomic units. So basically a taxon is a catch-all term for any of the
     * classification rankings; i.e. domain, kingdom, phylum, etc.
     *
     * TAXON CONCEPT: A taxon concept defines what the taxon means - a series of properties
     * or details about what we mean when we use the taxon name.
     *
     */
    def show = {
        def guid = regularise(params.guid)

        def taxonDetails = bieService.getTaxonConcept(guid)
        log.debug "show - guid = ${guid} "

        if (!taxonDetails) {
            log.error "Error requesting taxon concept object: " + guid
            response.status = 404
            render(view: '../error', model: [message: "Requested taxon <b>" + guid + "</b> was not found"])
        } else if (taxonDetails instanceof JSONObject && taxonDetails.has("error")) {
            if (taxonDetails.error?.contains("FileNotFoundException")) {
                log.error "Error requesting taxon concept object: " + guid
                response.status = 404
                render(view: '../error', model: [message: "Requested taxon <b>" + guid + "</b> was not found"])
            } else {
                log.error "Error requesting taxon concept object: " + taxonDetails.error
                render(view: '../error', model: [message: taxonDetails.error])
            }
        } else if (taxonDetails.taxonConcept?.guid && taxonDetails.taxonConcept.guid != guid) {
            // old identifier so redirect to current taxon page
            redirect(uri: "/species/${taxonDetails.taxonConcept.guid}")
        } else {
            def nameSplit = [true: [], false: taxonDetails.commonNames]
            if (pull) {
                nameSplit = taxonDetails.commonNames.groupBy { cn -> pullCategories.contains(cn.status) }
            }
            taxonDetails.standardCommonNames = nameSplit[false]
            taxonDetails.pullCommonNames = nameSplit[true]
            render(view: 'show', model: [
                    tc: taxonDetails,
                    statusRegionMap: utilityService.getStatusRegionCodes(),
                    infoSourceMap:[],
                    textProperties: [],
                    synonyms: utilityService.getSynonymsForTaxon(taxonDetails),
                    isAustralian: false,
                    isRoleAdmin: false, //authService.userInRole(grailsApplication.config.auth.admin_role),
                    userName: "",
                    isReadOnly: grailsApplication.config.ranking.readonly,
                    sortCommonNameSources: utilityService.getNamesAsSortedMap(taxonDetails.commonNames),
                    taxonHierarchy: bieService.getClassificationForGuid(taxonDetails.taxonConcept.guid),
                    childConcepts: bieService.getChildConceptsForGuid(taxonDetails.taxonConcept.guid),
                    speciesList: bieService.getSpeciesList(taxonDetails.taxonConcept?.guid?:guid)
            ])
        }
    }

    /**
     * Display images of species for a given higher taxa.
     * Note: page is AJAX driven so very little is done here.
     */
    def imageSearch = {
        def model = [:]
        if(params.id){
            def taxon = bieService.getTaxonConcept(regularise(params.id))
            model["taxonConcept"] = taxon
        }
        model
    }

    def bhlSearch = {
        render (view: 'bhlSearch')
    }

    def soundSearch = {
        JSONObject result = new JSONObject()
        if (params.id) {
            result = biocacheService.getSoundsForTaxon(params.id)
        }
        render(text: result.toString(), contentType: "application/json", encoding: "UTF-8")
    }

    /**
     * Do logouts through this app so we can invalidate the session.
     *
     * @param casUrl the url for logging out of cas
     * @param appUrl the url to redirect back to after the logout
     */
    def logout = {
        session.invalidate()
        redirect(url:"${params.casUrl}?url=${params.appUrl}")
    }

    private regularise(String guid) {
        if (!guid)
            return guid
        if (guid ==~ BROKEN_URLPATTERN) {
            guid = guid.replaceFirst(":/", "://")
        }
        return guid
    }

}