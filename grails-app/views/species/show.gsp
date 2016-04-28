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
<g:set var="guid" value="${tc?.previousGuid ?: tc?.taxonConcept?.guid ?: ''}"/>
<g:set var="sciNameFormatted"><bie:formatSciName rankId="${tc?.taxonConcept?.rankID}"
                                                 nameFormatted="${tc?.taxonConcept?.nameFormatted}"
                                                 nameComplete="${tc?.taxonConcept?.nameComplete}"
                                                 name="${tc?.taxonConcept?.name}"
                                                 acceptedName="${tc?.taxonConcept?.acceptedConceptName}"/></g:set>
<g:set var="synonymsQuery"><g:each in="${tc?.synonyms}" var="synonym" status="i">\"${synonym.nameString}\"<g:if
        test="${i < tc.synonyms.size() - 1}">OR</g:if></g:each></g:set>
<g:set var="locale" value="${org.springframework.web.servlet.support.RequestContextUtils.getLocale(request)}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${tc?.taxonConcept?.nameString} ${(tc?.commonNames) ? ' : ' + tc?.commonNames?.get(0)?.nameString : ''} | ${raw(grailsApplication.config.skin.orgNameLong)}</title>
    <meta name="layout" content="${grailsApplication.config.skin.layout}"/>
    <r:require modules="show, charts"/>
</head>

