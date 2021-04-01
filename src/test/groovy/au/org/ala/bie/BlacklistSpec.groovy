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
        blacklist.blacklist[0] instanceof Blacklist.Rule
        blacklist.blacklist[0].source.pattern() == "https://www.badplace.org.*"
    }

    void "test test URL 1"() {
        when:
        Blacklist blacklist = Blacklist.read(this.class.getResource("blacklist-1.json"))
        then:
        blacklist.test('Acacia', 'https://www.badplace.org/Acacia', 'Acacia')
        !blacklist.test('Acacia', 'https://www.notabadplace.org/Acacia', 'Acacia')
        !blacklist.test(null, null, null)
        blacklist.test(null, 'https://www.worseplace.org/eol/Acacia', null)
        blacklist.test('Acacia', 'http://www.worseplace.org/eol/Acacia', null)
        !blacklist.test(null, 'https://wwwxworseplace.org/eol/Acacia', 'Acacia')
        !blacklist.test(null, 'https://www.worseplace.org/xxx/Acacia', null)
    }


    void "test test name 1"() {
        when:
        Blacklist blacklist = Blacklist.read(this.class.getResource("blacklist-2.json"))
        then:
        blacklist.test('Acacia', null, null)
        blacklist.test('acacia Mill.', null, null)
        blacklist.test('Acacia    Miller', null, null)
        blacklist.test('acacia dealbata', 'https://www.badplace.org/Acacia', 'Acacia')
        blacklist.test('Acacia dealbata dealbata','https://www.badplace.org/Acacia', 'Acacia')
        blacklist.test('Acacia   pycnantha', null, null)
        blacklist.test('Acacia pycnantha Benth.', null, null)
        !blacklist.test('Acacia inops', 'https://www.badplace.org/Acacia_inops', 'Acacia Inops')
        !blacklist.test('Reptilia', null, null)
        !blacklist.test(null, null, null)
    }

    void "test test title 1"() {
        when:
        Blacklist blacklist = Blacklist.read(this.class.getResource("blacklist-3.json"))
        then:
        blacklist.test(null, null, 'Acacia Pest')
        blacklist.test('Acacia Mill.', null, 'Acacia   pest species')
        !blacklist.test('Acacia dealbata', 'https://www.badplace.org/Acacia', 'Acacia dealbata')
        !blacklist.test('Acacia dealbata dealbata','https://www.badplace.org/Acacia', 'Nothing')
        !blacklist.test(null, null, null)
    }

    void "test test mixed 1"() {
        when:
        Blacklist blacklist = Blacklist.read(this.class.getResource("blacklist-4.json"))
        then:
        blacklist.test('Acacia', 'https://www.badplace.org/Acacia', 'Acacia Pest')
        blacklist.test('Acacia dealbata', 'https://www.worseplace.org/eol/Acacia_dealbata', 'Invasive species')
        blacklist.test('Acacia', 'https://www.otherplace.org/Acacia', 'List of introduced species')
        !blacklist.test('Acacia dealbata', 'https://www.badplace.org/Acacia_dealbata', 'Acacia Pest')
        !blacklist.test('Acacia dealbata', 'https://www.worseplace.org/eol/Acacia_dealbata', 'Description')
        !blacklist.test('Acacia dealbata', 'https://www.otherplace.org/Acacia', 'List of introduced species')
        !blacklist.test('Acacia', 'https://www.otherplace.org/Acacia', 'Acacia Pest')
        !blacklist.test('Acacia dealbata', 'https://www.worseplace.org/eol/Acacia_dealbata', 'Species list')
        !blacklist.test('Acacia', 'https://www.otherplace.org/Acacia', 'List of native species')
        !blacklist.test(null, null, null)
    }

}
