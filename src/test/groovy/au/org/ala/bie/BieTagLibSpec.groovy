package au.org.ala.bie

import au.org.ala.names.model.RankType
import grails.test.mixin.TestFor
import org.springframework.context.NoSuchMessageException
import org.springframework.context.support.ResourceBundleMessageSource
import spock.lang.Shared
import spock.lang.Specification

@TestFor(BieTagLib)
class BieTagLibSpec extends Specification {
    @Shared
    ResourceBundleMessageSource messageSource = null

    @Shared
    Closure mockMessage = { Map map ->
        try {
            return messageSource.getMessage((String) map.code, (Object[]) map.args, Locale.default)
        } catch (NoSuchMessageException ex) {
            return map.code
        }
    }

    def setupSpec() {
        URL url = new File('grails-app/i18n').toURI().toURL()
        messageSource = new ResourceBundleMessageSource()
        messageSource.bundleClassLoader = new URLClassLoader(url)
        messageSource.basename = 'messages'
        messageSource.setDefaultEncoding("utf-8")
    }

    def setup() {
        tagLib.metaClass.message = mockMessage
    }

    def "test formatSciName 1"() {
        expect:
        tagLib.formatSciName(name: 'Acacia dealbata', rankId: RankType.SPECIES.id) == '<span class="taxon-name"><span class="scientific-name rank-species"><span class="name">Acacia dealbata</span> <span class="author"></span></span></span>'
    }

    def "test formatSciName 2"() {
        expect:
        tagLib.formatSciName(nameComplete: 'Acacia dealbata Link.', name: 'Acacia dealbata', rankId: RankType.SPECIES.id) == '<span class="taxon-name"><span class="scientific-name rank-species"><span class="name">Acacia dealbata</span> <span class="author">Link.</span></span></span>'
    }

    def "test formatSciName 3"() {
        expect:
        tagLib.formatSciName(nameFormatted: '<span>Something else</span>', nameComplete: 'Acacia dealbata Link.', name: 'Acacia dealbata', rankId: RankType.SPECIES.id) == '<span class="taxon-name"><span>Something else</span></span>'
    }

    def "test formatSciName 4"() {
        expect:
        tagLib.formatSciName(nameComplete: 'Aschenfeldtia pimeleoides Meisn.', acceptedName: 'Pimelea microcephala', name: 'Aschenfeldtia pimeleoides', rankId: RankType.SPECIES.id) == '<span class="synonym-name"><span class="scientific-name rank-species"><span class="name">Aschenfeldtia pimeleoides</span> <span class="author">Meisn.</span></span> <span class="accepted-name">(accepted&nbsp;name:&nbsp;<span class="scientific-name rank-species"><span class="name">Pimelea microcephala</span></span>)</span></span>'
    }

    def "test formatSciName 5"() {
        expect:
        tagLib.formatSciName(nameComplete: 'Aschenfeldtia pimeleoides Meisn.', acceptedName: 'Pimelea microcephala', name: 'Aschenfeldtia pimeleoides', rankId: RankType.SPECIES.id, taxonomicStatus: 'heterotypicSynonym') == '<span class="heterotypic-name synonym-name"><span class="scientific-name rank-species"><span class="name">Aschenfeldtia pimeleoides</span> <span class="author">Meisn.</span></span> <span class="accepted-name">(accepted&nbsp;name:&nbsp;<span class="scientific-name rank-species"><span class="name">Pimelea microcephala</span></span>)</span></span>'
    }

    def "test constructEYALink 1"() {
        expect:
        tagLib.constructEYALink(result: [centroid: '-38.9 145.5']) == "<a href='https://biocache.ala.org.au/explore/your-area#145.5|-38.9|12|ALL_SPECIES'></a>"
    }

    def "test colourForStatus 1"() {
        expect:
        tagLib.colourForStatus(status: "") == 'green'
    }

    def "test colourForStatus 2"() {
        expect:
        tagLib.colourForStatus(status: "extinct") == 'extinct'
    }

    def "test colourForStatus 3"() {
        expect:
        tagLib.colourForStatus(status: "locally extinct") == 'black'
    }

    def "test colourForStatus 4"() {
        expect:
        tagLib.colourForStatus(status: "critically endangered") == 'red'
    }

    def "test colourForStatus 5"() {
        expect:
        tagLib.colourForStatus(status: "endangered") == 'orange'
    }

    def "test colourForStatus 6"() {
        expect:
        tagLib.colourForStatus(status: "vulnerable") == 'yellow'
    }

    def "test colourForStatus 7"() {
        expect:
        tagLib.colourForStatus(status: "near threatened") == 'near-threatened'
    }

    def "test searchNavigationLinks 1"() {
        expect:
        tagLib.searchNavigationLinks(totalRecords: 100, startIndex: 20, pageSize: 20, lastPage: 1) == '<ul>\n' +
                '  <li id=\'prevPage\'><a href="?q=null&start=0&title=">&laquo; Previous</a></li><li><a href="?q=null&start=0&title=">1</a></li><li class="currentPage">2</li><li><a href="?q=null&start=40&title=">3</a></li><li><a href="?q=null&start=60&title=">4</a></li><li><a href="?q=null&start=80&title=">5</a></li>\n' +
                '  <li id=\'nextPage\'><a href="?q=null&start=40&title=">Next &raquo;</a></li>\n' +
                '</ul>'
    }

