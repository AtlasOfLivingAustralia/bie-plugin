package au.org.ala.bie

class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?"{
            constraints {
                // apply constraints here
            }
        }
        // Redirects for BIE web services URLs
        "/geo"(controller: "species", action: "geoSearch")
        "/species/$guid**"(controller: "species", action: "show")
        "/search"(controller: "species", action: "search")
        "/image-search"(controller: "species", action: "imageSearch")
        "/image-search/showSpecies"(controller: "species", action: "imageSearch")
        "/image-search/infoBox"(controller: "species", action: "infoBox")
        "/image-search/$id**"(controller: "species", action: "imageSearch")
        "/bhl-search"(controller: "species", action: "bhlSearch")
        "/sound-search"(controller: "species", action: "soundSearch")
        "/logout"(controller: "species", action: "logout")
        "/"(view:"/index")
        "500"(view:'/error')
    }
}