<section class="tab-pane fade in active" id="overview">
    <div class="row taxon-row">
        <div class="col-md-6">

            <div class="taxon-summary-gallery">
                <div class="main-img hide">
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
                        <h3 class="panel-title"><g:message code="overview.status.conservation"/></h3>
                    </div>

                    <div class="panel-body">
                        <ul class="conservationList">
                            <g:each in="${tc.conservationStatuses.entrySet().sort { it.key }}" var="cs">
                                <li>
                                    <g:if test="${cs.value.dr}">
                                        <a href="${collectoryUrl}/public/show/${cs.value.dr}"><span
                                                class="iucn <bie:colourForStatus
                                                        status="${cs.value.status}"/>">${cs.key}</span>${cs.value.status}
                                        <!-- cs = ${cs} -->
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

            <div id="descriptiveContent"></div>

            <div id="sounds" style="padding-bottom:20px;"></div>

            <div class="panel panel-default panel-resources">
                <div class="panel-heading">
                    <h3 class="panel-title"><g:message code="overview.online.resources"/></h3>
                </div>

                <div class="panel-body">
                    <g:render template="onlineResources"/>
                </div>
            </div>

        </div><!-- end col 1 -->

        <div class="col-md-6">
            <div id="expertDistroDiv" style="display:none;margin-bottom: 20px;">
                <h3><g:message code="overview.map.occurrence.compile.mapa.attribution"/></h3>
                <img id="distroMapImage" src="${resource(dir: 'images', file: 'noImage.jpg')}" class="distroImg"
                     style="width:316px;" alt="occurrence map" onerror="this.style.display = 'none'"/>

                <p class="mapAttribution"><g:message code="overview.map.occurrence.mapa.attribution.01"/>
                    <span id="dataResource">[<g:message code="overview.map.occurrence.mapa.attribution.02"/>]</span></p>
            </div>

            <div class="taxon-map">
                <h3>
                    <g:message code="overview.map.occurrence.records.01"/>
                    (<span class="occurrenceRecordCount">0</span>
                    <g:message code="overview.map.occurrence.records.02"/>)
                </h3>

                <div id="leafletMap"></div>

                <g:if test="${grailsApplication.config.spatial.baseURL}">
                    <g:set var="mapUrl">${grailsApplication.config.spatial.baseURL}?q=lsid:${tc?.taxonConcept?.guid}${grailsApplication.config.qualityProfile ? '&qualityProfile=' + grailsApplication.config.qualityProfile : ''}</g:set>
                </g:if>
                <g:else>
                    <g:set var="mapUrl">${biocacheUrl}/occurrences/search?q=lsid:${tc?.taxonConcept?.guid}#tab_mapView</g:set>
                </g:else>

                <div class="map-buttons">
                    <a class="btn btn-primary btn-lg"
                       href="${mapUrl}"
                       title="${g.message(code: 'overview.map.button.records.map.title', default: 'View interactive map')}"
                       role="button">
                        <g:message code="overview.map.button.records.map" default="View Interactive Map"/>
                    </a>
                    <g:if test="${grailsApplication.config.map.simpleMapButton.toBoolean()}">
                        <a class="btn btn-primary btn-lg"
                           href="${biocacheUrl}/occurrences/search?q=lsid:${tc?.taxonConcept?.guid}#tab_mapView"
                           title="${g.message(code: 'overview.map.button.records.simplemap.title', default: 'View map')}"
                           role="button"><g:message code="overview.map.button.records.simplemap"
                                                    default="View map"/></a>
                    </g:if>
                    <a class="btn btn-primary btn-lg"
                       href="${biocacheUrl}/occurrences/search?q=lsid:${tc?.taxonConcept?.guid}#tab_recordsView"
                       title="${g.message(code: 'overview.map.button.records.list.title', default: 'View records')}"
                       role="button"><g:message code="overview.map.button.records.list" default="View records"/></a>
                </div>
            </div>

            <div class="panel panel-default panel-actions">
                <div class="panel-body">
                    <ul class="list-unstyled">
                        <g:if test="${citizenSciUrl && guid && scientificName}">
                            <li>
                                <a href="${java.text.MessageFormat.format(citizenSciUrl, URLEncoder.encode(guid, "UTF-8"), URLEncoder.encode(scientificName, "UTF-8"))}"><span class="glyphicon glyphicon-map-marker"></span> <g:message code="label.recordSighting" default="Record a sighting"/></a>
                            </li>
                        </g:if>
                        <li>
                            <a id="alertsButton" href="#">
                                <span class="glyphicon glyphicon-bell"></span>
                                <g:message code="overview.map.receive.alerts"/>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="panel panel-default panel-data-providers">
                <div class="panel-heading">
                    <h3 class="panel-title"><g:message code="overview.datasets"/></h3>
                </div>

                <div class="panel-body">
                    <p><strong><span class="datasetCount"></span>
                    </strong>
                    </strong> <g:message code="overview.datasets.have.provided.data" args="[grailsApplication.config.skin.orgNameShort, tc.taxonConcept.rankString]" />
                    </p>

                    <p>
                        <a class="tab-link" href="#data-partners">
                            <g:message code="overview.datasets.lists.01"/>
                        </a>
                        <g:message code="overview.datasets.lists.02"/>
                        <g:if test="${tc.taxonConcept?.rankID > 6000}">
                            <g:message code="overview.datasets.species.like"/> ${raw(sciNameFormatted)}
                        </g:if>
                        <g:else>
                            <g:message code="overview.datasets.species.of"/> ${raw(sciNameFormatted)}.
                        </g:else>
                    </p>
                </div>
            </div>

            <div id="listContent">
            </div>
        </div><!-- end col 2 -->
    </div>
</section>
