%{--
  - Copyright (C) 2012 Atlas of Living Australia
  - All Rights Reserved.
  -
  - The contents of this file are subject to the Mozilla Public
  - License Version 1.1 (the "License"); you may not use this file
  - except in compliance with the License. You may obtain a copy of
  - the License at http://www.mozilla.org/MPL/
  -
  - Software distributed under the License is distributed on an "AS
  - IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
  - implied. See the License for the specific language governing
  - rights and limitations under the License.
  --}%
<%@ page import="au.org.ala.bie.BieTagLib" contentType="text/html;charset=UTF-8" %>
<g:set var="alaUrl" value="${grailsApplication.config.ala.baseURL}"/>
<g:set var="biocacheUrl" value="${grailsApplication.config.biocache.baseURL}"/>
<g:set var="fluidLayout" value="${grailsApplication.config.skin?.fluidLayout?:"false".toBoolean()}"/>
<!doctype html>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.skin.layout}"/>
    <title>${query} | ${message(code: 'search.search')} | ${raw(grailsApplication.config.skin.orgNameLong)}</title>
    <meta name="breadcrumb" content="${message(code: 'search.searchresults')}"/>
    <asset:javascript src="search"/>
    <asset:javascript src="atlas"/>
    <asset:stylesheet src="atlas"/>
    <asset:script type="text/javascript">
        // global var to pass GSP vars into JS file
        SEARCH_CONF = {
            searchResultTotal: "${searchResults.totalRecords}",
            bieWebServiceUrl: "${grailsApplication.config.bie.index.url}",
            query: "${BieTagLib.escapeJS(query)}",
            queryTitle: "${searchResults.queryTitle}",
            serverName: "${grailsApplication.config.grails.serverURL}",
            bieUrl: "${grailsApplication.config.bie.baseURL}",
            biocacheUrl: "${grailsApplication.config.biocache.baseURL}",
            biocacheServicesUrl: "${grailsApplication.config.biocacheService.baseURL}",
            bhlUrl: "${grailsApplication.config.bhl.url}",
            biocacheQueryContext: '${raw(grailsApplication.config.biocacheService.queryContext)}',
            geocodeLookupQuerySuffix: "${grailsApplication.config.geocode.querySuffix}"
        }
    </asset:script>
    <asset:javascript src="autocomplete-configuration"/>
</head>
<body class="general-search page-search">

