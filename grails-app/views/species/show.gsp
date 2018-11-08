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
<g:set var="tabs" value="${grailsApplication.config.show.tabs.split(',')}"/>
<g:set var="jsonLink" value="${grailsApplication.config.bie.index.url}/species/${tc?.taxonConcept?.guid}.json"/>
<g:set var="sciNameFormatted"><bie:formatSciName rankId="${tc?.taxonConcept?.rankID}"
                                                 nameFormatted="${tc?.taxonConcept?.nameFormatted}"
                                                 nameComplete="${tc?.taxonConcept?.nameComplete}"
                                                 name="${tc?.taxonConcept?.name}"
                                                 taxonomicStatus="${tc?.taxonConcept?.taxonomicStatus}"
                                                 acceptedName="${tc?.taxonConcept?.acceptedConceptName}"/></g:set>
<g:set var="synonymsQuery"><g:each in="${tc?.synonyms}" var="synonym" status="i">\"${synonym.nameString}\"<g:if
        test="${i < tc.synonyms.size() - 1}"> OR </g:if></g:each></g:set>
<g:set var="locale" value="${org.springframework.web.servlet.support.RequestContextUtils.getLocale(request)}"/>
<g:set bean="authService" var="authService"></g:set>
<g:set var="imageViewerType" value="${grailsApplication.config.imageViewerType?:'LEAFLET'}"></g:set>
<g:set var="fluidLayout" value="${grailsApplication.config.skin?.fluidLayout?:"false".toBoolean()}"/>
<g:set var="logoFile" value="${grailsApplication.config.skin.logoFile}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${tc?.taxonConcept?.nameString} ${(tc?.commonNames) ? ' : ' + tc?.commonNames?.get(0)?.nameString : ''} | ${raw(grailsApplication.config.skin.orgNameLong)}</title>
    <meta name="layout" content="${grailsApplication.config.skin.layout}"/>

    <!-- facebook tags -->
    <g:render template="facebookTags"/>

    <asset:javascript src="show"/>
    <asset:stylesheet src="show"/>
    <asset:javascript src="charts"/>
    <asset:stylesheet src="charts"/>
    <asset:javascript src="ala/images-client.js"/>
    <asset:stylesheet src="ala/images-client.css"/>
    <asset:javascript src="ala/images-client-gallery.js"/>
    <asset:stylesheet src="ala/images-client-gallery.css"/>
    <script type="text/javascript">
        jQuery.i18n.properties({
            name: 'Messages',
            path: '${request.contextPath}/i18n/',
            mode: 'map'
        });
    </script>
</head>

<body class="page-taxon">
<section class="${fluidLayout ? 'container-fluid' : 'container'}">
    <header class="pg-header">
        <g:if test="${taxonHierarchy && taxonHierarchy.size() > 1}">
            <div class="taxonomy-bcrumb">
                <ol class="list-inline breadcrumb">
                    <g:each in="${taxonHierarchy}" var="taxon">
                        <g:if test="${taxon.guid != tc.taxonConcept.guid}">
                            <li><g:link controller="species" action="show" title="${taxon.rank}" data-toggle="tooltip" data-placement="bottom"
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
            <h5 class="pull-right json">
                <a href="${jsonLink}" target="data"
                   title="${message(code:"show.view.json.title")}" class="btn btn-sm btn-default active"
                   data-toggle="tooltip" data-placement="bottom"><g:message code="show.json" /></a>
            </h5>
            <h1>${raw(sciNameFormatted)}</h1>
            <g:set var="commonNameDisplay" value="${(tc?.commonNames) ? tc?.commonNames?.opt(0)?.nameString : ''}"/>
            <g:if test="${commonNameDisplay}">
                <h2>${raw(commonNameDisplay)}</h2>
            </g:if>
            <g:if test="${tc?.taxonConcept?.acceptedConceptName}">
                <h2><g:link uri="/species/${tc.taxonConcept.acceptedConceptID}">${tc.taxonConcept.acceptedConceptName}</g:link></h2>
            </g:if>
            <h5 class="inline-head taxon-rank">${tc.taxonConcept.rankString}</h5>
            <g:if test="${tc.taxonConcept.taxonomicStatus}"><h5 class="inline-head taxonomic-status" title="${message(code: 'taxonomicStatus.' + tc.taxonConcept.taxonomicStatus + '.detail', default: '')}"><g:message code="taxonomicStatus.${tc.taxonConcept.taxonomicStatus}" default="${tc.taxonConcept.taxonomicStatus}"/></h5></g:if>
            <h5 class="inline-head name-authority">
                <strong>Name authority:</strong>
                <span class="name-authority">${tc?.taxonConcept.nameAuthority ?: grailsApplication.config.defaultNameAuthority}</span>
            </h5>
        </div>
    </header>

    <div id="main-content" class="main-content panel panel-body">
        <div class="taxon-tabs">
            <ul class="nav nav-tabs">
                <g:each in="${tabs}" status="ts" var="tab">
                    <li class="${ts == 0 ? 'active' : ''}"><a href="#${tab}" data-toggle="tab"><g:message
                            code="label.${tab}" default="${tab}"/></a></li>
                </g:each>
            </ul>
            <div class="tab-content">
                <g:each in="${tabs}" status="ts" var="tab">
                    <g:render template="${tab}"/>
                </g:each>
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


