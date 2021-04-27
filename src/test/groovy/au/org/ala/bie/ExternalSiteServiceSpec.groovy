package au.org.ala.bie

import com.stehno.ersatz.ContentType
import com.stehno.ersatz.Encoders
import com.stehno.ersatz.ErsatzServer
import grails.test.mixin.TestFor
import groovy.json.JsonSlurper
import org.owasp.html.HtmlPolicyBuilder
import org.owasp.html.PolicyFactory
import org.yaml.snakeyaml.Yaml
import spock.lang.AutoCleanup
import spock.lang.Specification

import java.util.regex.Pattern

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
@TestFor(ExternalSiteService)
class ExternalSiteServiceSpec extends Specification {
    @AutoCleanup
    ErsatzServer server

    PolicyFactory policy


    def setup() {
        server = new ErsatzServer()
        server.reportToConsole()
        service.setConfiguration(grailsApplication.config)

        String allowedElements = "h2,div,a,br,i,b,span,ul,li,p,sup"
        String allowedAttributes ="href;a;^(http|https|mailto|#).+,class;span,id;span,src;img;^(http|https).+"

        HtmlPolicyBuilder builder = new HtmlPolicyBuilder()
                .allowStandardUrlProtocols()
                .requireRelNofollowOnLinks()

        if (allowedElements) {
            String[] elements = allowedElements.split(",")
            elements.each {
                builder.allowElements(it)
            }
        }

        if (allowedAttributes){
            String[] attributes = allowedAttributes.split(",")
            attributes.each { attribute ->
                String[] values = attribute.split (";")
                if (values.length == 2){
                    builder.allowAttributes(values[0]).onElements(values[1])
                } else {
                    builder.allowAttributes(values[0]).matching(Pattern.compile(values[2], Pattern.CASE_INSENSITIVE)).onElements(values[1])
                }

            }
        }

        policy = builder.toFactory()
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

    void "test suspect attributes"() {
        given:
        def text = 'Some invalid image attribute <a href="http://en.wikipedia.org/wiki/File:1_Acacia_oswaldii_foliage.jpg"><img alt=" src=" width="220" height="230"></a>'
        when:
        def html = service.sanitiseBodyText(policy, text)
        then:
        html == 'Some invalid image attribute <a href="http://en.wikipedia.org/wiki/File:1_Acacia_oswaldii_foliage.jpg" rel="nofollow"></a>'
    }

    void "test disallowed elements"() {
        given:
        def text = 'Some invalid element <h1>h1 content</h1>'
        when:
        def html = service.sanitiseBodyText(policy, text)
        then:
        html == 'Some invalid element h1 content'
    }

    void "test valid html text"() {
        given:
        def text = '<h2>Contents</h2> <span></span></div> <ul> <li><a href=\"#Description\"><span>1</span> <span>Description</span></a></li> <li><a href=\"#Distribution\"><span>2</span> <span>Distribution</span></a></li> <li><a href=\"#Classification\"><span>3</span> <span>Classification</span></a></li> <li><a href=\"#See_also\"><span>4</span> <span>See also</span></a></li> <li><a href=\"#References\"><span>5</span> <span>References</span></a></li> </ul> </div> '
        when:
        def html = service.sanitiseBodyText(policy, text)
        then:
        html == '<h2>Contents</h2>  <ul><li><a href="#Description" rel="nofollow">1 Description</a></li><li><a href="#Distribution" rel="nofollow">2 Distribution</a></li><li><a href="#Classification" rel="nofollow">3 Classification</a></li><li><a href="#See_also" rel="nofollow">4 See also</a></li><li><a href="#References" rel="nofollow">5 References</a></li></ul>  '
    }

}
