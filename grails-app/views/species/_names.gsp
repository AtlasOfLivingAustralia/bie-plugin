<section class="tab-pane fade" id="names">
    <g:set var="acceptedName" value="${tc.taxonConcept.taxonomicStatus == 'accepted'}"/>
    <h2>Names and sources</h2>
    <table class="table name-table  table-responsive">
        <thead>
        <tr>
            <th><g:if test="${acceptedName}">Accepted name</g:if><g:else>Name</g:else></th>
            <th>Source</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>
                <g:set var="baseNameFormatted"><bie:formatSciName rankId="${tc?.taxonConcept?.rankID}"
                                                                  nameFormatted="${tc?.taxonConcept?.nameFormatted}"
                                                                  nameComplete="${tc?.taxonConcept?.nameComplete}"
                                                                  name="${tc?.taxonConcept?.name}"
                                                                  taxonomicStatus="name"
                                                                  acceptedName="${tc?.taxonConcept?.acceptedConceptName}"/></g:set>
                <g:if test="${tc.taxonConcept.infoSourceURL && tc.taxonConcept.infoSourceURL != tc.taxonConcept.datasetURL}"><a
                        href="${tc.taxonConcept.infoSourceURL}" target="_blank"
                        class="external">${raw(baseNameFormatted)}</a></g:if>
                <g:else>${raw(baseNameFormatted)}</g:else>
            </td>
            <td class="source">
                <ul><li>
                    <g:if test="${tc.taxonConcept.datasetURL}"><a href="${tc.taxonConcept.datasetURL}"
                                                                  target="_blank"
                                                                  class="external">${tc.taxonConcept.nameAuthority ?: tc.taxonConcept.infoSourceName}</a></g:if>
                    <g:else>${tc.taxonConcept.nameAuthority ?: tc.taxonConcept.infoSourceName}</g:else>
                    <g:if test="${!acceptedName}"><span class="annotation annotation-taxonomic-status" title="${message(code: 'taxonomicStatus.' + tc.taxonConcept.taxonomicStatus + '.detail', default: '')}"><g:message code="taxonomicStatus.${tc.taxonConcept.taxonomicStatus}.annotation" default="${tc.taxonConcept.taxonomicStatus}"/></span></g:if>
                    <g:if test="${tc.taxonConcept.nomenclaturalStatus && tc.taxonConcept.nomenclaturalStatus != tc.taxonConcept.taxonomicStatus}"><span class="annotation annotation-nomenclatural-status">${tc.taxonConcept.nomenclaturalStatus}</span></g:if>
                </li></ul>
            </td>
        </tr>
        <g:if test="${(tc.taxonName && tc.taxonName.nameAccordingTo) || tc.taxonConcept.nameAccordingTo}">
            <tr class="cite">
                <td colspan="2">
                    <cite>Name according to: <span
                            class="publishedIn">${tc.taxonName?.nameAccordingTo ?: tc.taxonConcept.nameAccordingTo}</span>
                    </cite>
                </td>
            </tr>
        </g:if>
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
                        <g:set var="synonymNameFormatted"><bie:formatSciName rankId="${tc?.taxonConcept?.rankID}"
                                                                             nameFormatted="${synonym.nameFormatted}"
                                                                             nameComplete="${synonym.nameComplete}"
                                                                             taxonomicStatus="name"
                                                                             name="${synonym.nameString}"/></g:set>
                        <g:if test="${synonym.infoSourceURL && synonym.infoSourceURL != synonym.datasetURL}"><a
                                href="${synonym.infoSourceURL}" target="_blank"
                                class="external">${raw(synonymNameFormatted)}</a></g:if>
                        <g:else>${raw(synonymNameFormatted)}</g:else>
                    </td>
                    <td class="source">
                        <ul><li>
                            <g:if test="${synonym.datasetURL}"><a href="${synonym.datasetURL}"
                                                                  target="_blank"
                                                                  class="external">${synonym.nameAuthority ?: synonym.infoSourceName}</a></g:if>
                            <g:else>${synonym.nameAuthority ?: synonym.infoSourceName}</g:else>
                            <span class="annotation annotation-taxonomic-status" title="${message(code: 'taxonomicStatus.' + synonym.taxonomicStatus + '.detail', default: '')}"><g:message code="taxonomicStatus.${synonym.taxonomicStatus}.annotation" default="${synonym.taxonomicStatus}"/></span>
                            <g:if test="${synonym.nomenclaturalStatus && synonym.nomenclaturalStatus != synonym.taxonomicStatus}"><span class="annotation annotation-nomenclatural-status">${synonym.nomenclaturalStatus}</span></g:if>
                        </li></ul>
                    </td>
                </tr>
                <g:if test="${synonym.namePublishedIn && synonym.namePublishedIn != tc?.taxonConcept?.namePublishedIn}">
                    <tr class="cite">
                        <td colspan="2">
                            <cite>Published in: <span
                                    class="publishedIn">${synonym.namePublishedIn}</span>
                            </cite>
                        </td>
                    </tr>
                </g:if>
                <g:if test="${synonym.referencedIn }">
                    <tr class="cite">
                        <td colspan="2">
                            <cite>Referenced in: <span
                                    class="publishedIn">${synonym.referencedIn}</span>
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
            <tbody>
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
                                href="${infoSourceURL}" target="_blank" class="external"><bie:markLanguage text="${nkey}" lang="${language}"/></a></g:if>
                        <g:else><bie:markLanguage text="${nkey}" lang="${language}"/></g:else>
                    </td>
                    <td class="source">
                        <ul>
                            <g:each in="${sortCommonNameSources?.get(nkey)}" var="commonName">
                                <li>
                                    <g:if test="${commonName.datasetURL}"><a href="${commonName.datasetURL}"
                                                                             onclick="window.open(this.href);
                                                                             return false;">${commonName.infoSourceName}</a></g:if>
                                    <g:else>${commonName.infoSourceName}</g:else>
                                    <g:if test="${commonName.status && commonName.status != 'common'}"><span title="${message(code: 'identifierStatus.' + commonName.status + '.detail', default: '')}"
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
                        <span class="annotation annotation-type" title="${message(code: 'identifierType.taxon.detail', default: '')}"><g:message code="identifierType.taxon"/></span>
                        <span class="annotation annotation-status" title="${message(code: 'identifierStatus.current.detail', default: '')}"><g:message code="identifierStatus.current"/></span>
                    </li>
                </ul>
            </td>
        </tr>
        <g:if test="${tc.taxonConcept.taxonConceptID && tc.taxonConcept.taxonConceptID != tc.taxonConcept.guid}">
            <tr>
                <td>
                    <g:if test="${tc.taxonConcept.taxonConceptSourceURL && tc.taxonConcept.taxonConceptSourceURL != tc.taxonConcept.datasetURL}"><a
                            href="${tc.taxonConcept.taxonConceptSourceURL}" target="_blank"
                            class="external">${tc.taxonConcept.taxonConceptID}</a></g:if>
                    <g:else>${tc.taxonConcept.taxonConceptID}</g:else>
                </td>
                <td class="source">
                    <ul>
                        <li>
                            <g:if test="${tc.taxonConcept.datasetURL}"><a
                                    href="${tc.taxonConcept.datasetURL}" onclick="window.open(this.href);
                                return false;">${tc.taxonConcept.nameAuthority}</a></g:if>
                            <g:else>${tc.taxonConcept.nameAuthority}</g:else>
                            <span class="annotation annotation-type" title="${message(code: 'identifierType.taxonConcept.detail', default: '')}"><g:message code="identifierType.taxonConcept"/></span>
                            <span class="annotation annotation-status" title="${message(code: 'identifierStatus.current.detail', default: '')}"><g:message code="identifierStatus.current"/></span>
                        </li>
                    </ul>
                </td>
            </tr>
        </g:if>
        <g:if test="${tc.taxonConcept.scientificNameID && tc.taxonConcept.scientificNameID != tc.taxonConcept.guid && tc.taxonConcept.scientificNameID != tc.taxonConcept.taxonConceptID}">
            <tr>
                <td>
                    <g:if test="${tc.taxonConcept.scientificNameSourceURL && tc.taxonConcept.scientificNameSourceURL != tc.taxonConcept.datasetURL}"><a
                            href="${tc.taxonConcept.scientificNameSourceURL}" target="_blank"
                            class="external">${tc.taxonConcept.scientificNameID}</a></g:if>
                    <g:else>${tc.taxonConcept.scientificNameID}</g:else>
                </td>
                <td class="source">
                    <ul>
                        <li>
                            <g:if test="${tc.taxonConcept.datasetURL}"><a
                                    href="${tc.taxonConcept.datasetURL}" onclick="window.open(this.href);
                                return false;">${tc.taxonConcept.nameAuthority}</a></g:if>
                            <g:else>${tc.taxonConcept.nameAuthority}</g:else>
                            <span class="annotation annotation-type" title="${message(code: 'identifierType.name.detail', default: '')}"><g:message code="identifierType.name"/></span>
                            <span class="annotation annotation-status" title="${message(code: 'identifierStatus.current.detail', default: '')}"><g:message code="identifierStatus.current"/></span>
                        </li>
                    </ul>
                </td>
            </tr>
        </g:if>
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
                                <g:if test="${identifier.format}"><span title="${message(code: 'identifierFormat.' + identifier.format + '.detail', default: '')}"
                                                                        class="annotation annotation-format"><g:message code="identifierFormat.${identifier.format}" default="${identifier.format}"/></span></g:if>
                                <g:if test="${identifier.status}"><span title="${message(code: 'identifierStatus.' + identifier.status + '.detail', default: '')}"
                                                                        class="annotation annotation-status"><g:message code="identifierFormat.${identifier.status}" default="${identifier.status}"/></span></g:if>
                            </li>
                        </ul>
                    </td>
                </tr>
            </g:each>
        </g:if>
        </tbody></table>
</section>
