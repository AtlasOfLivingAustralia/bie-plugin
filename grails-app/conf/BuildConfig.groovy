grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.target.level = 1.8
grails.project.source.level = 1.8


//grails.plugin.location."ala-charts-plugin" = "../ala-charts-plugin"

grails.project.fork = [
        test: false,
        run: true
]

grails.project.dependency.resolver = "maven" // or ivy
grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // uncomment to disable ehcache
        // excludes 'ehcache'
    }
    log "warn" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    repositories {
        mavenLocal()
        mavenRepo ("http://nexus.ala.org.au/content/groups/public/")
    }

    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes eg.
        compile("au.org.ala:ala-name-matching:2.4.0") {
            excludes "lucene-core", "lucene-analyzers-common", "lucene-queryparser", "simmetrics"
        }
        compile ('org.jasig.cas.client:cas-client-core:3.4.1') {
            excludes([group: 'javax.servlet', name: 'servlet-api'])
        }
        compile "commons-httpclient:commons-httpclient:3.1",
                "org.codehaus.jackson:jackson-core-asl:1.8.6",
                "org.codehaus.jackson:jackson-mapper-asl:1.8.6"
        runtime "org.jsoup:jsoup:1.8.3"

        compile group: 'org.grails.plugins', name: 'ala-bootstrap3', version: '3.0.0-SNAPSHOT', changing: true
        compile(group: 'org.grails.plugins', name: 'ala-auth', version:'3.1.0-SNAPSHOT', changing: true) {
            exclude group: 'javax.servlet', module: 'servlet-api'
        }
        compile group: 'org.grails.plugins', name: 'ala-admin-plugin', version: '2.0-SNAPSHOT', changing: true
        compile "org.grails.plugins:grails-spring-websocket:2.3.0"

    }

    plugins {
        build(":release:3.0.1",
                ":rest-client-builder:2.0.3") {
            export = false
        }
        runtime ":ala-bootstrap3:2.0.0-SNAPSHOT"
        runtime(":ala-auth:2.2-SNAPSHOT") {
            excludes "servlet-api"
        }
        compile ":asset-pipeline:2.14.1"
        runtime ":ala-charts-plugin:1.3"
        runtime ":jquery:1.11.1"
        compile ':cache:1.1.8'
        runtime ":rest:0.8"
        build ":tomcat:7.0.55"
        compile ":images-client-plugin:0.8"
    }
}
