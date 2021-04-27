package au.org.ala.bie

import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.databind.ObjectMapper
import java.util.regex.Pattern

/**
 * A list of source information that should be
 * blacklisted.
 */

class Blacklist {
    /** Blacklist metadata */
    @JsonProperty
    Metadata metadata
    /** The source URLs that should be black-listed */
    @JsonProperty
    List<Rule> blacklist

    /**
     * Test an article against the blacklist
     * <p>
     * If this returns true then the article has been blacklisted
     *
     * @param name The taxon name
     * @param source The article source
     * @param title The article title
     *
     * @return {@code true} if the input argument matches the predicate,
     * otherwise {@code false}
     */
    boolean isBlacklisted(String name, String source, String title) {
        return this.blacklist.any({ rule -> rule.match(name, source, title) })
    }

    /**
     * Read a blacklist from a source URL.
     *
     * @param url The source
     *
     * @return The resulting blacklist
     */
    static  Blacklist read(URL url) {
        def mapper = new ObjectMapper()
        def blacklist =  mapper.readValue(url, Blacklist)
        return blacklist
    }

    static class Rule {
        /** Pattern that matches the taxon name */
        Pattern name
        /** Pattern than matches the article source (URL) */
        Pattern source
        /** Pattern that matches the article title */
        Pattern title

        @JsonProperty("name")
        String getNamePattern() {
            return this.name.pattern()
        }

        @JsonProperty("name")
        void setNamePattern(String pattern) {
            this.name = pattern ? Pattern.compile(pattern, Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE) : null
        }

        @JsonProperty("source")
        String getSourcePattern() {
            return this.source.pattern()
        }

        @JsonProperty("Source")
        void setSourcePattern(String pattern) {
            this.source = pattern ? Pattern.compile(pattern) : null
        }

        @JsonProperty("title")
        String getTitlePattern() {
            return this.title.pattern()
        }

        @JsonProperty("title")
        void setTitlePattern(String pattern) {
            this.title = pattern ? Pattern.compile(pattern, Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE) : null
        }

        /**
         * Test to see if a rule matches and article.
         * <p>
         * If a name, source or title is not supplied and the rule expects one,
         * then there is no match.
         *
         * @param name The taxon name
         * @param source The article source URL
         * @param title The article title
         * @return
         */
        boolean match(String name, String source, String title) {
            if (!name && this.name)
                return false
            if (name && this.name && !this.name.matcher(name).matches())
                return false
            if (!source && this.source)
                return false
            if (source && this.source && !this.source.matcher(source).matches())
                return false
            if (!title && this.title)
                return false
            if (title && this.title && !this.title.matcher(title).matches())
                return false
            return true
        }
    }
}