<body class="page-taxon">
<section class="container">
    <header class="pg-header">
        <g:if test="${taxonHierarchy && taxonHierarchy.size() > 1}">
            <div class="taxonomy-bcrumb">
                <ol class="list-inline breadcrumb">
                    <g:each in="${taxonHierarchy}" var="taxon">
                        <g:if test="${taxon.guid != tc.taxonConcept.guid}">
                            <li><g:link controller="species" action="show"
                                        params="[guid: taxon.guid]">${taxon.scientificName}</g:link></li>
                        </g:if>
                        <g:else>
                            <li>${taxon.scientificName}</li>
                        </g:else>
                    </g:each>
                </ol>
            </div>
        </g:if>
        <div class="header-inner">
            <h1><bie:formatSciName rankId="${tc?.taxonConcept?.rankID}"
                                   nameFormatted="${tc?.taxonConcept?.nameFormatted}"
                                   nameComplete="${tc?.taxonConcept?.nameComplete}" name="${tc?.taxonConcept?.name}"
                                   acceptedName="${tc?.taxonConcept?.acceptedConceptName}"/></h1>
            <g:set var="commonNameDisplay" value="${(tc?.commonNames) ? tc?.commonNames?.opt(0)?.nameString : ''}"/>
            <g:if test="${commonNameDisplay}">
                <h2>${commonNameDisplay}</h2>
            </g:if>
            <h5 class="inline-head taxon-rank">${tc.taxonConcept.rankString}</h5>
            <h5 class="inline-head name-authority">
                <strong>Name authority:</strong>
                <span class="name-authority">${tc?.taxonConcept.nameAuthority ?: grailsApplication.config.defaultNameAuthority}</span>
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
                                        <a class="more-photos tab-link" href="#gallery"
                                           title="More Photos"><span>+</span></a>
                                    </div>
                                </div>
                            </div>

                            <g:if test="${tc.conservationStatuses}">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h3 class="panel-title">Conservation Status</h3>
                                    </div>

                                    <div class="panel-body">
                                        <ul class="conservationList">
                                            <g:each in="${tc.conservationStatuses.entrySet().sort { it.key }}" var="cs">
                                                <li>
                                                    <g:if test="${cs.value.dr}">
                                                        <a href="${collectoryUrl}/public/showDataResource/${cs.value.dr}"><span
                                                                class="iucn <bie:colourForStatus
                                                                        status="${cs.value.status}"/>">${cs.key}</span>${cs.value.status}
                                                        </a>
                                                    </g:if>
                                                    <g:else>
                                                        <span class="iucn <bie:colourForStatus
                                                                status="${cs.value.status}"/>">${cs.key}</span>${cs.value.status}
                                                    </g:else>
                                                </li>
                                            </g:each>
                                        </ul>
                                    </div>
                                </div>
                            </g:if>

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
                                        <li><a href="http://www.gbif.org/species/search?q=${tc?.taxonConcept?.nameString}">GBIF</a>
                                        </li>
                                        <li><a href="http://eol.org/search?q=${tc?.taxonConcept?.nameString}&show_all=true">Encyclopaedia of Life</a>
                                        </li>
                                        <li><a href="http://www.biodiversitylibrary.org/search?searchTerm=${tc?.taxonConcept?.nameString}#/names">Biodiversity Heritage Library</a>
                                        </li>
                                        <li><a href="http://www.eu-nomen.eu/portal/">PESI</a></li>
                                        <li><a href="http://www.arkive.org/explore/species?q=${tc?.taxonConcept?.nameString}">ARKive</a>
                                        </li>
                                    </ul>
                                </div>
                            </div>

                        </div><!-- end col 1 -->

                        <div class="col-md-6">

                            <div class="taxon-map">
                                <div id="leafletMap"></div>

                                <div class="map-buttons">
                                    <a class="btn btn-primary btn-lg"
                                       href="${biocacheUrl}/occurrences/search?q=lsid:${tc?.taxonConcept?.guid}#tab_mapView"
                                       role="button">View Interactive Map</a>
                                    <a class="btn btn-primary btn-lg"
                                       href="${biocacheUrl}/occurrences/search?q=lsid:${tc?.taxonConcept?.guid}#tab_recordsView"
                                       role="button">View Locations</a>
                                </div>
                            </div>

                            <div class="panel panel-default panel-actions">
                                <div class="panel-body">
                                    <ul class="list-unstyled">
                                        <li><a href="${citizenSciUrl}/${tc.taxonConcept.guid}"><span
                                                class="glyphicon glyphicon-map-marker"></span> Record a sighting</a>
                                        </li>
                                        <li><a href="${citizenSciUrl}/${tc.taxonConcept.guid}"><span
                                                class="glyphicon glyphicon-camera"></span> Submit a photo</a></li>
                                        <li><a id="alertsButton" href="#"><span
                                                class="glyphicon glyphicon-bell"></span> Receive alerts when new records are added
                                        </a></li>
                                    </ul>
                                </div>
                            </div>

                            <div class="panel panel-default panel-data-providers">
                                <div class="panel-heading">
                                    <h3 class="panel-title">Data Providers</h3>
                                </div>

                                <div class="panel-body">
                                    <p><strong><span class="datasetCount"></span>
                                    </strong> datasets have provided data to the ${grailsApplication.config.skin.orgNameShort} for this ${tc.taxonConcept.rankString}.
                                    </p>

                                    <p><a class="tab-link"
                                          href="#data-providers">Browse the list of data providers</a> and find organisations you can join if you are
                                    interested in participating in a survey for
                                    <g:if test="${tc.taxonConcept?.rankID > 6000}">
                                        species like ${raw(sciNameFormatted)}
                                    </g:if>
                                    <g:else>
                                        species of ${raw(sciNameFormatted)}.
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
                            <td>
                                <g:if test="${tc.taxonConcept.infoSourceURL && tc.taxonConcept.infoSourceURL != tc.taxonConcept.datasetURL}"><a
                                        href="${tc.taxonConcept.infoSourceURL}" target="_blank"
                                        class="external"><bie:formatSciName rankId="${tc?.taxonConcept?.rankID}"
                                                                            nameFormatted="${tc?.taxonConcept?.nameFormatted}"
                                                                            nameComplete="${tc?.taxonConcept?.nameComplete}"
                                                                            name="${tc?.taxonConcept?.name}"
                                                                            acceptedName="${tc?.taxonConcept?.acceptedConceptName}"/></a></g:if>
                                <g:else><bie:formatSciName rankId="${tc?.taxonConcept?.rankID}"
                                                           nameFormatted="${tc?.taxonConcept?.nameFormatted}"
                                                           nameComplete="${tc?.taxonConcept?.nameComplete}"
                                                           name="${tc?.taxonConcept?.name}"
                                                           acceptedName="${tc?.taxonConcept?.acceptedConceptName}"/></g:else>
                            </td>
                            <td class="source">
                                <ul><li>
                                    <g:if test="${tc.taxonConcept.datasetURL}"><a href="${tc.taxonConcept.datasetURL}"
                                                                                  target="_blank"
                                                                                  class="external">${tc.taxonConcept.nameAuthority ?: tc.taxonConcept.infoSourceName}</a></g:if>
                                    <g:else>${tc.taxonConcept.nameAuthority ?: tc.taxonConcept.infoSourceName}</g:else>
                                </li></ul>
                            </td>
                        </tr>
                        <g:if test="${(tc.taxonName && tc.taxonName.namePublishedIn) || tc.taxonConcept.namePublishedIn}">
                            <tr class="cite">
                                <td colspan="2">
                                    <cite>Published in: <span
                                            class="publishedIn">${tc.taxonName?.namePublishedIn ?: tc.taxonConcept.namePublishedIn}</span>
                                    </cite>
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
                                    <td>
                                        <g:if test="${synonym.infoSourceURL && synonym.infoSourceURL != synonym.datasetURL}"><a
                                                href="${synonym.infoSourceURL}" target="_blank"
                                                class="external"><bie:formatSciName rankId="${tc?.taxonConcept?.rankID}"
                                                                                    nameFormatted="${synonym.nameFormatted}"
                                                                                    nameComplete="${synonym.nameComplete}"
                                                                                    name="${synonym.nameString}"/></a></g:if>
                                        <g:else><bie:formatSciName rankId="${tc?.taxonConcept?.rankID}"
                                                                   nameFormatted="${synonym.nameFormatted}"
                                                                   nameComplete="${synonym.nameComplete}"
                                                                   name="${synonym.nameString}"/></g:else>
                                    </td>
                                    <td class="source">
                                        <ul><li>
                                            <g:if test="${synonym.datasetURL}"><a href="${synonym.datasetURL}"
                                                                                  target="_blank"
                                                                                  class="external">${synonym.nameAuthority ?: synonym.infoSourceName}</a></g:if>
                                            <g:else>${synonym.nameAuthority ?: synonym.infoSourceName}</g:else>
                                        </li></ul>
                                    </td>
                                </tr>
                                <g:if test="${synonym.namePublishedIn || synonym.referencedIn}">
                                    <tr class="cite">
                                        <td colspan="2">
                                            <cite>Published in: <span
                                                    class="publishedIn">${synonym.namePublishedIn ?: synonym.referencedIn}</span>
                                            </cite>
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
                            <tbody
                        <g:each in="${sortCommonNameSources}" var="cn">
                            <g:set var="cNames" value="${cn.value}"/>
                            <g:set var="nkey" value="${cn.key}"/>
                            <g:set var="fName" value="${nkey?.trim()?.hashCode()}"/>
                            <g:set var="enKey" value="${nkey?.encodeAsJavaScript()}"/>
                            <g:set var="language" value="${sortCommonNameSources?.get(nkey)?.get(0)?.language}"/>
                            <g:set var="infoSourceURL"
                                   value="${sortCommonNameSources?.get(nkey)?.get(0)?.infoSourceURL}"/>
                            <g:set var="datasetURL" value="${sortCommonNameSources?.get(nkey)?.get(0)?.datasetURL}"/>
                            <tr>
                                <td>
                                    <g:if test="${infoSourceURL && infoSourceURL != datasetURL}"><a
                                            href="${infoSourceURL}" target="_blank" class="external">${nkey}</a></g:if>
                                    <g:else>${nkey}</a></g:else>
                                    <g:if test="${language && !language.startsWith(locale.language)}"><span
                                            class="annotation annotation-language">${language}</span></g:if>
                                </td>
                                <td class="source">
                                    <ul>
                                        <g:each in="${sortCommonNameSources?.get(nkey)}" var="commonName">
                                            <li>
                                                <g:if test="${commonName.datasetURL}"><a href="${commonName.datasetURL}"
                                                                                         onclick="window.open(this.href);
                                                                                         return false;">${commonName.infoSourceName}</a></g:if>
                                                <g:else>${commonName.infoSourceName}</g:else>
                                                <g:if test="${commonName.status && commonName.status != 'common'}"><span
                                                        class="annotation annotation-status">${commonName.status}</span></g:if>
                                            </li>
                                        </g:each>
                                    </ul>
                                </td>
                            </tr>
                        </g:each>
                        </tbody></table>
                    </g:if>
                    <table class="table name-table table-responsive">
                        <thead>
                        <tr>
                            <th>Identifier</th>
                            <th>Source</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>
                                <g:if test="${tc.taxonConcept.infoSourceURL && tc.taxonConcept.infoSourceURL != tc.taxonConcept.datasetURL}"><a
                                        href="${tc.taxonConcept.infoSourceURL}" target="_blank"
                                        class="external">${tc.taxonConcept.guid}</a></g:if>
                                <g:else>${tc.taxonConcept.guid}</g:else>
                            </td>
                            <td class="source">
                                <ul>
                                    <li>
                                        <g:if test="${tc.taxonConcept.datasetURL}"><a
                                                href="${tc.taxonConcept.datasetURL}" onclick="window.open(this.href);
                                                return false;">${tc.taxonConcept.nameAuthority}</a></g:if>
                                        <g:else>${tc.taxonConcept.nameAuthority}</g:else>
                                        <span class="annotation annotation-status">current</span>
                                    </li>
                                </ul>
                            </td>

                        </tr>
                        <g:if test="${tc.identifiers && !tc.identifiers.isEmpty()}">
                            <g:each in="${tc.identifiers}" var="identifier">
                                <tr>
                                    <td>
                                        <g:if test="${identifier.infoSourceURL && identifier.infoSourceURL != identifier.datasetURL}"><a
                                                href="${identifier.infoSourceURL}" target="_blank"
                                                class="external">${identifier.identifier}</a></g:if>
                                        <g:else>${identifier.identifier}</g:else>
                                    </td>
                                    <td class="source">
                                        <ul>
                                            <li>
                                                <g:if test="${identifier.datasetURL}"><a href="${identifier.datasetURL}"
                                                                                         onclick="window.open(this.href);
                                                                                         return false;">${identifier.nameString ?: identifier.infoSourceName}</a></g:if>
                                                <g:else>${identifier.nameString ?: identifier.infoSourceName}</g:else>
                                                <g:if test="${identifier.format}"><span
                                                        class="annotation annotation-format">${identifier.format}</span></g:if>
                                                <g:if test="${identifier.status}"><span
                                                        class="annotation annotation-status">${identifier.status}</span></g:if>
                                            </li>
                                        </ul>
                                    </td>
                                </tr>
                            </g:each>
                        </g:if>
                        </tbody></table>
                </section>

                <section class="tab-pane fade" id="classification">

                    <g:if test="${tc.taxonConcept.rankID < 7000}">
                        <div class="pull-right btn-group btn-group-vertical">
                            <a href="${grailsApplication.config.bie.index.url}/download?q=rkid_${tc.taxonConcept.rankString}:${tc.taxonConcept.guid}&${grailsApplication.config.bieService.queryContext}"
                               class="btn btn-default">
                                <i class="glyphicon glyphicon-arrow-down"></i>
                                Download child taxa of ${tc.taxonConcept.nameString}
                            </a>
                            <a href="${grailsApplication.config.bie.index.url}/download?q=rkid_${tc.taxonConcept.rankString}:${tc.taxonConcept.guid}&fq=rank:species&${grailsApplication.config.bieService.queryContext}"
                               class="btn btn-default">
                                <i class="glyphicon glyphicon-arrow-down"></i>
                                Download species of ${tc.taxonConcept.nameString}
                            </a>
                            <a class="btn btn-default"
                               href="${createLink(controller: 'species', action: 'search')}?q=${'rkid_' + tc.taxonConcept.rankString + ':' + tc.taxonConcept.guid}">
                                Search for child taxa of ${tc.taxonConcept.nameString}
                            </a>
                        </div>
                    </g:if>

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
                            <dl><dt><g:if test="${taxon.rankID ?: 0 != 0}">${taxon.rank}</g:if></dt>
                            <dd><a href="${request?.contextPath}/species/${taxon.guid}#classification"
                                   title="${taxon.rank}">
                                <bie:formatSciName rankId="${taxon.rankID}" nameFormatted="${taxon.nameFormatted}"
                                                   nameComplete="${taxon.nameComplete}" name="${taxon.scientificName}"/>
                                <g:if test="${taxon.commonNameSingle}">: ${taxon.commonNameSingle}</g:if></a>
                            </dd>
                        </g:if>
                        <g:elseif test="${taxon.guid == tc.taxonConcept.guid}">
                            <dl><dt id="currentTaxonConcept">${taxon.rank}</dt>
                            <dd><span><bie:formatSciName rankId="${taxon.rankID}" nameFormatted="${taxon.nameFormatted}"
                                                         nameComplete="${taxon.nameComplete}"
                                                         name="${taxon.scientificName}"/>
                                <g:if test="${taxon.commonNameSingle}">: ${taxon.commonNameSingle}</g:if></span>
                                <g:if test="${taxon.isAustralian || tc.isAustralian}">
                                    &nbsp;<span><img
                                        src="${grailsApplication.config.ala.baseURL}/wp-content/themes/ala2011/images/status_native-sm.png"
                                        alt="Recorded in Australia" title="Recorded in Australia" width="21"
                                        height="21"></span>
                                </g:if>
                            </dd>
                        </g:elseif>
                        <g:else><!-- Taxa ${taxon}) should not be here! --></g:else>
                    </g:each>
                    <dl class="child-taxa">
                        <g:set var="currentRank" value=""/>
                        <g:each in="${childConcepts}" var="child" status="i">
                            <g:set var="currentRank" value="${child.rank}"/>
                            <dt>${child.rank}</dt>
                            <g:set var="taxonLabel"><bie:formatSciName rankId="${child.rankID}"
                                                                       nameFormatted="${child.nameFormatted}"
                                                                       nameComplete="${child.nameComplete}"
                                                                       name="${child.name}"/><g:if
                                    test="${child.commonNameSingle}">: ${child.commonNameSingle}</g:if></g:set>
                            <dd><a href="${request?.contextPath}/species/${child.guid}#classification">${raw(taxonLabel.trim())}</a>&nbsp;
                                <span>
                                    <g:if test="${child.isAustralian}">
                                        <img src="${grailsApplication.config.ala.baseURL}/wp-content/themes/ala2011/images/status_native-sm.png"
                                             alt="Recorded in Australia" title="Recorded in Australia" width="21"
                                             height="21">
                                    </g:if>
                                    <g:else>
                                        <g:if test="${child.guid?.startsWith('urn:lsid:catalogueoflife.org:taxon')}">
                                            <span class="inferredPlacement"
                                                  title="Not recorded in Australia">[inferred placement]</span>
                                        </g:if>
                                        <g:else>
                                            <span class="inferredPlacement" title="Not recorded in Australia"></span>
                                        </g:else>
                                    </g:else>
                                </span>
                            </dd>
                        </g:each>
                    </dl>
                    <g:each in="${taxonHierarchy}" var="taxon">
                        </dl>
                    </g:each>
                </section>

                <section class="tab-pane fade" id="records">

                    <div class="pull-right btn-group btn-group-vertical">
                        <a class="btn btn-default"
                           href="${biocacheUrl}/occurrences/search?q=lsid:${tc?.taxonConcept?.guid ?: ''}">
                            <i class="glyphicon glyphicon-th-list"></i>
                            View list of all
                            occurrence records for this taxon
                        </a>
                        <a class="btn btn-default"
                           href="${biocacheUrl}/occurrences/search?q=lsid:${tc?.taxonConcept?.guid ?: ''}#tab_mapView">
                            <i class="glyphicon glyphicon-map-marker"></i>
                            View map of all
                            occurrence records for this taxon
                        </a>
                    </div>

                    <div id="occurrenceRecords">
                        <div id="recordBreakdowns" style="display: block;">
                            <h2>Charts showing breakdown of occurrence records</h2>
                            %{--<div id="chartsHint">Hint: click on chart elements to view that subset of records</div>--}%
                            <div id="charts"></div>
                        </div>
                    </div>
                </section>

                <section class="tab-pane fade" id="literature">
                    <div id="bhl-integration">
                        <h2>Name references found in the <a href="http://biodiversityheritagelibrary.com">Biodiversity Heritage Library</a></h2>

                        <div id="bhl-results-list" class="results-list">
                        </div>
                    </div>

                    <div id="trove-integration">
                        <h2>Name references found in the <a href="http://trove.nla.gov.au">Trove - NLA</a></h2>

                        <div id="trove-result-list" class="results-list">
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
                    <table id="data-providers-list" class="table name-table  table-responsive">
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

