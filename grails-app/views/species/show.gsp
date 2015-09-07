%{--
  - Copyright (C) 2014 Atlas of Living Australia
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
<%@ page contentType="text/html;charset=UTF-8" %>
<g:set var="alaUrl" value="${grailsApplication.config.ala.baseURL}"/>
<g:set var="biocacheUrl" value="${grailsApplication.config.biocache.baseURL}"/>
<g:set var="speciesListUrl" value="${grailsApplication.config.speciesList.baseURL}"/>
<g:set var="spatialPortalUrl" value="${grailsApplication.config.spatial.baseURL}"/>
<g:set var="collectoryUrl" value="${grailsApplication.config.collectory.baseURL}"/>
<g:set var="citizenSciUrl" value="${grailsApplication.config.sightings.guidUrl}"/>
<g:set var="alertsUrl" value="${grailsApplication.config.alerts.url}"/>
<g:set var="guid" value="${tc?.previousGuid?:tc?.taxonConcept?.guid?:''}"/>
<g:set var="sciNameFormatted"><bie:formatSciName name="${tc?.taxonConcept?.nameString}" rankId="${tc?.taxonConcept?.rankID?:0}"/></g:set>
<g:set var="synonymsQuery"><g:each in="${tc?.synonyms}" var="synonym" status="i">\"${synonym.nameString}\"<g:if test="${i < tc.synonyms.size() - 1}"> OR </g:if></g:each></g:set>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${tc?.taxonConcept?.nameString} ${(tc?.commonNames) ? ' : ' + tc?.commonNames?.get(0)?.nameString : ''} | ${raw(grailsApplication.config.skin.orgNameLong)}</title>
    <meta name="layout" content="${grailsApplication.config.skin.layout}"/>
    <r:require module="show"/>
</head>
<body class="page-taxon">
    <section class="container">
        <header class="pg-header">
            <g:if test="${taxonHierarchy && taxonHierarchy.size()>1}">
            <div class="taxonomy-bcrumb">
                <ol class="list-inline breadcrumb">
                    <g:each in="${taxonHierarchy}" var="taxon">
                        <g:if test="${taxon.guid != tc.taxonConcept.guid}">
                            <li><g:link controller="species" action="show" params="[guid:taxon.guid]">${taxon.scientificName}</g:link></li>
                        </g:if>
                        <g:else>
                            <li>${taxon.scientificName}</li>
                        </g:else>
                    </g:each>
                </ol>
            </div>
            </g:if>
            <div class="header-inner">
                <h1>
                    <bie:formatSciName name="${tc?.taxonConcept?.nameString}" rankId="${tc?.taxonConcept?.rankID?:0}"/>
                    <span>${tc?.taxonConcept?.author?:""}</span></h1>
                <g:set var="commonNameDisplay" value="${(tc?.commonNames) ? tc?.commonNames?.opt(0)?.nameString : ''}"/>
                <g:if test="${commonNameDisplay}">
                    <h2>${commonNameDisplay}</h2>
                </g:if>
                <h5 class="inline-head taxon-rank">${tc.taxonConcept.rankString}</h5>
                <h5 class="inline-head name-authority">
                    <strong>Name authority:</strong>
                    ${tc?.taxonConcept.nameAuthority?:grailsApplication.config.defaultNameAuthority}
                </h5>
            </div>
        </header>

        <div id="main-content" class="main-content panel panel-body">
            <div class="taxon-tabs">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#overview" data-toggle="tab">Overview</a></li>
                    <li><a href="#gallery" data-toggle="tab">Gallery</a></li>
                    <li><a href="#names" data-toggle="tab">Names</a></li>
                    <li><a href="#classification" data-toggle="tab">Classification</a></li>
                    <li><a href="#records" data-toggle="tab">Records</a></li>
                    <li><a href="#literature" data-toggle="tab">Literature</a></li>
                    <li><a href="#sequences" data-toggle="tab">Sequences</a></li>
                    <li><a href="#data-providers" data-toggle="tab">Data Providers</a></li>
                </ul>
                <div class="tab-content">

                    <section class="tab-pane fade in active" id="overview">
                        <div class="row taxon-row">
                            <div class="col-md-6">

                                <div class="taxon-summary-gallery">
                                    <div class="main-img">
                                        <a class="lightbox-img"
                                           data-toggle="lightbox"
                                           data-gallery="taxon-summary-gallery"
                                           data-parent=".taxon-summary-gallery"
                                           data-title=""
                                           data-footer=""
                                           href="">
                                            <img class="mainOverviewImage img-responsive" src="">
                                        </a>
                                        <div class="caption mainOverviewImageInfo"></div>
                                    </div>

                                    <div class="thumb-row hide">
                                        <div id="overview-thumbs"></div>
                                        <div id="more-photo-thumb-link" class="taxon-summary-thumb" style="">
                                            <a class="more-photos tab-link" href="#gallery" title="More Photos"><span>+</span></a>
                                        </div>
                                    </div>
                                </div>

                                <div id="listContent">
                                </div>


                                <div id="descriptiveContent">
                                </div>

                                <div class="panel panel-default panel-resources">
                                    <div class="panel-heading">
                                        <h3 class="panel-title">Online Resources</h3>
                                    </div>
                                    <div class="panel-body">
                                        <ul>
                                            <li><a href="http://www.gbif.org/species/search?q=${tc?.taxonConcept?.nameString}">GBIF</a></li>
                                            <li><a href="#">Encyclopaedia of Life</a></li>
                                            <li><a href="#">Biodiversity Heritage Library</a></li>
                                            <li><a href="#">PESI</a></li>
                                            <li><a href="#">ARKive</a></li>
                                            <li><a href="#">Flickr</a></li>
                                            <li><a href="#">Wikipedia</a></li>
                                        </ul>
                                    </div>
                                </div>

                            </div><!-- end col 1 -->

                            <div class="col-md-6">

                                <div class="taxon-map">
                                    <div id="leafletMap"></div>
                                    <div class="map-buttons">
                                        <a class="btn btn-primary btn-lg" href="${biocacheUrl}/occurrences/search?q=${tc?.taxonConcept?.nameString}#tab_mapView" role="button">View Interactive Map</a>
                                        <a class="btn btn-primary btn-lg" href="${biocacheUrl}/occurrences/search?q=${tc?.taxonConcept?.nameString}#tab_recordsView" role="button">View Locations</a>
                                    </div>
                                </div>

                                <div class="panel panel-default panel-actions">
                                    <div class="panel-body">
                                        <ul class="list-unstyled">
                                            <li><a href="${citizenSciUrl}${tc.taxonConcept.guid}"><span class="glyphicon glyphicon-map-marker"></span> Record a sighting</a></li>
                                            <li><a href="${citizenSciUrl}${tc.taxonConcept.guid}"><span class="glyphicon glyphicon-camera"></span> Submit a photo</a></li>
                                            %{--<li><a href="#"><span class="glyphicon glyphicon-download"></span> Download a fact sheet</a></li>--}%
                                            <li><a href="${alertsUrl}"><span class="glyphicon glyphicon-bell"></span> Receive alerts when new records are added</a></li>
                                            %{--<li><a href="#"><span class="glyphicon glyphicon-comment"></span> Start a topic about this species on the forum</a></li>--}%
                                        </ul>
                                    </div>
                                </div>

                                <div class="panel panel-default panel-stats">
                                    <div class="panel-heading">
                                        <h3 class="panel-title">Statistics</h3>
                                    </div>
                                    <div class="panel-body">
                                        <div class="row">
                                            <div class="col-sm-3 col-xs-5">
                                                <img class="img-responsive" src="http://www.cerulean.co.nz/atlas/images/demo-stats-chart.png">
                                            </div>
                                            <div class="col-sm-9 col-xs-7">
                                                <p><strong>58%</strong> of records fully verified.</p>
                                                <p><a class="tab-link" href="#records">More statistics</a></p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-footer">
                                        <div class="row">
                                            <div class="col-sm-6">
                                                <p><strong><span class="occurenceCount"></span></strong> occurrence record</p>
                                            </div>
                                            <div class="col-sm-6">
                                                <p><strong><span class="datasetCount"></span></strong> datasets</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="panel panel-default panel-data-providers">
                                    <div class="panel-heading">
                                        <h3 class="panel-title">Data Providers</h3>
                                    </div>
                                    <div class="panel-body">
                                        <p><strong><span class="datasetCount"></span></strong> datasets have provided data to the ${grailsApplication.config.skin.orgNameShort} for this ${tc.taxonConcept.rankString}.</p>
                                        <p><a class="tab-link" href="#data-providers">Browse the list of data providers</a> and find organisations you can join if you are
                                        interested in participating in a survey for
                                        <g:if test="${tc.taxonConcept?.rankID > 6000}">
                                            species like ${sciNameFormatted}
                                        </g:if>
                                        <g:else>
                                            species of ${sciNameFormatted}.
                                        </g:else>
                                        </p>
                                    </div>
                                </div>

                            </div><!-- end col 2 -->
                        </div>
                    </section>

                    <section class="tab-pane fade" id="gallery">
                        <div id="cat_types" class="hide">
                            <h2>Types</h2>
                            <div class="taxon-gallery"></div>
                        </div>
                        <div id="cat_specimens" class="hide">
                            <h2>Specimens</h2>
                            <div class="taxon-gallery"></div>
                        </div>
                        <div id="cat_other" class="hide">
                            <h2>Images</h2>
                            <div class="taxon-gallery"></div>
                        </div>
                        <div id="cat_nonavailable">
                            <h2>No images available for this taxon</h2>
                            <p>
                                If you have images for this taxon that you would like to share
                                with ${raw(grailsApplication.config.skin.orgNameLong)},
                                please upload using the upload tools.
                            </p>
                        </div>
                    </section>

                    <section class="tab-pane fade" id="names">
                    <h2>Names and sources</h2>
                    <table class="table name-table  table-responsive">
                        <thead>
                            <tr>
                                <th>Accepted name</th>
                                <th>Source</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><bie:formatSciName name="${tc?.taxonConcept?.nameString}" rankId="${tc?.taxonConcept?.rankID?:0}"/> ${authorship}</td>
                                <td class="source">
                                    <ul><li><a href="${tc.taxonConcept.infoSourceURL}" target="_blank" class="external">${tc.taxonConcept.nameAuthority}</a></li></ul>
                                </td>
                            </tr>
                            <g:if test="${(tc.taxonName && tc.taxonName.publishedIn) || tc.taxonConcept.publishedIn}">
                                <tr class="cite">
                                    <td colspan="2">
                                        <cite>Published in: <a href="#" target="_blank" class="external">${tc.taxonName?.publishedIn?:tc.taxonConcept.publishedIn}</a></cite>
                                    </td>
                                </tr>
                            </g:if>
                        </tbody>
                    </table>

                    <g:if test="${tc.synonyms}">
                        <table class="table name-table table-responsive">
                            <thead>
                                <tr>
                                    <th>Synonyms</th>
                                    <th>Source</th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:each in="${tc.synonyms}" var="synonym">
                                    <tr>
                                        <td><bie:formatSciName name="${synonym.nameString}" rankId="${tc.taxonConcept?.rankID}"/> ${synonym.author}</td>
                                        <td class="source">
                                            <ul>
                                                <g:if test="${!synonym.infoSourceURL}"><li><a href="${tc.taxonConcept.infoSourceURL}" target="_blank" class="external">${tc.taxonConcept.infoSourceName}</a></li></g:if>
                                                <g:else><li><a href="${synonym.infoSourceURL}" target="_blank" class="external">${synonym.infoSourceName}</a></li></g:else>
                                            </ul>
                                        </td>
                                    </tr>
                                    <g:if test="${synonym.publishedIn || synonym.referencedIn}">
                                        <tr class="cite">
                                            <td colspan="2">
                                                <cite>Published in: <span class="publishedIn">${synonym.publishedIn?:synonym.referencedIn}</span></cite>
                                            </td>
                                        </tr>
                                    </g:if>
                                </g:each>
                            </tbody>
                        </table>
                    </g:if>
                    <g:if test="${tc.commonNames}">
                        <table class="table name-table table-responsive">
                            <thead>
                                <tr>
                                    <th>Common name</th>
                                    <th>Source</th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:each in="${sortCommonNameSources}" var="cn">
                                    <g:set var="cNames" value="${cn.value}" />
                                    <%-- special treatment for <div> id and cookie name/value. matchup with Ranking Controller.rankTaxonCommonNameByUser --%>
                                    <g:set var="nkey" value="${cn.key}" />
                                    <g:set var="fName" value="${nkey?.trim()?.hashCode()}" />
                                    <%-- javascript treatment: manual translate special character, because string:encodeURL cannot handle non-english character --%>
                                    <g:set var="enKey" value="${nkey?.encodeAsJavaScript()}" />
                                    <tr>
                                        <td>
                                            ${nkey}
                                        </td>
                                        <td class="source">
                                            <ul>
                                            <g:each in="${sortCommonNameSources?.get(nkey)}" var="commonName">
                                                <li><a href="${commonName.infoSourceURL}" onclick="window.open(this.href); return false;">${commonName.infoSourceName}</a></li>
                                            </g:each>
                                            </ul>
                                        </td>
                                    </tr>
                                </g:each>
                        </tbody></table>
                    </g:if>
                    </section>

                    <section class="tab-pane fade" id="classification">

                        <h2>
                            <g:if test="${grailsApplication.config.classificationSupplier}">
                                ${grailsApplication.config.classificationSupplier} classification
                            </g:if>
                            <g:else>
                                Classification
                            </g:else>
                        </h2>
                        <g:each in="${taxonHierarchy}" var="taxon">
                            <!-- taxon = ${taxon} -->
                            <g:if test="${taxon.guid != tc.taxonConcept.guid}">
                                <dl><dt><g:if test="${taxon.rankId?:0 !=0}">${taxon.rank}</g:if></dt>
                                <dd><a href="${request?.contextPath}/species/${taxon.guid}#classification" title="${taxon.rank}">
                                    <bie:formatSciName name="${taxon.scientificName}" rankId="${taxon.rankId?:0}"/>
                                    <g:if test="${taxon.commonNameSingle}">: ${taxon.commonNameSingle}</g:if></a>
                                </dd>
                            </g:if>
                            <g:elseif test="${taxon.guid == tc.taxonConcept.guid}">
                                <dl><dt id="currentTaxonConcept">${taxon.rank}</dt>
                                <dd><span><bie:formatSciName name="${taxon.scientificName}" rankId="${taxon.rankId?:0}"/>
                                    <g:if test="${taxon.commonNameSingle}">: ${taxon.commonNameSingle}</g:if></span>
                                </dd>
                            </g:elseif>
                            <g:else><!-- Taxa ${taxon}) should not be here! --></g:else>
                        </g:each>
                        <dl class="child-taxa">
                            <g:set var="currentRank" value=""/>
                            <g:each in="${childConcepts}" var="child" status="i">
                                <g:set var="currentRank" value="${child.rank}"/>
                                <dt>${child.rank}</dt>
                                <g:set var="taxonLabel"><bie:formatSciName name="${child.nameComplete ? child.nameComplete : child.name}"
                                                                           rankId="${child.rankId?:0}"/><g:if test="${child.commonNameSingle}">: ${child.commonNameSingle}</g:if></g:set>
                                <dd><a href="${request?.contextPath}/species/${child.guid}#classification">${taxonLabel.trim()}</a>&nbsp;
                                </dd>
                            </g:each>
                        </dl>
                        <g:each in="${taxonHierarchy}" var="taxon">
                            </dl>
                        </g:each>
                    </section>

                    <section class="tab-pane fade" id="records">
                        <h2>Occurrence records</h2>
                        <div id="occurrenceRecords">
                            <p><a href="${biocacheUrl}/occurrences/search?q=${tc?.taxonConcept?.nameString?:''}">View
                            list of all <span id="occurenceCount"></span> occurrence records for this taxon</a></p>
                            <div id="recordBreakdowns" style="display: block;">
                                <h2>Charts showing breakdown of occurrence records</h2>
                                <div id="chartsHint">Hint: click on chart elements to view that subset of records</div>
                                <div id="charts" class=""></div>
                            </div>
                        </div>
                    </section>

                    <section class="tab-pane fade" id="literature">
                        <div id="bhl-integration">
                            <h2>Name references found in the Biodiversity Heritage Library</h2>
                            <div id="bhl-results-list" class="result-list">
                            </div>
                        </div>

                        <div id="trove-integration" class="hide">
                            <h2>Name references found in the TROVE - NLA </h2>
                            <p>Number of matches in TROVE: 75</p>
                            <div class="result-list">
                            </div>
                        </div>

                    </section>

                    <section class="tab-pane fade" id="sequences">
                        <h2>Genbank</h2>
                        <p class="genbankResultCount"></p>
                        <div class="genbank-results result-list">
                        </div>
                    </section>
                    <section class="tab-pane fade" id="data-providers">
                        <h2>Data Providers</h2>
                        <table id="data-providers-list"  class="table name-table  table-responsive">
                            <thead>
                            <tr>
                                <th>Data provider</th>
                                <th>Records</th>
                            </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </section>
                </div>
            </div>
        </div><!-- end main-content -->
    </section>

    <!-- taxon-summary-thumb template -->
    <div id="taxon-summary-thumb-template"
         class="taxon-summary-thumb hide"
         style="">
        <a data-toggle="lightbox"
           data-gallery="taxon-summary-gallery"
           data-parent=".taxon-summary-gallery"
           data-title=""
           data-footer=""
           href="">
        </a>
    </div>

    <!-- thumbnail template -->
    <a id="taxon-thumb-template"
       class="taxon-thumb hide"
       data-toggle="lightbox"
       data-gallery="main-image-gallery"
       data-title=""
       data-footer=""
       href="">
        <img src="" alt="">
        <div class="thumb-caption caption-brief"></div>
        <div class="thumb-caption caption-detail"></div>
    </a>

    <!-- eol -->
    <div id="descriptionTemplate" class="panel panel-default panel-description" style="display:none;">
        <div class="panel-heading">
            <h3 class="panel-title title"></h3>
        </div>
        <div class="panel-body">
            <p class="content"></p>
        </div>
        <div class="panel-footer">
            <p>Source: <a href="#" class="providedBy"></a> <span class="rights"></span></p>
        </div>
    </div>

    <!-- genbank -->
    <div id="genbankTemplate" class="result hide">
        <h3><a href="" class="externalLink"></a></h3>
        <p class="description"></p>
        <p class="furtherDescription"></p>
    </div>

