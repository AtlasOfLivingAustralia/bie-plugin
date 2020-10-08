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
<g:set var="alaUrl" value="${grailsApplication.config.ala.baseURL}"/>
<!DOCTYPE html>
<html>
<head>
    <title>${params.q} | Literature search | ${grailsApplication.config.skin.orgNameLong}</title>
    <meta name="layout" content="${grailsApplication.config.skin.layout}"/>
    <asset:javascript src="jquery.htmlClean.js"/>
    <script type="text/javascript">
        /**
         * OnLoad equavilent in JQuery
         */
        $(document).ready(function () {
            loadBhl(0, 10, false);
        });

        /**
         * BHL search to populate literature tab
         *
         * @param start
         * @param rows
         * @param scroll
         */
        function doBhlSearch(start, rows, scroll) {
            if (!start) {
                start = 0;
            }
            if (!rows) {
                rows = 10;
            }
            // var url = "http://localhost:8080/bhl-ftindex-demo/search/ajaxSearch?q=" + $("#tbSearchTerm").val();
            var searchInput = "${params.q}";
            //var synonyms = SHOW_CONF.synonymsQuery;
            var query = ""; // = taxonName.split(/\s+/).join(" AND ") + synonyms;
            if (searchInput) {
                var terms = searchInput.split(/\s+/).length;
                if (terms > 2) {
                    query += searchInput.split(/\s+/).join(" AND ");
                } else if (terms == 2) {
                    query += '"' + searchInput + '"';
                } else {
                    query += searchInput;
                }
            }

            if (!query) {
                return cancelSearch("No names were found to search BHL");
            }

            var source = "${grailsApplication.config.literature?.bhl?.url ?: '//bhlidx.ala.org.au/select'}";
            var url = source + "?q=" + query + '&start=' + start + "&rows=" + rows +
                "&wt=json&fl=name%2CpageId%2CitemId%2Cscore&hl=on&hl.fl=text&hl.fragsize=200&" +
                "group=true&group.field=itemId&group.limit=11&group.ngroups=true&taxa=false";
            var buf = "";
            $("#status-box").css("display", "block");
            $("#synonyms").html("").css("display", "none")
            $("#results").html("");

            $.ajax({
                url: url,
                dataType: 'jsonp',
                //data: null,
                jsonp: "json.wrf",
                success: function (data) {
                    var itemNumber = parseInt(data.responseHeader.params.start, 10) + 1;
                    var maxItems = parseInt(data.grouped.itemId.ngroups, 10);
                    if (maxItems == 0) {
                        return cancelSearch("No references were found for <code>" + query + "</code>");
                    }
                    var startItem = parseInt(start, 10);
                    var pageSize = parseInt(rows, 10);
                    var showingFrom = startItem + 1;
                    var showingTo = (startItem + pageSize <= maxItems) ? startItem + pageSize : maxItems;
                    //console.log(startItem, pageSize, showingTo);
                    var pageSize = parseInt(rows, 10);
                    buf += '<div class="results-summary">Showing ' + showingFrom + " to " + showingTo + " of " + maxItems +
                        ' results for the query <code>' + query + '</code>.</div>'
                    // grab highlight text and store in map/hash
                    var highlights = {};
                    $.each(data.highlighting, function (idx, hl) {
                        highlights[idx] = hl.text[0];
                        //console.log("highlighting", idx, hl);
                    });
                    //console.log("highlighting", highlights, itemNumber);
                    $.each(data.grouped.itemId.groups, function (idx, obj) {
                        buf += '<div class="result-box">';
                        buf += '<b>' + itemNumber++;
                        buf += '.</b> <a target="item" href="//biodiversitylibrary.org/item/' + obj.groupValue + '">' + obj.doclist.docs[0].name + '</a> ';
                        var suffix = '';
                        if (obj.doclist.numFound > 1) {
                            suffix = 's';
                        }
                        buf += '(' + obj.doclist.numFound + '</b> matching page' + suffix + ')<div class="thumbnail-container">';

                        $.each(obj.doclist.docs, function (idx, page) {
                            var highlightText = $('<div>' + highlights[page.pageId] + '</div>').htmlClean({allowedTags: ["em"]}).html();
                            buf += '<div class="page-thumbnail"><a target="page image" href="//biodiversitylibrary.org/page/' +
                                page.pageId + '"><img src="//biodiversitylibrary.org/pagethumb/' + page.pageId +
                                '" alt="Page Id ' + page.pageId + '"  width="60px" height="100px"/><div class="highlight-context">' +
                                highlightText + '</div></a></div>';
                        })
                        buf += "</div><!--end .thumbnail-container -->";
                        buf += "</div>";
                    })

                    var prevStart = start - rows;
                    var nextStart = start + rows;
                    //console.log("nav buttons", prevStart, nextStart);

                    buf += '<div id="button-bar">';
                    if (prevStart >= 0) buf += '<input type="button" value="Previous page" onclick="doBhlSearch(' + prevStart + ',' + rows + ', true)">';
                    buf += '&nbsp;&nbsp;&nbsp;';
                    if (nextStart <= maxItems) buf += '<input type="button" value="Next page" onclick="doBhlSearch(' + nextStart + ',' + rows + ', true)">';
                    buf += '</div>';

                    $("#solr-results").html(buf);
                    if (data.synonyms) {
                        buf = "<b>Synonyms used:</b>&nbsp;";
                        buf += data.synonyms.join(", ");
                        $("#synonyms").html(buf).css("display", "block");
                    } else {
                        $("#synonyms").html("").css("display", "none");
                    }
                    $("#status-box").css("display", "none");

                    if (scroll) {
                        $('html, body').animate({scrollTop: '300px'}, 300);
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    $("#status-box").css("display", "none");
                    $("#solr-results").html('An error has occurred, probably due to invalid query syntax');
                }
            });
        } // end doSearch

        function cancelSearch(msg) {
            $("#status-box").css("display", "none");
            $("#solr-results").html(msg);
            return true;
        }

    </script>
</head>

<body class="nav-species bhl-search">
<header id="page-header" class="heading-bar">
    <div class="inner row-fluid">
        <nav id="breadcrumb" class="span12">
            <ol class="breadcrumb">
                <li><a href="${alaUrl}">Home</a> <span class=" icon icon-arrow-right"></span></li>
                <li class="active"> <g:message code="bhl.search"/>BHL Search</li>
            </ol>
        </nav>
    </div>

    <h1><g:message code="bhl.search.bhl"/></h1>
</header>

<div class="inner">
    <section id="content-search">
        <form id="search-form" action="" method="get" name="search-form">
            %{--<label for="search">Search</label>--}%
            <div class="input-append">
                <input id="search" class="span4" name="q" type="text" placeholder="Search BHL" autocomplete="off"
                       value="${params.q ?: ''}">
                <input type="submit" class="btn" alt="Search" value="Search">
            </div>
        </form>
    </section>

    <div id="status-box" class="column-wrap" style="display: none;">
        <div id="search-status" class="column-wrap">
            <span style="vertical-align: middle; ">
                <g:message code="bhl.search.wait"/>
                <img src="${resource(dir: 'css/images', file: 'indicator.gif')}" alt="Searching"
                     style="vertical-align: middle;"/>
            </span>
        </div>
    </div>

    <div id="results-home" class="column-wrap">
        <div id="synonyms" style="display: none">
        </div>

        <div class="column-wrap" id="solr-results">
        </div>
    </div>
</div>
</body>
</html>