<g:set var="orgNameLong" value="${grailsApplication.config.skin.orgNameLong}"/>
<g:set var="orgNameShort" value="${grailsApplication.config.skin.orgNameShort}"/>
<g:applyLayout name="ala-main">
    <head>
        <title><g:layoutTitle/></title>
        <meta name="breadcrumb" content="${pageProperty(name: 'meta.breadcrumb', default: pageProperty(name: 'title').split('\\|')[0].decodeHTML())}"/>
        <script type="text/javascript">
            var BIE_VARS = { "autocompleteUrl" : "${grailsApplication.config.bie.index.url}/search/auto.jsonp"}
        </script>
        <g:layoutHead/>
    </head>
    <body>
    <g:layoutBody />
    </body>
</g:applyLayout>
