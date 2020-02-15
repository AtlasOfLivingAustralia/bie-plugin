package au.org.ala.bie

import grails.test.mixin.TestFor
import org.owasp.html.HtmlPolicyBuilder
import org.owasp.html.PolicyFactory
import spock.lang.Specification

import java.util.regex.Pattern

/**
 * Unit test for {@link au.org.ala.bie.ExternalSiteController}
 */
@TestFor(ExternalSiteController)
class ExternalSiteControllerSpec extends Specification {

    PolicyFactory policy
    def setup() {
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

    void "test suspect attributes"() {
        given:
        def text = 'Some invalid image attribute <a href="http://en.wikipedia.org/wiki/File:1_Acacia_oswaldii_foliage.jpg"><img alt=" src=" width="220" height="230"></a>'
        when:
        def html = controller.sanitiseBodyText(policy, text)
        then:
        html == 'Some invalid image attribute <a href="http://en.wikipedia.org/wiki/File:1_Acacia_oswaldii_foliage.jpg" rel="nofollow"></a>'
    }

    void "test disallowed elements"() {
        given:
        def text = 'Some invalid element <h1>h1 content</h1>'
        when:
        def html = controller.sanitiseBodyText(policy, text)
        then:
        html == 'Some invalid element h1 content'
    }

    void "test valid html text"() {
        given:
        def text = '<h2>Contents</h2> <span></span></div> <ul> <li><a href=\"#Description\"><span>1</span> <span>Description</span></a></li> <li><a href=\"#Distribution\"><span>2</span> <span>Distribution</span></a></li> <li><a href=\"#Classification\"><span>3</span> <span>Classification</span></a></li> <li><a href=\"#See_also\"><span>4</span> <span>See also</span></a></li> <li><a href=\"#References\"><span>5</span> <span>References</span></a></li> </ul> </div> '
        when:
        def html = controller.sanitiseBodyText(policy, text)
        then:
        html == '<h2>Contents</h2>  <ul><li><a href="#Description" rel="nofollow">1 Description</a></li><li><a href="#Distribution" rel="nofollow">2 Distribution</a></li><li><a href="#Classification" rel="nofollow">3 Classification</a></li><li><a href="#See_also" rel="nofollow">4 See also</a></li><li><a href="#References" rel="nofollow">5 References</a></li></ul>  '
    }
}