    def "test markLanguage 1"() {
        expect:
        tagLib.markLanguage(text: "Test", lang: Locale.default.language) == '<span lang="' + Locale.default.language + '">Test</span>'
    }

    def "test markLanguage 2"() {
        expect:
        tagLib.markLanguage(text: "Test", lang: "fra") == '<span lang="fra">Test&nbsp;<span class="annotation annotation-language" title="fra">French</span></span>'
    }

    def "test markLanguage 3"() {
        expect:
        tagLib.markLanguage(text: "Test", lang: "D35") == '<span lang="d35">Test&nbsp;<span class="annotation annotation-language" title="D35">Guyambal</span></span>'
    }

    def "test markLanguage 4"() {
        expect:
        tagLib.markLanguage(text: "Test", lang: "D35", href: 'http://localhost') == '<span lang="d35"><a href="http://localhost" target="_blank" class="external">Test</a>&nbsp;<span class="annotation annotation-language" title="D35">Guyambal</span></span>'
    }

    def "test markLanguage 5"() {
        expect:
        tagLib.markLanguage(text: "Test", lang: "D35", mark: false) == '<span lang="d35">Test</span>'
    }

    def "test markLanguage 6"() {
        expect:
        tagLib.markLanguage(text: "Test", lang: "D35", tag: false) == '<span lang="d35">Test<span class="in-marker">&nbsp;in&nbsp;</span><span class="language-name" title="d35">Guyambal</span></span>'
    }

    def "test showLanguage 1"() {
        expect:
        tagLib.showLanguage(lang: 'en') == '<span class="language-name" title="eng"><a href="https://iso639-3.sil.org/code/eng" target="_blank">English</a></span>'
    }

    def "test showLanguage 2"() {
        expect:
        tagLib.showLanguage(lang: 'kr') == '<span class="language-name" title="kau"><a href="https://iso639-3.sil.org/code/kau" target="_blank">Kanuri</a></span>'
    }

    def "test showLanguage 3"() {
        expect:
        tagLib.showLanguage(lang: 'a12') == '<span class="language-name" title="A12"><a href="https://collection.aiatsis.gov.au/austlang/language/a12" target="_blank">Wangkatha</a></span>'
    }

    def "test showLanguage 4"() {
        expect:
        tagLib.showLanguage(lang: 'en', format: false) == 'English'
    }

    def "test showLanguage 5"() {
        expect:
        tagLib.showLanguage(lang: 'xxxx', default: 'Other', format: false) == 'Other'
    }

    def "test markCommonStatus 1"() {
        expect:
        tagLib.markCommonStatus() == ''
    }

    def "test markCommonStatus 2"() {
        expect:
        tagLib.markCommonStatus(status: 'common') == ''
    }

    def "test markCommonStatus 3"() {
        expect:
        tagLib.markCommonStatus(status: 'preferred') == '<span class="annotation annotation-status" title="The preferred common name for this species">preferred</span>'
    }

    def "test markCommonStatus 4"() {
        expect:
        tagLib.markCommonStatus(status: 'common', tags: 'TK S|TK NV') == '<span class="annotation annotation-status" title="A general common name for this species">common</span>&nbsp;<span class="tag tag-tk-s" title="tag.tk-s.detail">tag.tk-s</span>&nbsp;<span class="tag tag-tk-nv" title="tag.tk-nv.detail">tag.tk-nv</span>'
    }

    def "test country 1"() {
        expect:
        tagLib.country(code: 'au') == '<span lang="en">Australia</span>'
    }

    def "test country 2"() {
        expect:
        tagLib.country(code: 'de') == '<span lang="en">Germany</span>'
    }

    def "test country 3"() {
        expect:
        tagLib.country() == ''
    }

    def "test country 4"() {
        expect:
        tagLib.country(code: 'zzzz') == '<span lang="en">ZZZZ</span>'
    }

    def "test displaySearchHighlights 1"() {
        expect:
        tagLib.displaySearchHighlights() == ''
    }

    def "test displaySearchHighlights 2"() {
        expect:
        tagLib.displaySearchHighlights(highlight: "Item 1") == 'Item 1'
    }

    def "test displaySearchHighlights 3"() {
        expect:
        tagLib.displaySearchHighlights(highlight: "Item 1<br>Item 2") == 'Item 1<br/>Item 2'
    }

    def "test displaySearchHighlights 4"() {
        expect:
        tagLib.displaySearchHighlights(highlight: "Item 1<br>Item 2<br>Item 1") == 'Item 1<br/>Item 2'
    }

    def "test displaySearchHighlights 5"() {
        expect:
        tagLib.displaySearchHighlights(highlight: "<b>Item</b> 1<br>Item 1") == '<b>Item</b> 1'
    }
}