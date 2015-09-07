package au.org.ala.bie

import grails.converters.JSON
import groovy.json.JsonSlurper
import org.jsoup.Jsoup
import org.jsoup.nodes.Document
import org.jsoup.select.Elements

/**
 * Controller that proxies external webservice calls to get around cross domain issues
 * and to make consumption of services easier from javascript.
 */
class ExternalSiteController {

    def grailsApplication

    def index() {}

    def genbankBase = "http://www.ncbi.nlm.nih.gov"
    def scholarBase = "http://scholar.google.com"

    def eol = {
        def searchString = params.s
        def nameEncoded = java.net.URLEncoder.encode(searchString, "UTF-8")
        def searchURL = "http://eol.org/api/search/1.0.json?q=${nameEncoded}&page=1&exact=true&filter_by_taxon_concept_id=&filter_by_hierarchy_entry_id=&filter_by_string=&cache_ttl="

        def js = new JsonSlurper()
        def jsonText = new java.net.URL(searchURL).text

        def json = js.parseText(jsonText)

        //get first pageId
        if(json.results){
            def pageId = json.results[0].id
            def pageUrl = "http://eol.org/api/pages/1.0/${pageId}.json?images=00&videos=0&sounds=0&maps=0&text=2&iucn=false&subjects=overview&licenses=all&details=true&references=true&vetted=0&cache_ttl="
            log.debug(pageUrl)
            def pageText = new java.net.URL(pageUrl).text
            response.setContentType("application/json")
            render pageText
        } else {
            response.setContentType("application/json")
            render ([:] as JSON)
        }
    }

    def genbank = {

        def searchStrings = params.list("s")
        def searchParams = URLEncoder.encode("\"" + searchStrings.join("\" OR \"") + "\"", "UTF-8")
        def url = (genbankBase + "/nuccore/?term=" + searchParams)

        Document doc = Jsoup.connect(url).get()
        Elements results = doc.select("div.rslt")

        def totalResultsRaw = doc.select("h2.result_count").text()
        def totalResults = 0
        def formattedResults = []

        if(totalResultsRaw){
            totalResults = totalResultsRaw
            results.each { result ->
                def titleEl = result.getElementsByClass("title")
                def linkTag = titleEl.get(0).getElementsByTag("a")
                def link = genbankBase + linkTag.get(0).attr("href")
                def title = linkTag.get(0).text()
                def description = result.select('p[class=desc]').text()
                def furtherDescription = result.select('dl[class=rprtid]').text()
                formattedResults << [link:link,title:title,description:description, furtherDescription:furtherDescription]
            }
        }

        render(contentType: "text/json") {
            [total:totalResults, resultsUrl:url, results:formattedResults]
        }
    }

    def scholar = {

        def searchStrings = params.list("s")
        def searchParams = "\"" + searchStrings.join("\" OR \"") + "\""
        def url = scholarBase + "/scholar?q=" + URLEncoder.encode(searchParams, "UTF-8")
        def doc = Jsoup.connect(url).userAgent("Mozilla/5.0 (Windows; U; WindowsNT 5.1; en-US; rv1.8.1.6) Gecko/20070725 Firefox/2.0.0.6").referrer("http://www.google.com").get()
        def totalResultsRaw = doc.select("div[id=gs_ab_md]").get(0).text()
        def matcher = totalResultsRaw =~ "About ([0-9\\,]{1,}) results \\([0-9\\.]{1,} sec\\)"
        def found = matcher.find()
        def totalResults = 0
        def formattedResults = []

        if(found){
            totalResults = matcher.group(1)
            def results = doc.select("div[class=gs_r]")
            results.each { result ->
                def link = result.select("a").attr("href")
                if(!link.startsWith("http")){
                    link =  scholarBase + link
                }
                def title = result.select("a").text()
                def description = result.select("div[class=gs_a]")?.get(0).text()

                def furthEl = result.select("div[class=gs_rs]")
                def furtherDescription = ""
                if(!furthEl.empty){
                    furtherDescription = furthEl.get(0).text()
                }
                formattedResults << [link:link,title:title,description:description, furtherDescription:furtherDescription]
            }
        }

        render(contentType: "text/json") {
            [total:totalResults, resultsUrl:url, results:formattedResults]
        }
    }
}
