<section class="tab-pane fade" id="classification">

    <g:if test="${tc.taxonConcept.rankID < 7000}">
        <div class="pull-right btn-group btn-group-vertical">
            <a href="${grailsApplication.config.bie.index.url}/download?q=rkid_${tc.taxonConcept.rankString}:${tc.taxonConcept.guid}&${grailsApplication.config.bieService.queryContext}"
               class="btn btn-default" style="text-align:left;">
                <i class="glyphicon glyphicon-arrow-down"></i>
                <g:message code="classification.download.child"/> ${tc.taxonConcept.nameString}
            </a>
            <a href="${grailsApplication.config.bie.index.url}/download?q=rkid_${tc.taxonConcept.rankString}:${tc.taxonConcept.guid}&fq=rank:species&${grailsApplication.config.bieService.queryContext}"
               class="btn btn-default" style="text-align:left;">
                <i class="glyphicon glyphicon-arrow-down"></i>
                <g:message code="classification.download.species"/> ${tc.taxonConcept.nameString}
            </a>
            <a class="btn btn-default" style="text-align:left;"
               href="${createLink(controller: 'species', action: 'search')}?q=${'rkid_' + tc.taxonConcept.rankString + ':' + tc.taxonConcept.guid}">
                <g:message code="classification.search.child"/> ${tc.taxonConcept.nameString}
            </a>
        </div>
    </g:if>

    <h2>
        <g:if test="${grailsApplication.config.classificationSupplier}">
            ${grailsApplication.config.classificationSupplier} classification
        </g:if>
        <g:else>
            <g:message code="classification.title"/>
        </g:else>
    </h2>
    <g:each in="${taxonHierarchy}" var="taxon">
        <!-- taxon = ${taxon} -->
        <g:if test="${taxon.guid != tc.taxonConcept.guid}">
            <dl><dt>${taxon.rank}</dt>
            <dd><a href="${request?.contextPath}/species/${taxon.guid}#classification"
                   title="${taxon.rank}">
                <bie:formatSciName rankId="${taxon.rankID}" nameFormatted="${taxon.nameFormatted}"
                                   nameComplete="${taxon.nameComplete}" taxonomicStatus="name"
                                   name="${taxon.scientificName}"/>
                <g:if test="${taxon.commonNameSingle}">: ${taxon.commonNameSingle}</g:if></a>
            </dd>
        </g:if>
        <g:elseif test="${taxon.guid == tc.taxonConcept.guid}">
            <dl><dt id="currentTaxonConcept">${taxon.rank}</dt>
            <dd><span>
                <bie:formatSciName rankId="${taxon.rankID}" nameFormatted="${taxon.nameFormatted}"
                                   nameComplete="${taxon.nameComplete}"
                                   taxonomicStatus="name"
                                   name="${taxon.scientificName}"/>
                <g:if test="${taxon.commonNameSingle}">: ${taxon.commonNameSingle}</g:if></span>
                <g:if test="${taxon.isAustralian || tc.isAustralian}">
                    &nbsp;<span><img
                        src="${grailsApplication.config.ala.baseURL}/wp-content/themes/ala2011/images/status_native-sm.png"
                        alt="${message(code:"facet.locatedInHubCountry")}" title="${message(code:"facet.locatedInHubCountry")}" width="21"
                        height="21"></span>
                </g:if>
            </dd>
        </g:elseif>
        <g:else><!-- Taxa ${taxon}) should not be here! --></g:else>
    </g:each>
    <dl class="child-taxa">
        <g:set var="currentRank" value=""/>
        <g:each in="${childConcepts}" var="child" status="i"><!-- Rely on web service for correct order -->
            <g:set var="currentRank" value="${child.rank}"/>
            <dt>${child.rank}</dt>
            <g:set var="taxonLabel">
                <bie:formatSciName rankId="${child.rankID}"
                                   nameFormatted="${child.nameFormatted}"
                                   nameComplete="${child.nameComplete}"
                                   taxonomicStatus="name"
                                   name="${child.name}"/><g:if
                    test="${child.commonNameSingle}">: ${child.commonNameSingle}</g:if></g:set>
            <dd><a href="${request?.contextPath}/species/${child.guid}#classification">${raw(taxonLabel.trim())}</a>&nbsp;
                <span>
                    <g:if test="${child.isAustralian}">
                        <img src="${grailsApplication.config.ala.baseURL}/wp-content/themes/ala2011/images/status_native-sm.png"
                             alt="${message(code:"facet.locatedInHubCountry")}" title="${message(code:"facet.locatedInHubCountry")}" width="21"
                             height="21">
                    </g:if>
                    <g:else>
                        <g:if test="${child.guid?.startsWith('urn:lsid:catalogueoflife.org:taxon')}">
                            <span class="inferredPlacement"
                                  title="${message(code:"facet.notLocatedInHubCountry")}">[inferred placement]</span>
                        </g:if>
                        <g:else>
                            <span class="inferredPlacement" title="${message(code:"facet.notLocatedInHubCountry")}"></span>
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