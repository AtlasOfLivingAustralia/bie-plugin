package au.org.ala.bie

import com.stehno.ersatz.ContentType
import com.stehno.ersatz.Encoders
import com.stehno.ersatz.ErsatzServer
import grails.test.mixin.TestFor
import groovy.json.JsonSlurper
import org.yaml.snakeyaml.Yaml
import spock.lang.AutoCleanup
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
@TestFor(ExternalSiteService)
class ExternalSiteServiceSpec extends Specification {
    @AutoCleanup
    ErsatzServer server

    def setup() {
        server = new ErsatzServer()
        server.reportToConsole()
        service.setConfiguration(grailsApplication.config)
    }

    def cleanup() {
    }

    protected Map getResponse(String resource) {
        JsonSlurper slurper = new JsonSlurper()
        return slurper.parse(this.class.getResource(resource), 'UTF-8')
    }


    void "test get BHL literature"() {
        given:
        server.expectations {
            get('/api3') {
                query('op', 'PublicationSearch')
                query('searchterm', '\"Acacia dealbata\"')
                query('page', '1')
                query('apikey', '<key value>')
                query('format', 'json')
                called(1)
                responder {
                    encoder(ContentType.APPLICATION_JSON, Map, Encoders.json)
                    code(200)
                    body(getResponse('bhl-search-1.json'), ContentType.APPLICATION_JSON)
                }
            }

        }
        when:
        service.bhlApi = server.httpUrl + '/api3'
        def response = service.searchBhl(['Acacia dealbata'], 0, 10, false)
        then:
        response != null
        response.max == 2
        response.more == false
        response.start == 0
        response.rows == 10
        response.search != null
        response.search in List
        response.search.size() == 1
        response.results != null
        response.results in List
        response.results.size() == 2
        def result = response.results[0]
        result.type == 'article-journal'
        result.title == 'Allelopathic effect of the invasive Acacia dealbata Link (Fabaceae) on two native plant species in south-central Chile'
    }
}
