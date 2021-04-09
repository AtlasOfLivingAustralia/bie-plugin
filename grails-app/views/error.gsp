<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>An error has occurrence | BIE</title>
    <meta name="layout" content="${grailsApplication.config.skin.layout}"/>
</head>
<body>
    <header id="page-header">
        <div class="inner row-fluid">
            <nav id="breadcrumb" class="span12">
                <ol class="breadcrumb">
                    <li><a href="https://biodiversityatlas.at">Home</a> <span class=" icon icon-arrow-right"></span></li>
                    <li><a href="https://biodiversityatlas.at">Australia&#39;s species</a> <span class=" icon icon-arrow-right"></span></li>
                    <li class="active">Biodiversity Information Explorer (BIE)</li>
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