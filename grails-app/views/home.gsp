%{--
  - Copyright (C) 2012 Atlas of Living Australia
  - All Rights Reserved.
  -
  - The contents of this file are subject to the Mozilla Public
  - License Version 1.1 (the "License"); you may not use this file
  - except in compliance with the License. You may obtain a copy of
  - the License at http://www.mozilla.org/MPL/
  -
  - Software distributed under the License is distributed on an "AS
  - IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
  - implied. See the License for the specific language governing
  - rights and limitations under the License.
  --}%

<%--
  Alternative index page (replaces generated Grails version)
  User: nick
  Date: 25/06/12
  Time: 10:01 AM
--%>

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