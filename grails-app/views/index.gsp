<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.skin.layout}"/>
    <title>Species search | ${raw(grailsApplication.config.skin.orgNameLong)}</title>
    <asset:script type="text/javascript">
        // global var to pass GSP vars into JS file
        SEARCH_CONF = {
            bieWebServiceUrl: "${grailsApplication.config.bie.index.url}"
        }
    </asset:script>
    <asset:javascript src="autocomplete-configuration.js"/>
</head>
<body class="page-search">

<section class="container">

    <header class="pg-header">
        <h1>Search for taxa</h1>
    </header>

    <div class="section">
        <form id="search-inpage" action="search" method="get" name="search-form">
            <div class="form-group">
                <input id="taxaFilter" name="fq" type="hidden" value="idxtype:TAXON">
                <input id="search" class="form-control ac_input general-search" name="q" type="text" placeholder="Search the Atlas" autocomplete="off">
            </div>
            <div class="form-group">
                <input type="submit" class="form-control btn btn-primary" alt="Search" value="Search">
            </div>
        </form>
    </div>
</section><!--end .inner-->
</body>
</html>