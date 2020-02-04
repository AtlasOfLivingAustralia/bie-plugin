/*
 * Copyright (C) 2012 Atlas of Living Australia
 * All Rights Reserved.
 *
 * The contents of this file are subject to the Mozilla Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 */

var TROVE = {
    s: '*',
    sPrevious: '',
    n: 10,
    q: "",
    totalResults: 0,
    nextStart: null,
    divId: '',
    nextButtonId: '',
    previousButtonId: '',
    containerDivId: ''
}

function getTroveUrl(){
    var sNext = (TROVE.nextStart != null) ? TROVE.nextStart : TROVE.s;
    var url = TROVE.url + '&q=' + encodeURIComponent(TROVE.q) + '&s=' + encodeURIComponent(sNext) + '&n=' + TROVE.n;
    // console.log("url..... " + url);
    return url;
}

function loadTrove(url, query, synonyms, containerDivId, resultsDivId, previousButtonId, nextButtonId){
    if (synonyms) {
        for (var i = 0; i < synonyms.length; i++) {
            query = query + '" OR "' + (synonyms[i]);
        }
    }
    // console.log("query: " + query);

    TROVE.url = url;
    TROVE.q = '"' + query + '"';
    TROVE.containerDivId = containerDivId
    TROVE.divId = resultsDivId
    // TROVE.nextButtonId =  nextButtonId;
    // TROVE.previousButtonId =  previousButtonId;
    // $('#'+TROVE.nextButtonId).click(function(){ troveNextPage();});
    // $('#'+TROVE.previousButtonId).click(function(){ trovePreviousPage();});
    queryTrove();
}

function troveNextPage(){
    if(TROVE.nextStart != null){
        // TROVE.s += TROVE.nextStart;
        queryTrove();
        scrollToTopOfTrove();
    }
}

function trovePreviousPage(){
    if(TROVE.sPrevious != "*"){
        TROVE.s = TROVE.sPrevious;
        queryTrove();
        scrollToTopOfTrove();
    }
}

function scrollToTopOfTrove(){
    var topOfTrove = $('#trove-integration').offset();
    $('html, body').animate({scrollTop: topOfTrove.top-30},"slow");
}

function queryTrove(){
    $.ajax({
        url: getTroveUrl(),
        dataType: 'jsonp',
        data: null,
        jsonp: "callback",
        success:  function(data) {
            TROVE.totalResults = data.response.zone[0].records.total;
            // TROVE.nextStart = (data.response.zone[0].records.nextStart == undefined) ? null : data.response.zone[0].records.nextStart;
            // TROVE.sPrevious = data.response.zone[0].records.s;

            if(TROVE.totalResults == 0){
                $('#'+TROVE.containerDivId).css({display:'none'});
            } else {
                var showTroveLink = (TROVE.totalResults > TROVE.n);
                var toRecord = showTroveLink ? 10 : TROVE.totalResults;
                var buff = '<div class="results-summary">Showing 1 ' + ' to ' + toRecord + " of " + TROVE.totalResults + ' results.</div>';

                $.each(data.response.zone[0].records.work, function(index, value){
                    buff += '<div class="result">';
                    //buff +=  '<a href="' + value.troveUrl + '">';
                    buff += '<h3>';
                    // buff += '<span class="troveIdx">';
                    // buff += '<b>'+ (index + TROVE.s + 1) +'</b>.&nbsp;';
                    // buff += '</span>';
                    buff += '<span class="title"><a href="' + value.troveUrl + '">' + value.title + '</a></span>';
                    buff += '</h3>';
                    if(value.contributor != null){
                        buff +=  '<p class="contributors">Contributors: ';
                        var contribIdx = 0;
                        $.each(value.contributor, function(ci, cv){
                            //console.log('contributor: ' + cv);
                            if(contribIdx>0){
                                buff += '; ';
                            }
                            buff += '<span class="contributor">' + cv + '</span>';
                            contribIdx = contribIdx+1;
                        });
                        buff +=  '</p>';
                    }
                    if(value.issued != null){
                        buff +=  '<p class="dateIssued">Date issued: ' + value.issued + '</p>';
                    }
                    buff +=  '</div>';
                });

                // buff += '<div id="trove-button-bar">';
                // if (TROVE.sPrevious != "*") {
                //     buff += '<input type="button" class="btn" value="Previous page" onclick="trovePreviousPage()">';
                // }
                // buff += '&nbsp;&nbsp;&nbsp;';
                // if (TROVE.nextStart != null) {
                //     buff += '<input type="button" class="btn" value="Next page" onclick="troveNextPage()">';
                // }
                //
                // buff += '</div>';
                var url = SHOW_CONF.troveSiteUrl+ '/result?q=' + encodeURIComponent(TROVE.q);

                if (showTroveLink) {
                    buff += '<a href=' + url + ' target="_trove">More results</a>';
                }
                $('#'+TROVE.divId).html(buff);
            }
        },
        error: function(jqXHR, textStatus, errorThrown) {
            //console.log("Error....");
        }
    });
}