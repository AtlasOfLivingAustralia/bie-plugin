modules = {
    bootstrap {
        dependsOn 'jquery'
        resource url: [dir: 'bootstrap3/js', file: 'bootstrap.js', plugin:'bie-plugin'], disposition: 'head', exclude: '*'
        resource url: [dir: 'bootstrap3/css', file: 'bootstrap.min.css', plugin:'bie-plugin'], attrs: [media: 'screen, projection, print']
    }

    bie {
        dependsOn 'bootstrap', 'ekko'
        resource url: [dir: 'js', file: 'atlas.js', plugin:'bie-plugin'], disposition: 'head', exclude: '*'
        resource url: [dir: 'css', file: 'atlas.css', plugin:'bie-plugin'], attrs: [media: 'screen, projection, print']
    }

    application {
        resource url: [dir: 'js', file: 'application.js', plugin:'bie-plugin']
    }

    search {
        resource url: [dir: 'js', file: 'jquery.sortElemets.js', plugin:'bie-plugin']
        resource url: [dir: 'js', file: 'search.js', plugin:'bie-plugin']
    }

    show {
        dependsOn 'cleanHtml, ekko'
        resource url: 'https://ajax.googleapis.com/jsapi', attrs: [type: 'js'], disposition: 'head'
        resource url: "http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.js", attrs: [type: 'js'], disposition: 'head'
        resource url: "http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.css", attrs: [type: 'css'], disposition: 'head'

        resource url: [dir: 'css', file: 'species.css', plugin:'bie-plugin']
        resource url: [dir: 'css', file: 'jquery.qtip.min.css', plugin:'bie-plugin']
        resource url: [dir: 'js', file: 'jquery.sortElemets.js', plugin:'bie-plugin', disposition: 'head']
        resource url: [dir: 'js', file: 'jquery.jsonp-2.3.1.min.js', plugin:'bie-plugin', disposition: 'head']
        resource url: [dir: 'js', file: 'trove.js', plugin:'bie-plugin', disposition: 'head']

        resource url: [dir: 'js', file: 'charts2.js', plugin:'bie-plugin', disposition: 'head']
        resource url: [dir: 'js', file: 'species.show.js', plugin:'bie-plugin', disposition: 'head']
        resource url: [dir: 'js', file: 'audio.min.js', plugin:'bie-plugin', disposition: 'head']
        resource url: [dir: 'js', file: 'jquery.qtip.min.js', plugin:'bie-plugin', disposition: 'head']
        resource url: [dir: 'js', file: 'moment.min.js', plugin:'bie-plugin', disposition: 'head']
    }

    cleanHtml {
        resource url: [dir: 'js', file: 'jquery.htmlClean.js', plugin:'bie-plugin', disposition: 'head']
    }

    ekko {
        resource url: [dir: 'css', file: 'ekko-lightbox.css', plugin:'bie-plugin']
        resource url: [dir: 'js', file: 'ekko-lightbox.min.js', plugin:'bie-plugin']
    }
}