<!-- description template -->
<div id="descriptionTemplate" class="panel panel-default panel-description" style="display:none;">
    <div class="panel-heading">
        <h3 class="panel-title title"></h3>
    </div>

    <div class="panel-body">
        <p class="content"></p>
    </div>

    <div class="panel-footer">
        <p class="source">Source: <span class="sourceText"></span></p>

        <p class="rights">Rights holder: <span class="rightsText"></span></p>

        <p class="provider">Provided by: <a href="#" class="providedBy"></a></p>
    </div>
</div>

<!-- genbank -->
<div id="genbankTemplate" class="result hide">
    <h3><a href="" class="externalLink"></a></h3>

    <p class="description"></p>

    <p class="furtherDescription"></p>
</div>

<r:script>
    // global var to pass GSP vars into JS file @TODO replace bhl and trove with literatureSource list
    var SHOW_CONF = {
        biocacheUrl:        "${grailsApplication.config.biocache.baseURL}",
        biocacheServiceUrl: "${grailsApplication.config.biocacheService.baseURL}",
        collectoryUrl:      "${grailsApplication.config.collectory.baseURL}",
        guid:               "${guid}",
        scientificName:     "${tc?.taxonConcept?.nameString ?: ''}",
        rankString:         "${tc?.taxonConcept?.rankString ?: ''}",
        taxonRankID:        "${tc?.taxonConcept?.rankID ?: ''}",
        synonymsQuery:      "${synonymsQuery.replaceAll('""','"').encodeAsJavaScript()}",
        citizenSciUrl:      "${citizenSciUrl}",
        serverName:         "${grailsApplication.config.grails.serverURL}",
        speciesListUrl:     "${grailsApplication.config.speciesList.baseURL}",
        bieUrl:             "${grailsApplication.config.bie.baseURL}",
        alertsUrl:          "${grailsApplication.config.alerts.baseUrl}",
        remoteUser:         "${request.remoteUser ?: ''}",
        eolUrl:             "${createLink(controller: 'externalSite', action: 'eol', params: [s: tc?.taxonConcept?.nameString ?: ''])}",
        genbankUrl:         "${createLink(controller: 'externalSite', action: 'genbank', params: [s: tc?.taxonConcept?.nameString ?: ''])}",
        scholarUrl:         "${createLink(controller: 'externalSite', action: 'scholar', params: [s: tc?.taxonConcept?.nameString ?: ''])}",
        soundUrl:           "${createLink(controller: 'species', action: 'soundSearch', params: [s: tc?.taxonConcept?.nameString ?: ''])}",
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

    $(function(){ showSpeciesPage(); })
</r:script>

<r:script type="text/javascript">
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var target = $(e.target).attr("href");
        if(target == "#records"){
            <charts:biocache
        biocacheServiceUrl="${grailsApplication.config.biocacheService.baseURL}"
        biocacheWebappUrl="${grailsApplication.config.biocache.baseURL}"
        q="lsid:${guid}"
        qc="${grailsApplication.config.biocacheService.queryContext ?: ''}"
        fq=""/>
    }
    if(target == '#overview'){
        loadMap();
    }
});
</r:script>

</body>
</html>