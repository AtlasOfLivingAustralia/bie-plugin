<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:message code="error.main.title" /></title>
    <meta name="layout" content="${grailsApplication.config.skin.layout}"/>
</head>
<body>
    <header id="page-header">
        <div class="inner row-fluid">
            <nav id="breadcrumb" class="span12">
                <ol class="breadcrumb">
                    <li><a href="${alaUrl}"><g:message code="home" /></a> <span class=" icon icon-arrow-right"></span></li>
                    <li><g:message code="error.url" args="[alaUrl]" /> <span class=" icon icon-arrow-right"></span></li>
                    <li class="active"><g:message code="error.title" /></li>
                </ol>
            </nav>
            <hgroup>
                <h1>Error</h1>
            </hgroup>
        </div>
    </header>
    <div class="inner">
        <div>${message}</div>
        %{--<div>${exception}</div>--}%
        %{--<!-- class: ${exception.metaClass?.getTheClass()} -->--}%
        <g:renderException exception="${exception}" />
    </div>
</body>
</html>