<section class="${fluidLayout ? 'container-fluid' : 'container'}">
    <div class="main-content panel panel-body">
        <div class="row margin-bottom-30">
            <div class="col-sm-9">
                <form method="get" action="${g.createLink(controller: 'species', action: 'search')}">
                    <g:each in="${filterQuery}" var="fq">
                        <input name="fq" value="${fq?.encodeAsHTML()}" hidden>
                    </g:each>
                    <input name="sortField" value="${sortField?.encodeAsHTML()}" hidden>
                    <input name="dir" value="${dir?.encodeAsHTML()}" hidden>
                    <div class="input-group">
                        <input id="autocompleteResultPage" type="text" name="q" placeholder="Search species, datasets, and more..." class="form-control" autocomplete="off" value="${query?.encodeAsHTML()?:""}" hidden>
                        <span class="input-group-btn">
                            <button class="btn btn-primary" title="submit">
                                ${message(code: 'search.search')}
                            </button>
                        </span>
                    </div>
                </form>
            </div>
        </div>


        <header class="pg-header">
            <div class="row">
                <div class="col-sm-9">
                    <h1>
                        ${message(code: 'search.searchfor')} <strong>${searchResults.queryTitle == "*:*" ? message(code: 'search.everything') : searchResults.queryTitle}</strong>
                        ${message(code: 'search.returned')} <g:formatNumber number="${searchResults.totalRecords}" type="number"/>
                        ${message(code: 'search.results')}
                    </h1>
                </div>
                <div class="col-sm-3">
                    <div id="related-searches" class="related-searches hide">
                        <h4>${message(code: 'search.relatedsearches')}</h4>
                        <ul class="list-unstyled"></ul>
                    </div>
                </div>
            </div>
        </header>

        <g:if test="${searchResults.totalRecords}">
        <g:set var="paramsValues" value="${[:]}"/>
        <div class="row">
            <div class="col-sm-3">
                <div class="well refine-box">
                    <h2 class="hidden-xs">${message(code: 'search.refineresults')}</h2>
                    <h2 class="visible-xs"><a href="#refine-options" data-toggle="collapse mobile-collapse in"><span class="glyphicon glyphicon-chevron-down" aria-hidden="true"></span> Refine results</a>
                    </h2>

                    <div id="refine-options" class="collapse mobile-collapse in">
                        <g:if test="${query && filterQuery}">
                            <g:set var="queryParam">q=${query.encodeAsHTML()}<g:if test="${!filterQuery.isEmpty()}">&fq=${filterQuery?.join("&fq=")}</g:if></g:set>
                        </g:if>
                        <g:else>
                            <g:set var="queryParam">q=${query.encodeAsHTML()}<g:if test="${params.fq}">&fq=${fqList?.join("&fq=")}</g:if></g:set>
                        </g:else>
                        <g:if test="${facetMap}">
                                <div class="current-filters" id="currentFilters">
                                    <h3>Current filters</h3>
                                    <ul class="list-unstyled">
                                        <g:each var="item" in="${facetMap}" status="facetIdx">
                                            <li>
                                                <g:if test="${item.key?.contains("uid")}">
                                                    <g:each var="value" in="${item.value}" status="fvIdx">
                                                        <g:set var="resourceType">${value}_resourceType</g:set>
                                                        <g:if test="${fvIdx > 0}">, </g:if>
                                                        ${collectionsMap?.get(resourceType)}: <strong>&nbsp;${collectionsMap?.get(value)}</strong>
                                                    </g:each>
                                                </g:if>
                                                <g:else>
                                                    <g:message code="facet.${item.key}" default="${item.key}"/>:
                                                    <g:each var="value" in="${item.value}" status="fvIdx">
                                                        <g:if test="${fvIdx > 0}">, </g:if>
                                                        <strong><g:message code="${item.key}.${value}" default="${value}"/></strong>
                                                    </g:each>
                                                </g:else>
                                                <a href="#" onClick="javascript:removeFacet(${facetIdx}); return true;" title="remove filter"><span class="glyphicon glyphicon-remove-sign"></span></a>
                                            </li>
                                        </g:each>
                                    </ul>
                                </div>
                        </g:if>

                        <!-- facets -->
                        <g:each var="facetResult" in="${searchResults.facetResults}">
                            <g:if test="${!facetMap?.get(facetResult.fieldName) && !filterQuery?.contains(facetResult.fieldResult?.opt(0)?.label) && !facetResult.fieldName?.contains('idxtype1') && facetResult.fieldResult.length() > 0 }">

                                <div class="refine-list" id="facet-${facetResult.fieldName}">
                                <h3><g:message code="facet.${facetResult.fieldName}" default="${facetResult.fieldName}"/></h3>
                                <ul class="list-unstyled">
                                    <g:set var="lastElement" value="${facetResult.fieldResult?.get(facetResult.fieldResult.length()-1)}"/>
                                    <g:if test="${lastElement.label == 'before'}">
                                        <li><g:set var="firstYear" value="${facetResult.fieldResult?.opt(0)?.label.substring(0, 4)}"/>
                                            <a href="?${queryParam}${appendQueryParam}&fq=${facetResult.fieldName}:[* TO ${facetResult.fieldResult.opt(0)?.label}]">Before ${firstYear}</a>
                                            (<g:formatNumber number="${lastElement.count}" type="number"/>)
                                        </li>
                                    </g:if>
                                    <g:each var="fieldResult" in="${facetResult.fieldResult}" status="vs">
                                        <g:if test="${vs == 5}">
                                            </ul>
                                            <ul class="collapse list-unstyled">
                                        </g:if>
                                        <g:set var="dateRangeTo"><g:if test="${vs == lastElement}">*</g:if><g:else>${facetResult.fieldResult[vs+1]?.label}</g:else></g:set>
                                        <g:if test="${facetResult.fieldName?.contains("occurrence_date") && fieldResult.label?.endsWith("Z")}">
                                            <li><g:set var="startYear" value="${fieldResult.label?.substring(0, 4)}"/>
                                                <a href="?${queryParam}${appendQueryParam}&fq=${facetResult.fieldName}:[${fieldResult.label} TO ${dateRangeTo}]">${startYear} - ${startYear + 10}</a>
                                                (<g:formatNumber number="${fieldResult.count}" type="number"/>)</li>
                                        </g:if>
                                        <g:elseif test="${fieldResult.label?.endsWith("before")}"><%-- skip --%></g:elseif>
                                        <g:elseif test="${fieldResult.label?.isEmpty()}">
                                        </g:elseif>
                                        <g:else>
                                            <li><a href="?${request.queryString}&fq=${facetResult.fieldName}:%22${fieldResult.label}%22">
                                                <g:message code="${facetResult.fieldName}.${fieldResult.label}" default="${fieldResult.label?:"[unknown]"}"/>
                                            </a>
                                                (<g:formatNumber number="${fieldResult.count}" type="number"/>)
                                            </li>
                                        </g:else>
                                    </g:each>
                                </ul>
                                <g:if test="${facetResult.fieldResult.size() > 5}">
                                    <a class="expand-options" href="javascript:void(0)">${message(code: 'search.more')}</a>
                                </g:if>
                                </div>
                            </g:if>
                        </g:each>
                    </div><!-- refine-options -->
                </div><!-- refine-box -->
            </div>

            <div class="col-sm-9">
                <div class="result-options">

                    <g:if test="${idxTypes.contains("TAXON")}">
                        <div class="download-button pull-right">
                            <g:set var="downloadUrl" value="${grailsApplication.config.bie.index.url}/download?${request.queryString?:''}${grailsApplication.config.bieService.queryContext}"/>
                            <a class="btn btn-default active btn-small" href="${downloadUrl}" title="${message(code: 'search.downloadalist')}">
                                <i class="glyphicon glyphicon-download"></i>
                                ${message(code: 'search.download')}
                            </a>
                        </div>
                    </g:if>

                    <form class="form-inline">
                        <div class="form-group">
                            <label for="per-page">${message(code: 'search.resultsperpage')}</label>
                            <select class="form-control input-sm" id="per-page" name="per-page">
                                <option value="10" ${(params.rows == '10') ? "selected=\"selected\"" : ""}>10</option>
                                <option value="20" ${(params.rows == '20') ? "selected=\"selected\"" : ""}>20</option>
                                <option value="50" ${(params.rows == '50') ? "selected=\"selected\"" : ""}>50</option>
                                <option value="100" ${(params.rows == '100') ? "selected=\"selected\"" : ""} >100</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="sort-by">${message(code: 'search.sortby')}</label>
                            <select class="form-control input-sm" id="sort-by" name="sort-by">
                                <option value="score" ${(params.sortField == 'score') ? "selected=\"selected\"" : ""}>${message(code: 'search.bestmatch')}</option>
                                <option value="scientificName" ${(params.sortField == 'scientificName') ? "selected=\"selected\"" : ""}>${message(code: 'search.scientificname')}</option>
                                <option value="commonNameSingle" ${(params.sortField == 'commonNameSingle') ? "selected=\"selected\"" : ""}>${message(code: 'search.commonname')}</option>
                                <option value="rank" ${(params.sortField == 'rank') ? "selected=\"selected\"" : ""}>${message(code: 'search.taxonrank')}</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="sort-order">${message(code: 'search.sortorder')}</label>
                            <select class="form-control input-sm" id="sort-order" name="sort-order">
                                <option value="asc" ${(params.dir == 'asc') ? "selected=\"selected\"" : ""}>${message(code: 'search.ascending')}</option>
                                <option value="desc" ${(params.dir == 'desc' || !params.dir) ? "selected=\"selected\"" : ""}>${message(code: 'search.descending')}</option>
                            </select>
                        </div>
                    </form>

                </div><!-- result-options -->

                <input type="hidden" value="${pageTitle}" name="title"/>
                <ol id="search-results-list" class="search-results-list list-unstyled">

                    <g:each var="result" in="${searchResults.results}">
                        <li class="search-result clearfix">

                        <g:set var="sectionText"><g:if test="${!facetMap.idxtype}"><span><b>Section:</b> <g:message code="idxType.${result.idxType}"/></span></g:if></g:set>
                            <g:if test="${result.has("idxtype") && result.idxtype == 'TAXON'}">

                                <g:set var="taxonPageLink">${request.contextPath}/species/${result.linkIdentifier ?: result.guid}</g:set>
                                <g:set var="acceptedPageLink">${request.contextPath}/species/${result.acceptedConceptID ?: result.linkIdentifier ?: result.guid}</g:set>
                                <g:if test="${result.image}">
                                    <div class="result-thumbnail">
                                        <a href="${acceptedPageLink}">
                                            <img src="${grailsApplication.config.image.thumbnailUrl}${result.image}" alt="">
                                        </a>
                                    </div>
                                </g:if>

                                <h3>${result.rank}:
                                    <a href="${acceptedPageLink}"><bie:formatSciName rankId="${result.rankID}" taxonomicStatus="${result.taxonomicStatus}" nameFormatted="${result.nameFormatted}" nameComplete="${result.nameComplete}" name="${result.name}" acceptedName="${result.acceptedConceptName}"/></a><%--
                                    --%><g:if test="${result.commonNameSingle}"><span class="commonNameSummary">&nbsp;&ndash;&nbsp;${result.commonNameSingle}</span></g:if><%--
                                    --%><g:if test="${result.favourite}"><span class="favourite favourite-${result.favourite}" title="<g:message code="favourite.${result.favourite}.detail"/>"><g:message code="favourite.${result.favourite}" encodeAs="raw"/></span></g:if>
                                </h3>

                                <g:if test="${result.commonName != result.commonNameSingle}"><p class="alt-names">${result.commonName}</p></g:if>
                                <g:if test="${taxonPageLink != acceptedPageLink}"><p class="alt-names"></p></g:if>
                                <g:each var="fieldToDisplay" in="${grailsApplication.config.additionalResultsFields.split(",")}">
                                    <g:if test='${result."${fieldToDisplay}"}'>
                                        <p class="summary-info"><strong><g:message code="${fieldToDisplay}" default="${fieldToDisplay}"/>:</strong> ${result."${fieldToDisplay}"}</p>
                                    </g:if>
                                </g:each>
                            </g:if>
                            <g:elseif test="${result.has("idxtype") && result.idxtype == 'COMMON'}">
                                <g:set var="speciesPageLink">${request.contextPath}/species/${result.linkIdentifier?:result.taxonGuid}</g:set>
                                <g:set var="commonNameLanguage"><bie:showLanguage lang="${result.language}" format="${false}" default="${message(code: 'label.common', default: 'Common')}"/></g:set>
                                <g:if test="${result.image}">
                                    <div class="result-thumbnail">
                                        <a href="${speciesPageLink}">
                                            <img src="${grailsApplication.config.image.thumbnailUrl}${result.image}" alt="">
                                        </a>
                                    </div>
                                </g:if>
                                <h3><g:message code="idxtype.${result.idxtype}.formatted" default="${result.idxtype}" args="${[commonNameLanguage]}"/>:
                                <a class="commonNameSummary" href="${speciesPageLink}">${result.name}</a><%--
                                --%><g:if test="${result.acceptedConceptName}">&nbsp;&ndash;&nbsp;<bie:formatSciName rankId="${result.rankID}" taxonomicStatus="accepted" name="${result.acceptedConceptName}"/></g:if><%--
                                --%><g:if test="${result.favourite}"><span class="favourite favourite-${result.favourite}" title="<g:message code="favourite.${result.favourite}.detail"/>"><g:message code="favourite.${result.favourite}" encodeAs="raw"/></span></g:if>
                                </h3>
                            </g:elseif>
                            <g:elseif test="${result.has("idxtype") && result.idxtype == 'IDENTIFIER'}">
                                <g:set var="speciesPageLink">${request.contextPath}/species/${result.linkIdentifier?:result.taxonGuid}</g:set>
                                <h4><g:message code="idxtype.${result.idxtype}" default="${result.idxtype}"/>:
                                    <a href="${speciesPageLink}">${result.guid}</a></h4>
                            </g:elseif>
                            <g:elseif test="${result.has("idxtype") && result.idxtype == 'REGION'}">
                                <h4><g:message code="idxtype.${result.idxtype}" default="${result.idxtype}"/>:
                                    <a href="${grailsApplication.config.regions.baseURL}/feature/${result.guid}">${result.name}</a></h4>
                                <p>
                                    <span>${result?.description &&  result?.description != result?.name ?  result?.description : ""}</span>
                                </p>
                            </g:elseif>
                            <g:elseif test="${result.has("idxtype") && result.idxtype == 'LOCALITY'}">
                                <h4><g:message code="idxtype.${result.idxtype}" default="${result.idxtype}"/>:
                                    <bie:constructEYALink result="${result}">
                                        ${result.name}
                                    </bie:constructEYALink>
                                </h4>
                                <p>
                                    <span>${result?.description?:""}</span>
                                </p>
                            </g:elseif>
                            <g:elseif test="${result.has("idxtype") && result.idxtype == 'LAYER'}">
                                <h4><g:message code="idxtype.${result.idxtype}"/>:
                                    <a href="${grailsApplication.config.spatial.baseURL}?layers=${result.guid}">${result.name}</a></h4>
                                <p>
                                    <g:if test="${result.dataProviderName}"><strong>Source: ${result.dataProviderName}</strong></g:if>
                                </p>
                            </g:elseif>
                            <g:elseif test="${result.has("name")}">
                                <h4><g:message code="idxtype.${result.idxtype}" default="${result.idxtype}"/>:
                                    <a href="${result.guid}">${result.name}</a></h4>
                                <p>
                                    <span>${result?.description?:""}</span>
                                </p>
                            </g:elseif>
                            <g:elseif test="${result.has("acronym") && result.get("acronym")}">
                                <h4><g:message code="idxtype.${result.idxtype}"/>:
                                    <a href="${result.guid}">${result.name}</a></h4>
                                <p>
                                    <span>${result.acronym}</span>
                                </p>
                            </g:elseif>
                            <g:elseif test="${result.has("description") && result.get("description")}">
                                <h4><g:message code="idxtype.${result.idxtype}"/>:
                                    <a href="${result.guid}">${result.name}</a></h4>
                                <p>
                                    <span class="searchDescription">${result.description?.trimLength(500)}</span>
                                </p>
                            </g:elseif>
                            <g:elseif test="${result.has("highlight") && result.get("highlight")}">
                                <h4><g:message code="idxtype.${result.idxtype}"/>:
                                    <a href="${result.guid}">${result.name}</a></h4>
                                <p>
                                    <span>${result.highlight}</span>
                                </p>
                            </g:elseif>
                            <g:else>
                                <h4><g:message code="idxtype.${result.idxtype}"/> TEST: <a href="${result.guid}">${result.name}</a></h4>
                            </g:else>
                            <g:if test="${result.has("highlight")}">
                                <p><bie:displaySearchHighlights highlight="${result.highlight}"/></p>
                            </g:if>
                            <g:if test="${result.has("idxtype") && result.idxtype == 'TAXON'}">
                                <ul class="summary-actions list-inline">
                                    <g:if test="${result.rankID < 7000}">
                                        <li><g:link controller="species" action="imageSearch" params="[id:result.guid]">${message(code: 'search.viewimages01')} ${result.rank} ${message(code: 'search.viewimages02')}</g:link></li>
                                    </g:if>

                                    <g:if test="${grailsApplication.config.sightings.url}">
                                        <!--<li><a href="${java.text.MessageFormat.format(grailsApplication.config.sightings.url, URLEncoder.encode(result.guid), URLEncoder.encode(result.name))}"><g:message code="label.recordSighting" default="Record a sighting"/></a></li>-->
                                    </g:if>
                                    <g:if test="${grailsApplication.config.occurrenceCounts.enabled.toBoolean() && result?.occurrenceCount?:0 > 0}">
                                        <li>
                                        <a href="${biocacheUrl}/occurrences/search?q=lsid:${result.guid}">${message(code: 'search.occurrences')}
                                        <g:formatNumber number="${result.occurrenceCount}" type="number"/></a></span>
                                        </li>
                                    </g:if>
                                    <g:if test="${result.acceptedConceptID && result.acceptedConceptID != result.guid}">
                                        <li><g:link controller="species" action="show" params="[guid:result.guid]"><g:message code="taxonomicStatus.${result.taxonomicStatus}" default="${result.taxonomicStatus}"/></g:link></li
                                    </g:if>
                                </ul>
                            </g:if>
                        </li>
                    </g:each>
                </ol><!--close results-->

                <div>
                    <tb:paginate total="${searchResults?.totalRecords}" max="${params.rows}"
                            action="search"
                            params="${[q: params.q, fq: params.fq, dir: params.dir, sortField: params.sortField, rows: params.rows]}"
                    />
                </div>
            </div><!--end .col-wide last-->
        </div><!--end .inner-->
    </g:if>

    </div>
