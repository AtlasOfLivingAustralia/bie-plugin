<!doctype html>
<html>
    <head>
        <title><g:message code="page.not.found.title" /></title>
        <meta name="layout" content="main">
        <g:if env="development"><asset:stylesheet src="errors.css"/></g:if>
    </head>
    <body>
        <ul class="errors">
            <li><g:message code="page.error.page.not.found.desc" /></li>
            <li>Path: ${request.forwardURI}</li>
        </ul>
    </body>
</html>
