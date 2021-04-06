package au.org.ala.bie

import com.fasterxml.jackson.annotation.JsonProperty

/**
 * Json serialisable metadata for external resources
 */
class Metadata {
    @JsonProperty
    String title
    @JsonProperty
    String description
    @JsonProperty
    String version
    @JsonProperty
    Date created
    @JsonProperty
    Date modified
}