</section>

<div id="result-template" class="row hide">
    <div class="col-sm-12">
        <ol class="search-results-list list-unstyled">
            <li class="search-result clearfix">
                <h4><g:message code="idxtype.LOCALITY"/> : <a class="exploreYourAreaLink" href="">Address here</a></h4>
            </li>
        </ol>
    </div>
</div>

<g:if test="${searchResults.totalRecords == 0}">
    <asset:script type="text/javascript" >
        $(function(){
            console.log(SEARCH_CONF.serverName + "/geo?q=" + SEARCH_CONF.query + ' ' + SEARCH_CONF.geocodeLookupQuerySuffix);
            $.get( SEARCH_CONF.serverName + "/geo?q=" + SEARCH_CONF.query  + ' ' + SEARCH_CONF.geocodeLookupQuerySuffix, function( searchResults ) {
                for(var i=0; i< searchResults.length; i++){
                    var $results = $('#result-template').clone(true);
                    $results.attr('id', 'results-lists');
                    $results.removeClass('hide');
                    console.log(searchResults)
                    if(searchResults.length > 0){
                        $results.find('.exploreYourAreaLink').html(searchResults[i].name);
                        $results.find('.exploreYourAreaLink').attr('href', '${grailsApplication.config.biocache.baseURL}/explore/your-area#' +
                                searchResults[0].latitude  +
                                '|' +  searchResults[0].longitude +
                                '|12|ALL_SPECIES'
                        );
                        $('.main-content').append($results.html());
                    }
                }
            });
        });
    </asset:script>
</g:if>

</body>
</html>
