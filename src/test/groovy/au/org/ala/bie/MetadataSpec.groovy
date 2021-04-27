package au.org.ala.bie

import com.fasterxml.jackson.databind.ObjectMapper
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.services.ServiceUnitTestMixin} for usage instructions
 */
class MetadataSpec extends Specification {
    void "test read from source 1"() {
        given:
        def mapper = new ObjectMapper()
        when:
        def metadata = mapper.readValue(this.class.getResource("metadata-1.json"), Metadata.class)
        then:
        metadata.title == "Some test metadata"
        metadata.description == "A test description"
        metadata.version == "1.1"
        metadata.created != null
        metadata.modified != null
    }

    void "test read from source 2"() {
        given:
        def mapper = new ObjectMapper()
        when:
        def metadata = mapper.readValue(this.class.getResource("metadata-2.json"), Metadata.class)
        then:
        metadata.title == null
        metadata.description == "Another test description"
        metadata.version == null
        metadata.created == null
        metadata.modified == null
    }
}
