package au.org.ala.bie

import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.databind.ObjectMapper

import java.util.function.Function
import java.util.function.Predicate
import java.util.regex.Pattern

/**
 * A list of source information that should be
 * blacklisted.
 */

class Blacklist implements Predicate<String> {
    /** Blacklist metadata */
    @JsonProperty
    Metadata metadata
    /** The source URLs that should be black-listed */
    List<Pattern> blacklist

    @JsonProperty("blacklist")
    List<String> getBlacklistStrings() {
        return this.blacklist.collect { pattern -> pattern.pattern() }
    }

    @JsonProperty("blacklist")
    setBlacklistStrings(List<String> blacklist) {
        this.blacklist = blacklist.collect { pattern -> Pattern.compile(pattern) }
    }

    /**
     * Evaluates this predicate on the given argument.
     * <p>
     * If this returns true then the argument has been blacklisted
     *
     * @param d the input argument
     * @return {@code true} if the input argument matches the predicate,
     * otherwise {@code false}
     */
    @Override
    boolean test(String source) {
        if (!source)
            return false;
        if (this.blacklist.any({ test -> test.matcher(source).matches() }))
            return true;
        return false
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
}
