/*
 * Copyright (C) 2018 Atlas of Living Australia
 * All Rights Reserved.
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 */
package au.org.ala.bie

import groovy.util.logging.Log4j
import org.grails.spring.context.support.PluginAwareResourceBundleMessageSource

/**
 * Custom messsage source to expose all message for i18n controller
 * as required for jQuery.i18n.properties plugin.
 *
 * @author "Nick dos Remedios <Nick.dosRemedios@csiro.au>"
 */
@Log4j
class ExtendedPluginAwareResourceBundleMessageSource extends PluginAwareResourceBundleMessageSource {

    /**
     * Provide a complete listing of properties for a given locale, as a Map
     * Client app properties override those from this plugin
     *
     * @param locale
     * @return
     */
    Properties listMessageCodes(Locale locale) {
        def appProps = this.getMergedProperties(locale).getProperties() // only gives i18n codes for ala-bie
        def pluginProps = this.getMergedPluginProperties(locale).getProperties() // only gives i18n codes for bie-plugin
        // created a merged set of properties
        Properties mergedProps = new Properties()
        mergedProps.putAll(appProps)
        mergedProps.putAll(pluginProps)

        mergedProps
    }
}
