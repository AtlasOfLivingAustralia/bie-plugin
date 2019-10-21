package bie.plugin

class BootStrap {
    def messageSource

    def init = { servletContext ->
        messageSource.setBasenames(
                // For some reason, setting basenames in BiePluginGrailsPlugin
                // does not work as expected extending PluginAwareResourceBundleMessageSource
                // https://stackoverflow.com/questions/16063391/grails-override-a-bean-property-value-in-resources-groovy
                // so we do here that works:q
                "file:///var/opt/atlas/i18n/bie-plugin/messages",
                "file:///opt/atlas/i18n/bie-plugin/messages",
                "classpath:grails-app/i18n/messages",
        )
        Object.metaClass.trimLength = { Integer stringLength ->

            String trimString = delegate?.toString()
            String concatenateString = "..."
            List separators = [".", " "]

            if (stringLength && (trimString?.length() > stringLength)) {
                trimString = trimString.substring(0, stringLength - concatenateString.length())
                String separator = separators.findAll { trimString.contains(it) }?.min { trimString.lastIndexOf(it) }
                if (separator) {
                    trimString = trimString.substring(0, trimString.lastIndexOf(separator))
                }
                trimString += concatenateString
            }
            return trimString
        }
    }

    def destroy = {
    }
}