<!-- indigenous-profile-summary template -->
<div id="indigenous-profile-summary-template" class="hide padding-bottom-2">

    <div class="indigenous-profile-summary row">
        <div class="col-md-2">
            <div class="collection-logo embed-responsive embed-responsive-16by9 col-xs-11">
            </div>

            <div class="collection-logo-caption small">
            </div>
        </div>

        <div class="col-md-10 profile-summary">
            <h3 class="profile-name"></h3>
            <span class="collection-name"></span>

            <div class="profile-link pull-right"></div>

            <h3 class="other-names"></h3>

            <div class="summary-text"></div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-2 ">
        </div>

        <div class="col-md-5 hide main-image padding-bottom-2">
            <div class="row">

                <div class="col-md-8 panel-heading">
                    <h3 class="panel-title">Main Image</h3>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8 ">
                    <div class="image-embedded">
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-1">
        </div>
        <div class="col-md-3 hide main-audio padding-bottom-2">
            <div class="row">
                <div class="col-md-8 panel-heading">
                    <h3 class="panel-title">Main Audio</h3>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12 ">
                    <div class="audio-embedded embed-responsive embed-responsive-16by9 col-xs-12 text-center">
                    </div>
                </div>
            </div>

            <div class="row">

                <div class="col-md-12 small">
                    <div class="row">
                        <div class="col-md-5 ">
                            <strong>Name</strong>
                        </div>

                        <div class="col-md-7 audio-name"></div>
                    </div>

                    <div class="row">
                        <div class="col-md-5 ">
                            <strong>Attribution</strong>
                        </div>

                        <div class="col-md-7 audio-attribution"></div>
                    </div>

                    <div class="row">
                        <div class="col-md-5 ">
                            <strong>Licence</strong>
                        </div>

                        <div class="col-md-7 audio-license"></div>
                    </div>

                </div>

                <div class="col-md-2 "></div>
            </div>
        </div>
        <div class="col-md-1">
        </div>
    </div>

    <div class="hide main-video padding-bottom-2">
        <div class="row">
            <div class="col-md-2 ">
            </div>
            <div class="col-md-8 panel-heading">
                <h3 class="panel-title">Main Video</h3>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2 ">
            </div>
            <div class="col-md-7 ">
                <div class="video-embedded embed-responsive embed-responsive-16by9 col-xs-12 text-center">
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-2 "></div>

            <div class="col-md-7 small">
                <div class="row">
                    <div class="col-md-2 ">
                        <strong>Name</strong>
                    </div>

                    <div class="col-md-10 video-name"></div>
                </div>

                <div class="row">
                    <div class="col-md-2 ">
                        <strong>Attribution</strong>
                    </div>

                    <div class="col-md-10 video-attribution"></div>
                </div>

                <div class="row">
                    <div class="col-md-2 ">
                        <strong>Licence</strong>
                    </div>

                    <div class="col-md-10 video-license"></div>
                </div>

            </div>
            <div class="col-md-2 "></div>
        </div>
    </div>

    <hr/>
</div>

<div id="imageDialog" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <div id="viewerContainerId">

                </div>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div>

<div id="alertModal" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <div id="alertContent">

                </div>
                <!-- dialog buttons -->
                <div class="modal-footer"><button type="button" class="btn btn-primary" data-dismiss="modal">OK</button></div>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div>

