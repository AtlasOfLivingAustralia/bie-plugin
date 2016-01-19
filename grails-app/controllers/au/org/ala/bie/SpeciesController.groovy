/*
 * Copyright (C) 2012 Atlas of Living Australia
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

import org.codehaus.groovy.grails.web.json.JSONObject

/**
 * Species Controller
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
class SpeciesController {

    def bieService
    def utilityService
    def authService
    def biocacheService
    def webService
    def grailsApplication

    /**
     * Search page - display search results fro the BIE (includes results for non-species pages too)
     */
    def search = {
        def query = params.q?:"".trim()
        if(query == "*") query = ""
        def filterQuery = params.list('fq') // will be a list even with only one value
        def startIndex = params.offset?:0
        def rows = params.rows?:10
        def sortField = params.sortField?:""  //FIXME
        def sortDirection = params.dir?:"asc"
        def sort = ""
        if(sortField){
            sort = sortField + "+" + sortDirection
        }

        def requestObj = new SearchRequestParamsDTO(query, filterQuery, startIndex, rows, sort, sortDirection)
        def searchResults = bieService.searchBie(requestObj)
        log.debug "SearchRequestParamsDTO = " + requestObj

        // empty search -> search for all records
        if (query.isEmpty()) {
            //render(view: '../error', model: [message: "No search term specified"])
            query = "*";
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
     */
    def show = {
        def guid = params.guid

        def etc = bieService.getTaxonConcept(guid)
        log.debug "show - guid = ${guid} "

        if (!etc) {
            log.error "Error requesting taxon concept object: " + guid
            response.status = 404
            render(view: '../error', model: [message: "Requested taxon <b>" + guid + "</b> was not found"])
        } else if (etc instanceof JSONObject && etc.has("error")) {
            log.error "Error requesting taxon concept object: " + etc.error
            render(view: '../error', model: [message: etc.error])
        } else {
            render(view: 'show', model: [
                tc: etc,
                statusRegionMap: utilityService.getStatusRegionCodes(),
                infoSourceMap:[],
//                extraImages: bieService.getExtraImages(etc),
                textProperties: [],
                isAustralian: false,
                isRoleAdmin: false, //authService.userInRole(grailsApplication.config.auth.admin_role),
                userName: "",
                isReadOnly: grailsApplication.config.ranking.readonly,
                sortCommonNameSources: utilityService.getNamesAsSortedMap(etc.commonNames),
                taxonHierarchy: bieService.getClassificationForGuid(etc.taxonConcept.guid),
                childConcepts: bieService.getChildConceptsForGuid(etc.taxonConcept.guid),
                speciesList: bieService.getSpeciesList(etc.taxonConcept?.guid?:guid)
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
            def taxon = bieService.getTaxonConcept(params.id)
            model["taxonConcept"] = taxon
        }
        model
    }

    def bhlSearch = {
        render (view: 'bhlSearch')
    }

    def soundSearch = {
        def result = biocacheService.getSoundsForTaxon(params.s)
        render(contentType: "text/json") {
            result
        }
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
}