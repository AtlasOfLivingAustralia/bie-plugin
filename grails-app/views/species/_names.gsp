<section class="tab-pane fade" id="names">
    <g:set var="acceptedName" value="${tc.taxonConcept.taxonomicStatus == 'accepted' || tc.taxonConcept.taxonomicStatus == 'inferredAccepted'}"/>
    <h2><g:message code="names.title"/></h2>
    <table class="table name-table  table-responsive">
        <thead>
        <tr>
            <th title="<g:message code="label.acceptedName.detail"/>"><g:if test="${acceptedName}"><g:message code="label.acceptedName"/></g:if><g:else><g:message code="label.name"/></g:else></th>
            <th title="<g:message code="label.source.detail"/>"><g:message code="names.accepted.source"/></th>
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
                    <cite><g:message code="label.nameAccordingTo"/><span
                            class="publishedIn">${tc.taxonName?.nameAccordingTo ?: tc.taxonConcept.nameAccordingTo}</span>
                    </cite>
                </td>
            </tr>
        </g:if>
        <g:if test="${(tc.taxonName && tc.taxonName.namePublishedIn) || tc.taxonConcept.namePublishedIn}">
            <tr class="cite">
                <td colspan="2">
                    <cite><g:message code="label.namePublishedIn"/><span
                            class="publishedIn">${tc.taxonName?.namePublishedIn ?: tc.taxonConcept.namePublishedIn}</span>
                    </cite>
                </td>
            </tr>
        </g:if>
        <g:if test="${tc.taxonName?.taxonRemarks || tc.taxonConcept?.taxonRemarks}">
            <tr class="remarks">
                <td colspan="2">
                    <g:each in="${tc.taxonName?.taxonRemarks ?: tc.taxonConcept?.taxonRemarks}" var="remark">
                    <p class="taxonRemarks">${remark}</p>
                    </g:each>
                </td>
            </tr>
        </g:if>
        <g:if test="${tc.taxonName?.provenance || tc.taxonConcept?.provenance}">
            <tr class="provenance">
                <td colspan="2">
                    <g:each in="${tc.taxonName?.provenance ?: tc.taxonConcept?.provenance}" var="statement">
                        <p class="provenanceStatement">${statement}</p>
                    </g:each>
                </td>
            </tr>
        </g:if>
        </tbody>
    </table>

    <g:if test="${tc.synonyms}">
        <table class="table name-table table-responsive">
            <thead>
            <tr>
                <th title="<g:message code="label.synonym.detail"/>"><g:message code="label.synonym"/></th>
                <th title="<g:message code="label.source.detail"/>"><g:message code="label.source"/></th>
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
                        <span class="annotation annotation-taxonomic-status" title="${message(code: 'taxonomicStatus.' + synonym.taxonomicStatus + '.detail', default: '')}"><g:message code="taxonomicStatus.${synonym.taxonomicStatus}.annotation" default="${synonym.taxonomicStatus}"/></span>
                        <g:if test="${synonym.nomenclaturalStatus && synonym.nomenclaturalStatus != synonym.taxonomicStatus}"><span class="annotation annotation-nomenclatural-status">${synonym.nomenclaturalStatus}</span></g:if>
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
                <g:if test="${synonym.namePublishedIn && synonym.namePublishedIn != tc?.taxonConcept?.namePublishedIn}">
                    <tr class="cite">
                        <td colspan="2">
                            <cite><g:message code="label.namePublishedIn"/><span
                                    class="publishedIn">${synonym.namePublishedIn}</span>
                            </cite>
                        </td>
                    </tr>
                </g:if>
                <g:if test="${synonym.referencedIn }">
                    <tr class="cite">
                        <td colspan="2">
                            <cite><g:message code="label.referencedIn"/><span
                                    class="publishedIn">${synonym.referencedIn}</span>
                            </cite>
                        </td>
                    </tr>
                </g:if>
                <g:if test="${synonym.taxonRemarks}">
                    <tr class="remarks">
                        <td colspan="2">
                            <g:each in="${synonym.taxonRemarks}" var="remark">
                                <p class="taxonRemarks">${remark}</p>
                            </g:each>
                        </td>
                    </tr>
                </g:if>
                <g:if test="${synonym.provenance}">
                    <tr class="provenance">
                        <td colspan="2">
                            <g:each in="${synonym.provenance}" var="statement">
                                <p class="provenanceStatement">${statement}</p>
                            </g:each>
                        </td>
                    </tr>
                </g:if>
            </g:each>
            </tbody>
        </table>
    </g:if>

    <g:if test="${tc.pullCommonNames}">
        <table class="table name-table table-responsive">
            <thead>
            <tr>
                <th title="${grailsApplication.config.vernacularName.pull.labelDetail}">${grailsApplication.config.vernacularName.pull.label}</th>
                <th title="<g:message code="label.source.detail"/>"><g:message code="label.source"/></th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${tc.pullCommonNames}" var="cn">
                <g:set var="name" value="${cn.nameString}"/>
                <g:set var="language" value="${cn.language}"/>
                <g:set var="infoSource" value="${cn.infoSourceURL}"/>
                <g:set var="isInfoSourceURL" value="${infoSource && infoSource.matches('[a-z]+://.*')}"/>
                <g:set var="datasetURL" value="${cn.datasetURL}"/>
                <tr>
                    <td>
                        <bie:markLanguage text="${name}" lang="${language}" mark="${!grailsApplication.config.vernacularName.pull.showLanguage}" href="${isInfoSourceURL && infoSource != datasetURL ? infoSource : null}"/>
                        <bie:markCommonStatus status="common" tags="${cn.labels}"/>
                        <g:if test="${cn.temporal}"><span title="${message(code: 'label.temporal.vernacular.detail', default: 'Used with a specific time period')}" class="annotation annotation-temporal">${cn.temporal}</span></g:if>
                        <g:if test="${cn.locality || cn.countryCode}"><span title="${message(code: 'label.locality.vernacular.detail', default: 'Used in a specific locality or country')}" class="annotation annotation-locality">${cn.locality} <bie:country code="${cn.countryCode}"/></span></g:if>
                        <g:if test="${cn.sex}"><span title="${message(code: 'label.sex.vernacular.detail', default: 'Used with a specific sex')}" class="annotation annotation-sex">${cn.sex}</span></g:if>
                        <g:if test="${cn.lifeStage}"><span title="${message(code: 'label.lifeStage.vernacular.detail', default: 'Used with a specific life-stage')}" class="annotation annotation-life-stage">${cn.lifeStage}</span></g:if>
                        <g:if test="${cn.isPlural}"><span title="${message(code: 'label.isPlural.vernacular.detail', default: 'Plural form of name')}" class="annotation annotation-is-plural"><g:message code="label.isPlural.vernacular" default="plural"/></span></g:if>
                        <g:if test="${cn.organismPart}"><span title="${message(code: 'label.organismPart.vernacular.detail', default: 'Used for a specific part')}" class="annotation annotation-organism-part">${cn.organismPart}</span></g:if>
                    </td>
                    <td class="source">
                        <ul>
                            <g:if test="${grailsApplication.config.getProperty('vernacularName.pull.showLanguage', Boolean, false)}">
                                <li>
                                    <bie:showLanguage lang="${language}"/>
                                </li>
                            </g:if>
                            <li>
                                <g:if test="${cn.datasetURL}"><a href="${cn.datasetURL}" target="_blank">${cn.infoSourceName}</a></g:if>
                                <g:else>${cn.infoSourceName}</g:else>
                            </li>
                        </ul>
                    </td>
                </tr>
                <g:if test="${!isInfoSourceURL && infoSource}">
                    <tr class="cite">
                        <td colspan="2">
                            <cite><g:message code="label.namePublishedIn"/><span
                                    class="publishedIn">${infoSource}</span>
                            </cite>
                        </td>
                    </tr>
                </g:if>
                <g:if test="${cn.taxonRemarks}">
                    <tr class="remarks">
                        <td colspan="2">
                            <g:each in="${cn.taxonRemarks}" var="remark">
                                <p class="taxonRemarks">${remark}</p>
                            </g:each>
                        </td>
                    </tr>
                </g:if>
                <g:if test="${cn.provenance}">
                    <tr class="provenance">
                        <td colspan="2">
                            <g:each in="${cn.provenance}" var="statement">
                                <p class="provenanceStatement">${statement}</p>
                            </g:each>
                        </td>
                    </tr>
                </g:if>
            </g:each>
            </tbody></table>
    </g:if>

    <g:if test="${tc.standardCommonNames}">
        <table class="table name-table table-responsive">
            <thead>
            <tr>
                <th title="<g:message code="label.commonName.detail"/>"><g:message code="label.commonName"/></th>
                <th title="<g:message code="label.source.detail"/>"><g:message code="label.source"/></th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${tc.standardCommonNames}" var="cn">
                <g:set var="name" value="${cn.nameString}"/>
                <g:set var="language" value="${cn.language}"/>
                <g:set var="infoSource" value="${cn.infoSourceURL}"/>
                <g:set var="isInfoSourceURL" value="${infoSource && infoSource.matches('[a-z]+://.*')}"/>
                <g:set var="datasetURL" value="${cn.datasetURL}"/>
                <tr>
                    <td>
                        <bie:markLanguage text="${name}" lang="${language}" href="${isInfoSourceURL && infoSource != datasetURL ? infoSource : null}"/>
                        <bie:markCommonStatus status="${cn.status}" tags="${cn.labels}"/>
                        <g:if test="${cn.temporal}"><span title="${message(code: 'label.temporal.vernacular.detail', default: 'Used with a specific time period')}" class="annotation annotation-temporal">${cn.temporal}</span></g:if>
                        <g:if test="${cn.locality || cn.countryCode}"><span title="${message(code: 'label.locality.vernacular.detail', default: 'Used in a specific locality or country')}" class="annotation annotation-locality">${cn.locality} <bie:country code="${cn.countryCode}"/></span></g:if>
                        <g:if test="${cn.sex}"><span title="${message(code: 'label.sex.vernacular.detail', default: 'Used with a specific sex')}" class="annotation annotation-sex">${cn.sex}</span></g:if>
                        <g:if test="${cn.lifeStage}"><span title="${message(code: 'label.lifeStage.vernacular.detail', default: 'Used with a specific life-stage')}" class="annotation annotation-life-stage">${cn.lifeStage}</span></g:if>
                        <g:if test="${cn.isPlural}"><span title="${message(code: 'label.isPlural.vernacular.detail', default: 'Plural form of name')}" class="annotation annotation-is-plural"><g:message code="label.isPlural.vernacular" default="plural"/></span></g:if>
                        <g:if test="${cn.organismPart}"><span title="${message(code: 'label.organismPart.vernacular.detail', default: 'Used for a specific part')}" class="annotation annotation-organism-part">${cn.organismPart}</span></g:if>
                    </td>
                    <td class="source">
                        <ul>
                                <li>
                                    <g:if test="${cn.datasetURL}"><a href="${cn.datasetURL}"
                                                                             onclick="window.open(this.href);
                                                                             return false;">${cn.infoSourceName}</a></g:if>
                                    <g:else>${cn.infoSourceName}</g:else>
                                </li>
                        </ul>
                    </td>
                </tr>
                <g:if test="${!isInfoSourceURL && infoSource}">
                    <tr class="cite">
                        <td colspan="2">
                            <cite><g:message code="label.namePublishedIn"/><span
                                    class="publishedIn">${infoSource}</span>
                            </cite>
                        </td>
                    </tr>
                </g:if>
                <g:if test="${cn.taxonRemarks}">
                    <tr class="remarks">
                        <td colspan="2">
                            <g:each in="${cn.taxonRemarks}" var="remark">
                                <p class="taxonRemarks">${remark}</p>
                            </g:each>
                        </td>
                    </tr>
                </g:if>
                <g:if test="${cn.provenance}">
                    <tr class="provenance">
                        <td colspan="2">
                            <g:each in="${cn.provenance}" var="statement">
                                <p class="provenanceStatement">${statement}</p>
                            </g:each>
                        </td>
                    </tr>
                </g:if>
            </g:each>
            </tbody></table>
    </g:if>

    <g:if test="${tc.variants}">
        <table class="table name-table table-responsive">
            <thead>
            <tr>
                <th title="<g:message code="label.name.detail"/>"><g:message code="label.name"/></th>
                <th title="<g:message code="label.source.detail"/>"><g:message code="label.source"/></th>
            </tr>
            </thead>
            <tbody>
            <g:each in="${tc.variants}" var="variant">
                <tr>
                    <td>
                        <g:set var="variantNameFormatted"><bie:formatSciName rankId="${variant.rankID}"
                                                                             nameFormatted="${variant.nameFormatted}"
                                                                             nameComplete="${variant.nameComplete}"
                                                                             taxonomicStatus="name"
                                                                             name="${variant.nameString}"/></g:set>
                        <g:if test="${variant.infoSourceURL && variant.infoSourceURL != variant.datasetURL}"><a
                                href="${variant.infoSourceURL}" target="_blank"
                                class="external">${raw(variantNameFormatted)}</a></g:if>
                        <g:else>${raw(variantNameFormatted)}</g:else>
                        <span class="annotation annotation-taxonomic-status" title="${message(code: 'taxonomicStatus.' + variant.taxonomicStatus + '.detail', default: '')}"><g:message code="taxonomicStatus.${variant.taxonomicStatus}.annotation" default="${variant.taxonomicStatus}"/></span>
                        <g:if test="${variant.nomenclaturalStatus && variant.nomenclaturalStatus != variant.taxonomicStatus}"><span class="annotation annotation-nomenclatural-status">${variant.nomenclaturalStatus}</span></g:if>
                    </td>
                    <td class="source">
                        <ul><li>
                            <g:if test="${variant.datasetURL}"><a href="${variant.datasetURL}"
                                                                  target="_blank"
                                                                  class="external">${variant.nameAuthority ?: variant.infoSourceName}</a></g:if>
                            <g:else>${variant.nameAuthority ?: variant.infoSourceName}</g:else>
                        </li></ul>
                    </td>
                </tr>
                <g:if test="${variant.nameAccordingTo && variant.nameAccordingTo != tc?.taxonConcept?.nameAccordingTo}">
                    <tr class="cite">
                        <td colspan="2">
                            <cite><g:message code="label.nameAccordingTo"/><span
                                    class="publishedIn">${variant.nameAccordingTo}</span>
                            </cite>
                        </td>
                    </tr>
                </g:if>
                <g:if test="${variant.namePublishedIn && variant.namePublishedIn != tc?.taxonConcept?.namePublishedIn}">
                    <tr class="cite">
                        <td colspan="2">
                            <cite><g:message code="label.namePublishedIn"/><span
                                    class="publishedIn">${variant.namePublishedIn}</span>
                            </cite>
                        </td>
                    </tr>
                </g:if>
                <g:if test="${variant.taxonRemarks}">
                    <tr class="remarks">
                        <td colspan="2">
                            <g:each in="${variant.taxonRemarks}" var="remark">
                                <p class="taxonRemarks">${remark}</p>
                            </g:each>
                        </td>
                    </tr>
                </g:if>
                <g:if test="${variant.provenance}">
                    <tr class="provenance">
                        <td colspan="2">
                            <g:each in="${variant.provenance}" var="statement">
                                <p class="provenanceStatement">${statement}</p>
                            </g:each>
                        </td>
                    </tr>
                </g:if>
            </g:each>
            </tbody>
        </table>
    </g:if>

    <g:if test="${tc.identifiers && !tc.identifiers.isEmpty()}">
        <table class="table name-table table-responsive">
            <thead>
            <tr>
                <th title="<g:message code="label.identifier.detail"/>"><g:message code="label.identifier"/></th>
            <th title="<g:message code="label.source.detail"/>"><g:message code="label.source"/></th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <g:each in="${tc.identifiers}" var="identifier">
                <tr>
                    <td>
                        <g:if test="${identifier.infoSourceURL && identifier.infoSourceURL != identifier.datasetURL}"><a
                                href="${identifier.infoSourceURL}" target="_blank"
                                class="external">${identifier.identifier}</a></g:if>
                        <g:else>${identifier.identifier}</g:else>
                        <g:if test="${identifier.nameString}"><span class="annotation annotation-format">${identifier.nameString}</span></g:if>
                        <g:if test="${identifier.format}"><span title="${message(code: 'identifierFormat.' + identifier.format + '.detail', default: '')}"
                                                                class="annotation annotation-format"><g:message code="identifierFormat.${identifier.format}" default="${identifier.format}"/></span></g:if>
                        <g:if test="${identifier.status}"><span title="${message(code: 'identifierStatus.' + identifier.status + '.detail', default: '')}"
                                                                class="annotation annotation-status"><g:message code="identifierFormat.${identifier.status}" default="${identifier.status}"/></span></g:if>
                    </td>
                    <td class="source">
                        <ul>
                            <li>
                                <g:if test="${identifier.datasetURL}"><a href="${identifier.datasetURL}"
                                                                         onclick="window.open(this.href);
                                                                         return false;">${identifier.infoSourceName}</a></g:if>
                                <g:else>${identifier.infoSourceName}</g:else>
                            </li>
                        </ul>
                    </td>
                </tr>
                <g:if test="${identifier.provenance}">
                    <tr class="provenance">
                        <td colspan="2">
                            <g:each in="${identifier.provenance}" var="statement">
                                <p class="provenanceStatement">${statement}</p>
                            </g:each>
                        </td>
                    </tr>
                </g:if>
            </g:each>
        </tbody></table>
    </g:if>
</section>
