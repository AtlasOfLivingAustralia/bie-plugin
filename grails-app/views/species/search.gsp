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
<!doctype html>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.skin.layout}"/>
    <title>${query} | Search | ${grailsApplication.config.skin.orgNameLong}</title>
    <r:require modules="search"/>
    <r:script disposition='head'>
        // global var to pass GSP vars into JS file
        SEARCH_CONF = {
            query: "${BieTagLib.escapeJS(query)}",
            serverName: "${grailsApplication.config.grails.serverURL}",
            bieUrl: "${grailsApplication.config.bie.baseURL}",
            biocacheUrl: "${grailsApplication.config.biocache.baseURL}",
            biocacheServicesUrl: "${grailsApplication.config.biocacheService.baseURL}",
            bhlUrl: "${grailsApplication.config.bhl.baseURL}"
        }
    </r:script>
</head>
<body class="general-search page-search">
    %{--<header id="page-header" class="page-heading">--}%
        %{--<div class="inner row-fluid">--}%
            %{--<div id="breadcrumb" class="span12">--}%
                %{--<ol class="breadcrumb">--}%
                    %{--<li><a href="${alaUrl}">Home</a> <span class=" icon icon-arrow-right"></span></li>--}%
                    %{--<li class="active">Search the ${grailsApplication.config.skin.orgNameShort}</li>--}%
                %{--</ol>--}%
            %{--</div>--}%
        %{--</div>--}%
        %{--<hgroup class="row-fluid">--}%
            %{--<div class="span9">--}%
                %{--<g:if test="${searchResults.totalRecords}">--}%
                    %{--<h2>Search for "<b>${query.replaceFirst(/^\*$/, "all records")}</b>" returned <g:formatNumber number="${searchResults.totalRecords}" type="number"/> results</h2>--}%
                %{--</g:if>--}%
                %{--<g:else>--}%
                    %{--<h2>Search for <b>${query}</b> did not match any documents</h2>--}%
                %{--</g:else>--}%
                %{--<div class="inner-search-form">--}%
                    %{--<form class="form-search" action="${grailsApplication.config.grails.serverURL}/search">--}%
                        %{--<div class="input-append">--}%
                            %{--<input type="text" class="search-query input-xxlarge" name="q" id="search-2013"  placeholder="Search the Atlas" autocomplete="off" value="${params.q}"/>--}%
                            %{--<button type="submit" class="btn"><i class="icon-search" style="margin-left:-3px;"></i></button>--}%
                        %{--</div>--}%
                    %{--</form>--}%
                %{--</div>--}%
            %{--</div>--}%
            %{--<div class="span3 well well-small hidden-phone" id="relatedSearches">--}%
                %{--<!-- content inserted via jQuery -->--}%
            %{--</div>--}%
        %{--</hgroup>--}%
    %{--</header>--}%