<asset:script type="text/javascript">
    // Global var to pass GSP vars into JS file @TODO replace bhl and trove with literatureSource list
    var SHOW_CONF = {
        biocacheUrl:        "${grailsApplication.config.biocache.baseURL}",
        biocacheServiceUrl: "${grailsApplication.config.biocacheService.baseURL}",
        layersServiceUrl:   "${grailsApplication.config.layersService.baseURL}",
        collectoryUrl:      "${grailsApplication.config.collectory.baseURL}",
        profileServiceUrl:  "${grailsApplication.config.profileService.baseURL}",
        imageServiceBaseUrl:"${grailsApplication.config.image.baseURL}",
        guid:               "${guid}",
        scientificName:     "${tc?.taxonConcept?.nameString ?: ''}",
        rankString:         "${tc?.taxonConcept?.rankString ?: ''}",
        taxonRankID:        "${tc?.taxonConcept?.rankID ?: ''}",
        synonymsQuery:      "${synonymsQuery.replaceAll('""','"').encodeAsJavaScript()}",
        preferredImageId:   "${tc?.imageIdentifier?: ''}",
        citizenSciUrl:      "${citizenSciUrl}",
        serverName:         "${grailsApplication.config.grails.serverURL}",
        speciesListUrl:     "${grailsApplication.config.speciesList.baseURL}",
        bieUrl:             "${grailsApplication.config.bie.baseURL}",
        alertsUrl:          "${grailsApplication.config.alerts.baseUrl}",
        remoteUser:         "${request.remoteUser ?: ''}",
        eolUrl:             "${raw(createLink(controller: 'externalSite', action: 'eol', params: [s: tc?.taxonConcept?.nameString ?: '', f:tc?.classification?.class?:tc?.classification?.phylum?:'']))}",
        genbankUrl:         "${raw(createLink(controller: 'externalSite', action: 'genbank', params: [s: tc?.taxonConcept?.nameString ?: '']))}",
        scholarUrl:         "${raw(createLink(controller: 'externalSite', action: 'scholar', params: [s: tc?.taxonConcept?.nameString ?: '']))}",
        soundUrl:           "${raw(createLink(controller: 'species', action: 'soundSearch', params: [s: tc?.taxonConcept?.nameString ?: '']))}",
        eolLanguage:        "${grailsApplication.config.eol.lang}",
        defaultDecimalLatitude: ${grailsApplication.config.defaultDecimalLatitude},
        defaultDecimalLongitude: ${grailsApplication.config.defaultDecimalLongitude},
        defaultZoomLevel: ${grailsApplication.config.defaultZoomLevel},
        mapAttribution: "${raw(grailsApplication.config.skin.orgNameLong)}",
        defaultMapUrl: "${grailsApplication.config.map.default.url}",
        defaultMapAttr: "${raw(grailsApplication.config.map.default.attr)}",
        defaultMapDomain: "${grailsApplication.config.map.default.domain}",
        defaultMapId: "${grailsApplication.config.map.default.id}",
        defaultMapToken: "${grailsApplication.config.map.default.token}",
        recordsMapColour: "${grailsApplication.config.map.records.colour}",
        mapQueryContext: '${raw(grailsApplication.config.biocacheService.queryContext)}',
        additionalMapFilter: "${raw(grailsApplication.config.additionalMapFilter)}",
        noImage100Url: "${resource(dir: 'images', file: 'noImage100.jpg')}",
        map: null,
        imageDialog: '${imageViewerType}',
        likeUrl: "${createLink(controller: 'imageClient', action: 'likeImage')}",
        dislikeUrl: "${createLink(controller: 'imageClient', action: 'dislikeImage')}",
        userRatingUrl: "${createLink(controller: 'imageClient', action: 'userRating')}",
        disableLikeDislikeButton: ${authService.getUserId() ? false : true},
        userRatingHelpText: '<div><b>Up vote (<i class="fa fa-thumbs-o-up" aria-hidden="true"></i>) an image:</b>'+
        ' Image supports the identification of the species or is representative of the species.  Subject is clearly visible including identifying features.<br/><br/>'+
        '<b>Down vote (<i class="fa fa-thumbs-o-down" aria-hidden="true"></i>) an image:</b>'+
        ' Image does not support the identification of the species, subject is unclear and identifying features are difficult to see or not visible.<br/><br/></div>',
        savePreferredSpeciesListUrl: "${createLink(controller: 'imageClient', action: 'saveImageToSpeciesList')}",
        getPreferredSpeciesListUrl: "${grailsApplication.config.speciesList.baseURL}",
        druid: "${grailsApplication.config.speciesList.preferredSpeciesListDruid}",
        addPreferenceButton: ${imageClient.checkAllowableEditRole()},
        mapOutline: ${grailsApplication.config.map.outline ?: 'false'},
        mapEnvOptions: "${grailsApplication.config.map.env?.options?:'color:' + grailsApplication.config.map.records.colour+ ';name:circle;size:4;opacity:0.8'}",
        troveUrl: "${raw(grailsApplication.config.literature?.trove?.url ?: 'http://api.trove.nla.gov.au/result?key=fvt2q0qinduian5d&zone=book&encoding=json')}",
        bhlUrl: "${raw(grailsApplication.config.literature?.bhl?.url ?: 'http://bhlidx.ala.org.au/select')}"
    };

    $(function(){
        showSpeciesPage();
    });

    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var target = $(e.target).attr("href");
        if(target == "#records"){
            $('#charts').html(''); //prevent multiple loads
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
</asset:script>
</body>
</html>
