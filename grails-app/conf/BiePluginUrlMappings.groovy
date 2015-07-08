class BiePluginUrlMappings {

    static mappings = {
        "/$controller/$action?/$id?"{
            constraints {
                // apply constraints here
            }
        }
        // Redirects for BIE web services URLs
        "/species/$guid"(controller: "species", action: "show")
        "/search"(controller: "species", action: "search")
        "/image-search"(controller: "species", action: "imageSearch")
        "/image-search/"(controller: "species", action: "imageSearch")
        "/image-search/showSpecies"(controller: "species", action: "imageSearch")
        "/image-search/infoBox"(controller: "species", action: "infoBox")
        "/bhl-search"(controller: "species", action: "bhlSearch")
        "/sound-search"(controller: "species", action: "soundSearch")
        "/logout"(controller: "species", action: "logout")
        "/"(view:"/home")
        "500"(view:'/error')
    }
}