<section class="container">

    <header class="pg-header">
        <div class="row">
            <div class="col-sm-9">
                <h1>
                    Search for "<strong>${query.replaceFirst(/^\*$/, "all records")}</strong>"
                    returned <g:formatNumber number="${searchResults.totalRecords}" type="number"/>
                 </h1>
            </div>
            <div class="col-sm-3">
                <div id="related-searches" class="related-searches hide">
                    <h4>Related Searches</h4>
                    <ul class="list-unstyled"></ul>
                </div>
            </div>
        </div>
    </header>

    <div class="main-content">
    <g:if test="${searchResults.totalRecords}">
        <g:set var="paramsValues" value="${[:]}"/>
        <div class="row">
            <div class="col-sm-3">
                <div class="well refine-box">
                    <h2 class="hidden-xs">Refine results</h2>
                    <h2 class="visible-xs"><a href="#refine-options" data-toggle="collapse"><span class="glyphicon glyphicon-chevron-down" aria-hidden="true"></span> Refine results</a>
                    </h2>

                    <div id="refine-options" class="collapse mobile-collapse">
                        <g:if test="${query && filterQuery}">
                            <g:set var="queryParam">q=${query.encodeAsHTML()}<g:if test="${!filterQuery.isEmpty()}">&fq=${filterQuery?.join("&fq=")}</g:if></g:set>
                        </g:if>
                        <g:else>
                            <g:set var="queryParam">q=${query.encodeAsHTML()}<g:if test="${params.fq}">&fq=${fqList?.join("&fq=")}</g:if></g:set>
                        </g:else>
                        <g:if test="${searchResults.query}">
                            <g:set var="downloadParams">q=${searchResults.query?.encodeAsHTML()}<g:if test="${params.fq}">&fq=${params.list("fq")?.join("&fq=")?.trim()}</g:if></g:set>
                        </g:if>
                        <g:if test="${facetMap}">
                                <div class="current-filters" id="currentFilters">
                                    <h3>Current filters</h3>
                                    <ul class="list-unstyled">
                                        <g:each var="item" in="${facetMap}" status="facetIdx">
                                            <li>
                                                <g:set var="closeLink">&nbsp;<a href="#" onClick="javascript:removeFacet(${facetIdx}); return true;" title="remove filter"><span class="glyphicon glyphicon-remove-sign"></span></a></g:set>
                                                <g:if test="${item.key?.contains("uid")}">
                                                    <g:set var="resourceType">${item.value}_resourceType</g:set>
                                                    ${collectionsMap?.get(resourceType)}: <strong>&nbsp;${collectionsMap?.get(item.value)}</strong>${closeLink}
                                                </g:if>
                                                <g:else>
                                                    <g:message code="facet.${item.key}" default="${item.key}"/>: <strong><g:message code="${item.key}.${item.value}" default="${item.value}"/></strong>${closeLink}
                                                </g:else>
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
                                    <a class="expand-options" href="javascript:void(0)">
                                        More
                                    </a>
                                </g:if>
                                </div>
                            </g:if>
                        </g:each>
                    </div><!-- refine-options -->
                </div><!-- refine-box -->
            </div>

            <ol class="col-sm-9">

                <div class="result-options">

                    <g:if test="${idxTypes.contains("TAXON")}">
                        <div class="download-button pull-right">
                        <g:set var="downloadUrl" value="${grailsApplication.config.bie.baseURL}/ws/download/?${downloadParams}${appendQueryParam}&sort=${searchResults.sort}&dir=${searchResults.dir}"/>
                        <button onclick="window.location='${downloadUrl}'" value="Download"
                               title="Download a list of taxa for your search" class="btn btn-small">Download
                        </button>
                        </div>
                    </g:if>

                    <form class="form-inline">
                        <div class="form-group">
                            <label for="per-page">Results per page</label>
                            <select class="form-control input-sm" id="per-page" name="per-page">
                                <option value="10" ${(params.rows == '10') ? "selected=\"selected\"" : ""}>10</option>
                                <option value="20" ${(params.rows == '20') ? "selected=\"selected\"" : ""}>20</option>
                                <option value="50" ${(params.rows == '50') ? "selected=\"selected\"" : ""}>50</option>
                                <option value="100" ${(params.rows == '100') ? "selected=\"selected\"" : ""} >100</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="sort-by">Sort by</label>
                            <select class="form-control input-sm" id="sort-by" name="sort-by">
                                <option value="score" ${(params.sortField == 'score') ? "selected=\"selected\"" : ""}>best match</option>
                                <option value="scientificName" ${(params.sortField == 'scientificName') ? "selected=\"selected\"" : ""}>scientific name</option>
                                <option value="commonNameSingle" ${(params.sortField == 'commonNameSingle') ? "selected=\"selected\"" : ""}>common name</option>
                                <option value="rank" ${(params.sortField == 'rank') ? "selected=\"selected\"" : ""}>taxon rank</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="sort-order">Sort order</label>
                            <select class="form-control input-sm" id="sort-order" name="sort-order">
                                <option value="asc" ${(params.dir == 'asc') ? "selected=\"selected\"" : ""}>normal</option>
                                <option value="desc" ${(params.dir == 'desc') ? "selected=\"selected\"" : ""}>reverse</option>
                            </select>
                        </div>
                    </form>

                </div><!-- result-options -->

                <input type="hidden" value="${pageTitle}" name="title"/>
                <ol class="search-results-list list-unstyled">

                    <g:each var="result" in="${searchResults.results}">
                        <li class="search-result clearfix">

                        <g:set var="sectionText"><g:if test="${!facetMap.idxtype}"><span><b>Section:</b> <g:message code="idxType.${result.idxType}"/></span></g:if></g:set>
                            <g:if test="${result.has("idxType") && result.idxType == 'TAXON'}">

                                <g:set var="speciesPageLink">${request.contextPath}/species/${result.linkIdentifier?:result.guid}</g:set>
                                <g:if test="${result.image}">
                                    <div class="result-thumbnail">
                                        <a href="${speciesPageLink}">
                                            <img src="http://images.ala.org.au/image/proxyImageThumbnail?imageId=${result.image}" alt="">
                                        </a>
                                    </div>
                                </g:if>

                                <h3>${result.rank}:
                                    <a href="${speciesPageLink}"><bie:formatSciName rankId="${result.rankID}"
                                                       name="${(result.nameComplete) ? result.nameComplete : result.name}"
                                                       acceptedName="${result.acceptedConceptName}"/></a>
                                    <g:if test="${result.commonNameSingle}"><span class="commonNameSummary">&nbsp;&ndash;&nbsp;${result.commonNameSingle}</span></g:if>
                                </h3>
                                <g:if test="${result.commonName != result.commonNameSingle}"><p class="alt-names">${result.commonName}</p></g:if>
                                <g:if test="${result.kingdom}"><p class="summmary-info"><strong>Kingdom:</strong> ${result.kingdom}</p></g:if>
                                <ul class="summary-actions list-inline">
                                    <li><a href="${grailsApplication.config.sightings.guidUrl}${result.guid}">Record a sighting/share a photo</a></li>
                                    <g:if test="${result?.occCount?:0 > 0}">
                                        <li>
                                        <a href="${biocacheUrl}/occurrences/taxa/${result.guid}">Occurrences:
                                            <g:formatNumber number="${result.occCount}" type="number"/></a></span>
                                        </li>
                                    </g:if>
                                </ul>
                            </g:if>
                            <g:elseif test="${result.has("regionTypeName") && result.get("regionTypeName")}">
                                <h4><g:message code="idxType.${result.idxType}"/>:
                                    <a href="${result.guid}">${result.name}</a></h4>
                                <p>
                                    <span>Region type: ${result.regionTypeName}</span>
                                    <!-- ${sectionText} -->
                                </p>
                            </g:elseif>
                            <g:elseif test="${result.has("institutionName") && result.get("institutionName")}">
                                <h4><g:message code="idxType.${result.idxType}"/>:
                                    <a href="${result.guid}">${result.name}</a></h4>
                                <p>
                                    <span>${result.institutionName}</span>
                                    <!-- ${sectionText} -->
                                </p>
                            </g:elseif>
                            <g:elseif test="${result.has("acronym") && result.get("acronym")}">
                                <h4><g:message code="idxType.${result.idxType}"/>:
                                    <a href="${result.guid}">${result.name}</a></h4>
                                <p>
                                    <span>${result.acronym}</span>
                                    <!-- ${sectionText} -->
                                </p>
                            </g:elseif>
                            <g:elseif test="${result.has("description") && result.get("description")}">
                                <h4><g:message code="idxType.${result.idxType}"/>:
                                    <a href="${result.guid}">${result.name}</a></h4>
                                <p>
                                    <span class="searchDescription">${result.description?.trimLength(500)}</span>
                                    <!-- ${sectionText} -->
                                </p>
                            </g:elseif>
                            <g:elseif test="${result.has("highlight") && result.get("highlight")}">
                                <h4><g:message code="idxType.${result.idxType}"/>:
                                    <a href="${result.guid}">${result.name}</a></h4>
                                <p>
                                    <span>${result.highlight}</span>
                                    <!-- ${sectionText} -->
                                    %{--<br/>--}%
                                </p>
                            </g:elseif>
                            <g:elseif test="${result.has("idxType") && result.idxType == 'LAYERS'}">
                                <h4><g:message code="idxType.${result.idxType}"/>:
                                    <a href="${result.guid}">${result.name}</a></h4>
                                <p>
                                    <span>${result.highlight}</span>
                                    <g:if test="${result.dataProviderName}"><strong>Source: ${result.dataProviderName}</strong></g:if>
                                </p>
                            </g:elseif>
                            <g:else>
                                <h4><g:message code="idxType.${result.idxType}"/>: <a href="${result.guid}">${result.name}</a></h4>
                                <p><!-- ${sectionText} --></p>
                            </g:else>

                        </li>
                    </g:each>
                </ol><!--close results-->

                <div>
                    <tb:paginate total="${searchResults?.totalRecords}"
                            action="search"
                            params="${[q: params.q, fq: params.fq, dir: params.dir]}"
                    />
                </div>
            </div><!--end .col-wide last-->
        </div><!--end .inner-->
    </g:if>
    </div>
</section>
</body>
</html>