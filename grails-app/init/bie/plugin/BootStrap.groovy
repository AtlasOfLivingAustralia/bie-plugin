package bie.plugin

import au.org.ala.dataquality.api.DataProfilesApi
import au.org.ala.dataquality.api.QualityServiceRpcApi
import au.org.ala.dataquality.client.ApiClient
import au.org.ala.dataquality.model.QualityProfile
import retrofit2.Call

class BootStrap {
    def messageSource
    def grailsApplication

    def init = { servletContext ->
        messageSource.setBasenames(
                // For some reason, setting basenames in BiePluginGrailsPlugin
                // does not work as expected extending PluginAwareResourceBundleMessageSource
                // https://stackoverflow.com/questions/16063391/grails-override-a-bean-property-value-in-resources-groovy
                // so we do here that works:q
                "file:///var/opt/atlas/i18n/bie-plugin/messages",
                "file:///opt/atlas/i18n/bie-plugin/messages",
                "classpath:grails-app/i18n/messages",
                "classpath:messages"
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

        initConfig()
    }

    def destroy = {
    }

    void initConfig(){
        //Check if qualityProfile is used
        if ( grailsApplication.config.dataquality.enabled ) {
            if (grailsApplication.config.dataquality.baseUrl) {
                QualityServiceRpcApi api
                DataProfilesApi dataProfilesApi
                def apiClient = new ApiClient()
                apiClient.adapterBuilder.baseUrl(grailsApplication.config.dataquality.baseUrl)

                api = apiClient.createService(QualityServiceRpcApi)
                def profile = (QualityProfile) responseOrThrow(api.activeProfile(null))
                if (profile) {
                    grailsApplication.config.with {
                        qualityProfile = profile.shortName
                    }
                    log.info("Quality Profile: " + grailsApplication.config.qualityProfile)
                }
            } else {
                log.warn("Data quality is enabled, but the url of data quality service is not defined!")
            }
        }
    }

    private <T> T responseOrThrow(Call<T> call) {
        def response
        try {
            response = call.execute()
        } catch (IOException e) {
            log.error("IOException executing call {}", call.request(), e)
        }
        if (response.successful) {
            return response.body()
        } else {
            log.error("Non-successful call {} returned response {}", call.request(), response)
        }
    }
}
