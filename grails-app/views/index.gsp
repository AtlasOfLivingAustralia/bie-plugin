<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.skin.layout}"/>
    <title>Biodiversity Information Explorer</title>
</head>
<body class="page-search">

<section class="container">
    <h1>Search for taxa</h1>
    <div class="section">
        <form id="search-inpage" action="search" method="get" name="search-form" class="form-horizontal">
            <div class="form-group">
                <input id="search" class="form-control" name="q" type="text" placeholder="Search the Atlas" autocomplete="off">
            </div>
            <div class="form-group">
                <input type="submit" class="btn btn-primary" alt="Search" value="Search">
            </div>
        </form>
    </div>
</section><!--end .inner-->
</body>
</html>