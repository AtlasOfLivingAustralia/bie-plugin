package au.org.ala.bie

import com.fasterxml.jackson.databind.ObjectMapper
import spock.lang.Specification

import java.util.regex.Pattern

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
class BlacklistSpec extends Specification {
    void "test read from source 1"() {
        when:
        Blacklist blacklist = Blacklist.read(this.class.getResource("blacklist-1.json"))
        then:
        def metadata = blacklist.metadata
        metadata.title == "Test blacklist 1"
        metadata.version == "1.1"
        blacklist.blacklist != null
        blacklist.blacklist.size() == 2
        blacklist.blacklist[0] instanceof Pattern
        blacklist.blacklist[0].pattern() == "https://www.badplace.org.*"
    }

    void "test predicate URL 1"() {
        when:
        Blacklist blacklist = Blacklist.read(this.class.getResource("blacklist-1.json"))
        then:
        blacklist.test('https://www.badplace.org/Acacia')
        !blacklist.test('https://www.notabadplace.org/Acacia')
        !blacklist.test(null)
        blacklist.test('https://www.worseplace.org/eol/Acacia')
        blacklist.test('http://www.worseplace.org/eol/Acacia')
        !blacklist.test('https://wwwxworseplace.org/eol/Acacia')
        !blacklist.test('https://www.worseplace.org/xxx/Acacia')
    }


    void "test predicate Name 1"() {
        when:
        Blacklist blacklist = Blacklist.read(this.class.getResource("blacklist-2.json"))
        then:
        blacklist.test('Acacia')
        blacklist.test('Acacia Mill.')
        blacklist.test('Acacia    Miller')
        blacklist.test('Acacia dealbata')
        blacklist.test('Acacia dealbata dealbata')
        blacklist.test('Acacia   pycnantha')
        blacklist.test('Acacia pycnantha Benth.')
        !blacklist.test('Acacia inops')
        !blacklist.test('Reptilia')
        !blacklist.test(null)
    }

}
