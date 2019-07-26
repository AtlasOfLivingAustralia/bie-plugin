package au.org.ala.bie

import org.grails.spring.context.support.PluginAwareResourceBundleMessageSource

/**
 * Expose all messages.properties for jquery.i18n.properties
 */
class I18nMessagesController {

    def messageSource
    static defaultAction = "i18n"

    def i18n(String id) {
        response.setHeader("Content-type", "text/plain; charset=UTF-8")
        response.setCharacterEncoding("UTF-8")
        Locale locale = request.locale

        if (id && id.startsWith("messages_")) {
            // Assume standard messageSource file name pattern:
            // messages.properties, messages_en.properties, messages_en_US.properties
            // String locale_suffix = id.replaceFirst(/messages_(.*)/,'$1')
            List locBits = id?.tokenize('_')
            locale = new Locale(locBits[1], locBits[2]?:'')
        }

        Properties props = messageSource.listMessageCodes(locale?:request.locale)
        log.debug "message source properties size = ${props.size()}"
        List messages = props.collect{ new String("${it.key}=${it.value}".getBytes("UTF-8"), "UTF-8") }

        render ( text: messages.sort().join("\n") )
    }
}
