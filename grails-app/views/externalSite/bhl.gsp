<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="${grailsApplication.config.skin.layout ?: 'main'}"/>
    <title><g:message code="page.bhl.title"/></title>
    <asset:stylesheet src="show.css"/>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h1><g:message code="page.bhl.title"/></h1>
    </div>
    <g:render template="bhl"/>
</div>
</body>
</html>