<r:script>
    // global var to pass GSP vars into JS file
    var SHOW_CONF = {
        biocacheUrl:        "${grailsApplication.config.biocache.baseURL}",
        biocacheServiceUrl: "${grailsApplication.config.biocacheService.baseURL}",
        collectoryUrl:      "${grailsApplication.config.collectory.baseURL}",
        guid:               "${guid}",
        scientificName:     "${tc?.taxonConcept?.nameString?:''}",
        synonymsQuery:      "${synonymsQuery}",
        citizenSciUrl:      "${citizenSciUrl}",
        serverName:         "${grailsApplication.config.grails.serverURL}",
        speciesListUrl:     "${grailsApplication.config.speciesList.baseURL}",
        bieUrl:             "${grailsApplication.config.bie.baseURL}",
        alertsUrl:          "${grailsApplication.config.alerts.baseUrl}",
        remoteUser:         "${request.remoteUser?:''}",
        eolUrl:             "${createLink(controller: 'externalSite', action:'eol',params:[s:tc?.taxonConcept?.nameString?:''])}",
        genbankUrl:         "${createLink(controller: 'externalSite', action:'genbank',params:[s:tc?.taxonConcept?.nameString?:''])}",
        scholarUrl:         "${createLink(controller: 'externalSite', action:'scholar',params:[s:tc?.taxonConcept?.nameString?:''])}",
        soundUrl:           "${createLink(controller: 'species', action:'soundSearch',params:[s:tc?.taxonConcept?.nameString?:''])}",
        eolLanguage:        "${grailsApplication.config.eol.lang}",
        defaultDecimalLatitude: ${grailsApplication.config.defaultDecimalLatitude},
        defaultDecimalLongitude: ${grailsApplication.config.defaultDecimalLongitude},
        defaultZoomLevel: ${grailsApplication.config.defaultZoomLevel},
        mapAttribution: "${raw(grailsApplication.config.skin.orgNameLong)}",
        mapboxId: "${grailsApplication.config.map.mapbox.id}",
        mapboxToken: "${grailsApplication.config.map.mapbox.token}",
        mapQueryContext: "${grailsApplication.config.biocacheService.queryContext}"
    }
    // load google charts api
    google.load("visualization", "1", {packages:["corechart"]});

    $(function(){
        showSpeciesPage();
    })
</r:script>


</body>
</html>