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
  Created by IntelliJ IDEA.
  User: nick
  Date: 12/06/12
  Time: 4:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<g:set var="alaUrl" value="${grailsApplication.config.getProperty('ala.baseURL')}"/>
<g:set var="fluidLayout" value="${grailsApplication.config.getProperty('skin.fluidLayout').toBoolean()}"/>
<!doctype html>
<html>
<head>
    <title>
        <g:if test="${taxonConcept}">${taxonConcept.taxonConcept.taxonRank}  ${taxonConcept.taxonConcept.nameString} |</g:if>
        Image browser | ${grailsApplication.config.getProperty('skin.orgNameLong')}
    </title>
    <meta name="layout" content="${grailsApplication.config.getProperty('skin.layout')}"/>
    <asset:script type="text/javascript">
        var prevPage = 0;
        var currentPage = 0;
        var lastPage, noOfColumns;
        var pageSize = 50; // was: no of columns * 12 in bie code
        var processing = false;

        /**
         * OnLoad equivalent in JQuery
         */
        $(document).ready(function() {
            // initial load images
            imageLoad();

            // trigger button - when inview doesn't work, e.g. iPad
            $("#loadMoreButton").click(function(e) {
                e.preventDefault();
                imageLoad();
            });

            // mouse over affect on thumbnail images
            $('#imageResults').on('hover', '.imgCon', function() {
                $(this).find('.brief, .detail').toggleClass('hide');
            });
        });

        function imageLoad() {
            processing = true;
            $('#divPostsLoader').html('<img src="${resource(dir: "images", file: "spinner.gif")}"/>');

            //send a query to server side to present new content
            $.ajax({
                type: "GET",
                url: "${grailsApplication.config.getProperty('bie.index.url')}/imageSearch/${taxonConcept?.taxonConcept?.guid}?start=" + (currentPage * pageSize) + "&rows=" + pageSize,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    if (data) {
                        $("#totalImageCount").text(data.searchResults.totalRecords);
                        addImages(data.searchResults);
                        currentPage = currentPage + 1;
                        $('#divPostsLoader').empty();
                    }
                }
            }).done(function() {
                processing = false;
            });
        }

        function addImages(data) {

            if (data.results.length > 0) {
                $.each(data.results, function(i, el) {
                    //console.log('el', i, el);
                    if(el.image) {
                        var scientificName = (el.nameComplete) ? "<i>" + el.nameComplete + "</i>" : "";
                        var commonName = (el.commonNameSingle) ? el.commonNameSingle + "<br/> " : "";
                        var imageUrl = "${grailsApplication.config.getProperty('image.thumbnailUrl')}" + el.image;
                        var titleText = $("<div/>" + commonName.replace("<br/>", " - ") + scientificName).text();
                        var $ImgCon = $('.imgConTmpl').clone();
                        $ImgCon.removeClass('imgConTmpl').removeClass('hide');
                        var link = $ImgCon.find('a.thumbImage');
                        link.attr('href', '${grailsApplication.config.getProperty('grails.serverURL')}/species/' + el.guid);
                        link.attr('title', titleText);
                        $ImgCon.find('img').attr('src', imageUrl);
                        $ImgCon.find('.brief').html(commonName + scientificName);

                        var detail = scientificName + " " + el.author;
                        if (el.commonNameSingle) detail += "<br>" + el.commonNameSingle;
                        if (el.family)  detail += "<br>Family: " + el.family;
                        if (el.order)  detail += "<br>Order: " + el.order;
                        if (el.class)  detail += "<br>Class: " + el.class;
                        $ImgCon.find('.detail').html(detail);

                        $("#imageResults").append($ImgCon.html());
                    }
                });
                // add delay for trigger div
                $("#loadMoreTrigger").delay(500).show();
            } else {
                $("#loadMoreTrigger").hide();
            }
        }

        function numberWithCommas(x) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }

        function htmlDecode(input){
            var e = document.createElement('div');
            e.innerHTML = input;
            return e.childNodes.length === 0 ? "" : e.childNodes[0].nodeValue;
        }

    </asset:script>
    <style type="text/css">

    body {
        padding-left: 15px;
        padding-right: 15px;
    }

    #imageResults {
        margin-top: 20px;
        margin-bottom: 30px;
    }

    .imgContainer a:link {
        text-decoration: none;
    }

    div#loadMoreTrigger {
        margin-bottom: 24px;
        text-align: center;
    }

    .imgCon {
        display: inline-block;
        text-align: center;
        line-height: 1.3em;
        background-color: #DDD;
        color: #DDD;
        font-size: 12px;
        margin: 2px 0 2px 0;
        position: relative;
    }

    .imgCon img {
        height: 200px;
    }

    .imgCon .meta {
        opacity: 0.8;
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        overflow: hidden;
        text-align: left;
        padding: 4px 5px 2px 5px;
    }

    .imgCon .brief {
        color: black;
        background-color: white;
    }

    .imgCon .detail {
        color: white;
        background-color: black;
        opacity: 0.7;
    }

    </style>
</head>

<body class="nav-species  image-search">
<header id="page-header" class="heading-bar">
    <div class="inner row">
        <nav id="breadcrumb" class="span12">
            <ol class="breadcrumb">
                <li>
                    <a href="${alaUrl}">Home</a> <span class="icon icon-arrow-right"></span>
                </li>
                <li>
                    <g:link controler="species" action="search"><g:message code="images.specie"/></g:link>
                    <span class=" icon icon-arrow-right"></span>
                </li>
                <li class="active">
                    <g:if test="${taxonConcept}">
                        <g:message code="images.for"/>
                        ${taxonConcept.taxonConcept.nameString}
                    </g:if>
                    <g:else>
                        <g:message code="images.species"/>
                    </g:else>
                </li>
            </ol>
        </nav>
    </div>

    <h1>
        <g:message code="images.of"/>
        <b id="totalImageCount">...</b>
        <g:message code="images.specie"/>
        <g:if test="${taxonConcept}">
            <g:message code="images.from"/> ${taxonConcept.taxonConcept.taxonRank}
            <a href="${grailsApplication.config.getProperty('grails.serverURL')}/species/${taxonConcept?.taxonConcept?.guid}"
               title="More information on this ${taxonConcept?.taxonConcept?.taxonRank}">${taxonConcept?.taxonConcept?.nameString}
            </a>
        </g:if>
    </h1>
</header>

<div>
    <%-- template used by AJAX code --%>
    <div class="imgConTmpl hide">
        <div class="imgCon">
            <a class="thumbImage" rel="thumbs" href="" id="thumb">
                <img src="" class="searchImage" alt="image thumbnail"/>

                <div class="meta brief"></div>

                <div class="meta detail hide"></div>
            </a>
        </div>
    </div>

    <div id="imageResults">
        <!-- image objects get inserted here by JS -->
    </div>

    <div id="divPostsLoader" style="margin-left:auto;margin-right:auto; width:120px;"></div>

    <div id="loadMoreTrigger" style="display: block;">
        <input type="button" id="loadMoreButton" class="btn btn-primary" value="Carregar mais imagens"/>
    </div>
</div>
</body>
</html>