package au.org.ala.bie

/**
 * Stub i18nMessages for jquery.i18n.properties
 */
class I18nMessagesController {
    static defaultAction = "i18n"

    def i18n() {
        String catalogue = params.catalogue
        response.setHeader("Content-type", "text/plain; charset=UTF-8")
        response.setCharacterEncoding("UTF-8")
        render text: "# Stub i18nMessages for ${catalogue}"
    }
}
