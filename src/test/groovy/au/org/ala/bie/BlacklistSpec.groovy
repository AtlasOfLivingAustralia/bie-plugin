package au.org.ala.bie


import spock.lang.Specification

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
        blacklist.isBlacklisted('Acacia', 'https://www.badplace.org/Acacia', 'Acacia')
        !blacklist.isBlacklisted('Acacia', 'https://www.notabadplace.org/Acacia', 'Acacia')
        !blacklist.isBlacklisted(null, null, null)
        blacklist.isBlacklisted(null, 'https://www.worseplace.org/eol/Acacia', null)
        blacklist.isBlacklisted('Acacia', 'http://www.worseplace.org/eol/Acacia', null)
        !blacklist.isBlacklisted(null, 'https://wwwxworseplace.org/eol/Acacia', 'Acacia')
        !blacklist.isBlacklisted(null, 'https://www.worseplace.org/xxx/Acacia', null)
    }


    void "test test name 1"() {
        when:
        Blacklist blacklist = Blacklist.read(this.class.getResource("blacklist-2.json"))
        then:
        blacklist.isBlacklisted('Acacia', null, null)
        blacklist.isBlacklisted('acacia Mill.', null, null)
        blacklist.isBlacklisted('Acacia    Miller', null, null)
        blacklist.isBlacklisted('acacia dealbata', 'https://www.badplace.org/Acacia', 'Acacia')
        blacklist.isBlacklisted('Acacia dealbata dealbata','https://www.badplace.org/Acacia', 'Acacia')
        blacklist.isBlacklisted('Acacia   pycnantha', null, null)
        blacklist.isBlacklisted('Acacia pycnantha Benth.', null, null)
        !blacklist.isBlacklisted('Acacia inops', 'https://www.badplace.org/Acacia_inops', 'Acacia Inops')
        !blacklist.isBlacklisted('Reptilia', null, null)
        !blacklist.isBlacklisted(null, null, null)
    }

    void "test test title 1"() {
        when:
        Blacklist blacklist = Blacklist.read(this.class.getResource("blacklist-3.json"))
        then:
        blacklist.isBlacklisted(null, null, 'Acacia Pest')
        blacklist.isBlacklisted('Acacia Mill.', null, 'Acacia   pest species')
        !blacklist.isBlacklisted('Acacia dealbata', 'https://www.badplace.org/Acacia', 'Acacia dealbata')
        !blacklist.isBlacklisted('Acacia dealbata dealbata','https://www.badplace.org/Acacia', 'Nothing')
        !blacklist.isBlacklisted(null, null, null)
    }

    void "test test mixed 1"() {
        when:
        Blacklist blacklist = Blacklist.read(this.class.getResource("blacklist-4.json"))
        then:
        blacklist.isBlacklisted('Acacia', 'https://www.badplace.org/Acacia', 'Acacia Pest')
        blacklist.isBlacklisted('Acacia dealbata', 'https://www.worseplace.org/eol/Acacia_dealbata', 'Invasive species')
        blacklist.isBlacklisted('Acacia', 'https://www.otherplace.org/Acacia', 'List of introduced species')
        !blacklist.isBlacklisted('Acacia dealbata', 'https://www.badplace.org/Acacia_dealbata', 'Acacia Pest')
        !blacklist.isBlacklisted('Acacia dealbata', 'https://www.worseplace.org/eol/Acacia_dealbata', 'Description')
        !blacklist.isBlacklisted('Acacia dealbata', 'https://www.otherplace.org/Acacia', 'List of introduced species')
        !blacklist.isBlacklisted('Acacia', 'https://www.otherplace.org/Acacia', 'Acacia Pest')
        !blacklist.isBlacklisted('Acacia dealbata', 'https://www.worseplace.org/eol/Acacia_dealbata', 'Species list')
        !blacklist.isBlacklisted('Acacia', 'https://www.otherplace.org/Acacia', 'List of native species')
        !blacklist.isBlacklisted(null, null, null)
    }

}
