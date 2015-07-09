grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"

grails.project.fork = [
    // configure settings for compilation JVM, note that if you alter the Groovy version forked compilation is required
    //  compile: [maxMemory: 256, minMemory: 64, debug: false, maxPerm: 256, daemon:true],

    // configure settings for the test-app JVM, uses the daemon by default
    test: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256, daemon:true],
    // configure settings for the run-app JVM
    run: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256, forkReserve:false],
    // configure settings for the run-war JVM
    war: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256, forkReserve:false],
    // configure settings for the Console UI JVM
    console: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256]
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
        compile("au.org.ala:ala-name-matching:2.3") {
            excludes "lucene-core", "lucene-analyzers-common", "lucene-queryparser", "simmetrics"
        }
        compile "commons-httpclient:commons-httpclient:3.1",
                "org.codehaus.jackson:jackson-core-asl:1.8.6",
                "org.codehaus.jackson:jackson-mapper-asl:1.8.6"
        compile 'org.jasig.cas.client:cas-client-core:3.1.12'
        runtime 'org.jsoup:jsoup:1.7.2'
    }

    plugins {
        build(":release:3.0.1",
                ":rest-client-builder:2.0.3") {
            export = false
        }
        runtime ":jquery:1.11.1"
        runtime ":resources:1.2.8"
        compile ':cache:1.0.1'
        runtime ":rest:0.8"
        build ":tomcat:7.0.53"
    }
}
