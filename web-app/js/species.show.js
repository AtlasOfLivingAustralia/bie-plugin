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
function showSpeciesPage() {

    console.log("Starting show species page");

    //load content
    loadOverviewImages();
    loadMap();
    loadGalleries();
    loadExpertDistroMap();
    loadExternalSources();
    loadSpeciesLists();
    loadDataProviders();
    //
    ////setup controls
    addAlerts();
    loadBhl();
    loadTrove(SHOW_CONF.scientificName,'trove-integration','trove-result-list','previousTrove','nextTrove');
}

function loadSpeciesLists(){

    console.log('### loadSpeciesLists #### ' + SHOW_CONF.speciesListUrl + '/ws/species/' + SHOW_CONF.guid);
    $.get(SHOW_CONF.speciesListUrl + '/ws/species/' + SHOW_CONF.guid, function( data ) {
        for(var i = 0; i < data.length; i++) {
            var specieslist = data[i];

            if (specieslist.list.isBIE) {

                var $description = $('#descriptionTemplate').clone();
                $description.css({'display': 'block'});
                $description.attr('id', '#specieslist-block-' + specieslist.dataResourceUid);
                $description.addClass('species-list-block');
                $description.find(".title").html(specieslist.list.listName);

                var content = "<dl class='dl-horizontal species-list-dl'>";
                $.each(specieslist.kvpValues, function (idx, kvpValue) {
                    var value = kvpValue.value;
                    if(kvpValue.vocabValue){
                        value = kvpValue.vocabValue;
                    }
                    content += "<dt style='white-space: normal;'>" + (kvpValue.key + "</dt><dd>" + value + "</dd>");
                });
                content += "</dl>";

                $description.find(".content").html(content);

                $description.find(".source").css({'display':'none'});
                $description.find(".rights").css({'display':'none'});

                $description.find(".providedBy").attr('href', SHOW_CONF.speciesListUrl + '/speciesListItem/list/' + specieslist.dataResourceUid);
                $description.find(".providedBy").html(specieslist.list.listName);

                $description.appendTo('#listContent');
            }
        }
    });
}

function addAlerts(){
    // alerts button
    $("#alertsButton").click(function(e) {
        e.preventDefault();
        var query = "Species: " + SHOW_CONF.scientificName;
        var searchString = "?q=" + SHOW_CONF.guid;
        var url = SHOW_CONF.alertsUrl + "/ws/createBiocacheNewRecordsAlert?";
        url += "queryDisplayName=" + encodeURIComponent(query);
        url += "&baseUrlForWS=" + encodeURIComponent(SHOW_CONF.biocacheUrl);
        url += "&baseUrlForUI=" + encodeURIComponent(SHOW_CONF.serverName);
        url += "&webserviceQuery=%2Fws%2Foccurrences%2Fsearch" + encodeURIComponent(searchString);
        url += "&uiQuery=%2Foccurrences%2Fsearch%3Fq%3D*%3A*";
        url += "&resourceName=" + encodeURIComponent("Atlas");
        window.location.href = url;
    });
}

function loadMap() {

    if(SHOW_CONF.map != null){
        return;
    }

    //add an occurrence layer for this taxon
    var taxonLayer = L.tileLayer.wms(SHOW_CONF.biocacheServiceUrl + "/mapping/wms/reflect?q=lsid:" +
        SHOW_CONF.guid + "&qc=" + SHOW_CONF.mapQueryContext, {
        layers: 'ALA:occurrences',
        format: 'image/png',
        transparent: true,
        attribution: SHOW_CONF.mapAttribution,
        bgcolor: "0x000000",
        outline: "true",
        ENV: "color:5574a6;name:circle;size:4;opacity:1"
    });

    var speciesLayers = new L.LayerGroup();
    taxonLayer.addTo(speciesLayers);

    SHOW_CONF.map = L.map('leafletMap', {
        center: [SHOW_CONF.defaultDecimalLatitude, SHOW_CONF.defaultDecimalLongitude],
        zoom: SHOW_CONF.defaultZoomLevel,
        layers: [speciesLayers]
    });

    var mbUrl = 'https://{s}.tiles.mapbox.com/v4/{mapid}/{z}/{x}/{y}.png?access_token={token}';
    var mbAttr = 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
        '<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
        'Imagery © <a href="http://mapbox.com">Mapbox</a>';
    var defaultBaseLayer = L.tileLayer(mbUrl, {mapid: SHOW_CONF.mapboxId, token: SHOW_CONF.mapboxToken, attribution: mbAttr});

    defaultBaseLayer.addTo(SHOW_CONF.map);

    var baseLayers = {
        "Base layer": defaultBaseLayer
    };

    var sciName = SHOW_CONF.scientificName;

    var overlays = {};
    overlays[sciName] = taxonLayer;

    L.control.layers(baseLayers, overlays).addTo(SHOW_CONF.map);

    SHOW_CONF.map.on('click', onMapClick);
    SHOW_CONF.map.invalidateSize(false);
}

function onMapClick(e) {
    $.ajax({
        url: SHOW_CONF.biocacheServiceUrl + "/occurrences/info",
        jsonp: "callback",
        dataType: "jsonp",
        data: {
            q: SHOW_CONF.scientificName,
            zoom: "6",
            lat: e.latlng.lat,
            lon: e.latlng.lng,
            radius: 20,
            format: "json"
        },
        success: function (response) {
            var popup = L.popup()
                .setLatLng(e.latlng)
                .setContent("Occurrences at this point: " + response.count)
                .openOn(map);
        }
    });
}

function loadDataProviders(){

    var url = SHOW_CONF.biocacheServiceUrl  +
        '/occurrences/search.json?q=lsid:' +
        SHOW_CONF.guid +
        '&pageSize=0&flimit=-1' +
        '&facet=on&facets=data_resource_uid&callback=?';

    var uiUrl = SHOW_CONF.biocacheUrl  +
        '/occurrences/search?q=lsid:' +
        SHOW_CONF.guid;

    $.getJSON(url, function(data){

        if(data.totalRecords > 0) {
            $('.datasetCount').html(data.facetResults[0].fieldResult.length);
            $.each(data.facetResults[0].fieldResult, function (idx, facetValue) {
                if(facetValue.count > 0){
                    var queryUrl = uiUrl + "&fq=" + facetValue.fq;
                    $('#data-providers-list tbody').append("<tr><td><a href='" + queryUrl + "'><span class='data-provider-name'>" + facetValue.label + "</span></a></td><td><a href='" + queryUrl + "'><span class='record-count'>" + facetValue.count + "</span></a></td></tr>");

                }
            });
        }
    });
}

function loadExternalSources(){
    //load EOL content
    console.log('####### Loading EOL content - ' + SHOW_CONF.eolUrl);
    $.ajax({url: SHOW_CONF.eolUrl}).done(function ( data ) {
        console.log(data);
        //clone a description template...
        if(data.dataObjects){
            console.log('Loading EOL content - ' + data.dataObjects.length);
            $.each(data.dataObjects, function(idx, dataObject){
                if(dataObject.language == SHOW_CONF.eolLanguage){
                    var $description = $('#descriptionTemplate').clone();
                    $description.css({'display':'block'});
                    $description.attr('id', dataObject.id);
                    $description.find(".title").html(dataObject.title ?  dataObject.title : 'Description');
                    $description.find(".content").html(dataObject.description);

                    if(dataObject.source && dataObject.source.trim().length != 0){
                        $description.find(".sourceText").html(dataObject.source);
                    } else {
                        $description.find(".source").css({'display':'none'});
                    }
                    if(dataObject.rightsHolder && dataObject.rightsHolder.trim().length != 0){
                        $description.find(".rightsText").html(dataObject.rightsHolder);
                    } else {
                        $description.find(".rights").css({'display':'none'});
                    }

                    $description.find(".providedBy").attr('href', 'http://eol.org/pages/' + data.identifier);
                    $description.find(".providedBy").html("Encyclopedia of Life");
                    $description.appendTo('#descriptiveContent');
                }
            });
        }
    });

    //load Genbank content
    $.ajax({url: SHOW_CONF.genbankUrl}).done(function ( data ) {
        if(data.total){
            $('.genbankResultCount').html('<a href="' + data.resultsUrl + '">View all results - ' + data.total + '</a>');
            if(data.results){
                $.each(data.results, function(idx, result){
                    var $genbank =  $('#genbankTemplate').clone();
                    $genbank.removeClass('hide');
                    $genbank.find('.externalLink').attr('href', result.link);
                    $genbank.find('.externalLink').html(result.title);
                    $genbank.find('.description').html(result.description);
                    $genbank.find('.furtherDescription').html(result.furtherDescription);
                    $('.genbank-results').append($genbank);
                });
            }
        }
    });

    //load sound content
    $.ajax({url: SHOW_CONF.soundUrl}).done(function ( data ) {
        if(data.sounds){
            $('#sounds').append('<h3 style="clear:left;">Sounds</h3>');
            $('#sounds').append('<audio src="' + data.sounds[0].alternativeFormats['audio/mpeg'] + '" preload="auto" />' );
            audiojs.events.ready(function() {
                var as = audiojs.createAll();
            });
            var source = "";
            if(data.processed.attribution.collectionName){
                source = data.processed.attribution.collectionName
            } else {
                source = data.processed.attribution.dataResourceName
            }
            $('#sounds').append('<span>Source: ' + source + '</span><br/>' );
            $('#sounds').append('<span><a href="${biocacheUrl}/occurrence/'+ data.raw.uuid +'">View more details of this audio</a></span>' );
        }
    }).fail(function(jqXHR, textStatus, errorThrown) {
        //alert( "error" + errorThrown);
    });
}

/**
 * Trigger loading of the 3 gallery sections
 */
function loadGalleries() {
    console.log('loading galleries');
    $('#gallerySpinner').show();
    loadGalleryType('type', 0)
    loadGalleryType('specimen', 0)
    loadGalleryType('other', 0)
}

var entityMap = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': '&quot;',
    "'": '&#39;',
    "/": '&#x2F;'
};

function escapeHtml(string) {
    return String(string).replace(/[&<>"'\/]/g, function (s) {
        return entityMap[s];
    });
}

/**
 * Load overview images on the species page. This is separate from the main galleries.
 */
function loadOverviewImages(){

    var url = SHOW_CONF.biocacheServiceUrl  +
        '/occurrences/search.json?q=lsid:' +
        SHOW_CONF.guid +
        '&fq=multimedia:"Image"&im=true&facet=off&pageSize=5&start=0&callback=?';

    console.log('Loading images from: ' + url);

    $.getJSON(url, function(data){
        if (data && data.totalRecords > 0) {

            $('#noOverviewImages').addClass('hide');
            $('.thumb-row').removeClass('hide');
            var $categoryTmpl = $('#overviewImages');
            $categoryTmpl.removeClass('hide');

            var $mainOverviewImage = $('.mainOverviewImage');
            $mainOverviewImage.attr('src', data.occurrences[0].largeImageUrl);
            $mainOverviewImage.parent().attr('href', data.occurrences[0].largeImageUrl);
            $mainOverviewImage.parent().attr('data-title', getImageTitleFromOccurrence(data.occurrences[0]));
            $mainOverviewImage.parent().attr('data-footer', getImageFooterFromOccurrence(data.occurrences[0]));

            $('.mainOverviewImageInfo').html(getImageTitleFromOccurrence(data.occurrences[0]));

            if(data.occurrences.length >= 2){
                var $thumb = generateOverviewThumb(data.occurrences[1], "1");
                $('#overview-thumbs').append($thumb);
            }
            if(data.occurrences.length >= 3){
                var $thumb = generateOverviewThumb(data.occurrences[2], "2");
                $('#overview-thumbs').append($thumb);
            }
            if(data.occurrences.length >= 4){
                var $thumb = generateOverviewThumb(data.occurrences[3], "3");
                $('#overview-thumbs').append($thumb);
            }
            if(data.occurrences.length >= 5){
                var occurrence  = data.occurrences[4];
                $('#more-photo-thumb-link').attr('style', 'background-image:url(' + occurrence.smallImageUrl + ')');
            }
        }
    }).fail(function(jqxhr, textStatus, error) {
        alert('Error loading gallery: ' + textStatus + ', ' + error);
    }).always(function() {
        $('#gallerySpinner').hide();
    });
}

function generateOverviewThumb(occurrence, id){
    var $taxonSummaryThumb = $('#taxon-summary-thumb-template').clone();
    var $taxonSummaryThumbLink = $taxonSummaryThumb.find('a');
    $taxonSummaryThumb.removeClass('hide');
    $taxonSummaryThumb.attr('id', 'taxon-summary-thumb-'+id);
    $taxonSummaryThumb.attr('style', 'background-image:url(' + occurrence.smallImageUrl + ')');
    $taxonSummaryThumbLink.attr('data-title', getImageTitleFromOccurrence(occurrence));
    $taxonSummaryThumbLink.attr('data-footer', getImageFooterFromOccurrence(occurrence));
    $taxonSummaryThumbLink.attr('href', occurrence.largeImageUrl);
    return $taxonSummaryThumb;
}

/**
 * AJAX loading of gallery images from biocache-service
 *
 * @param category
 * @param start
 */
function loadGalleryType(category, start) {

    console.log("Loading images category: " + category);

    var imageCategoryParams = {
        type: '&fq=type_status:*',
        specimen: '&fq=basis_of_record:PreservedSpecimen&fq=-type_status:*',
        other: '&fq=-type_status:*&fq=-basis_of_record:PreservedSpecimen'
    };

    var pageSize = 20;

    if (start > 0) {
        $('.loadMore.' + category + ' button').addClass('disabled');
        $('.loadMore.' + category + ' img').removeClass('hide');
    }

    //TODO a toggle between LSID based searches and names searches
    var url = SHOW_CONF.biocacheServiceUrl  +
        '/occurrences/search.json?q=lsid:' +
        SHOW_CONF.guid +
        '&fq=multimedia:"Image"&pageSize=' + pageSize +
        '&facet=off&start=' + start + imageCategoryParams[category] + '&im=true&callback=?';

    console.log("URL: " + url);

    $.getJSON(url, function(data){

        console.log('Total images: ' + data.totalRecords + ", category: " + category);

        if (data && data.totalRecords > 0) {
            var br = "<br>";
            var $categoryTmpl = $('#cat_' + category);
            $categoryTmpl.removeClass('hide');
            $('#cat_nonavailable').addClass('hide');

            $.each(data.occurrences, function(i, el) {
                // clone template div & populate with metadata
                var $taxonThumb = $('#taxon-thumb-template').clone();
                $taxonThumb.removeClass('hide');
                $taxonThumb.attr('id','thumb_' + category + i);
                $taxonThumb.attr('href', el.largeImageUrl);
                $taxonThumb.find('img').attr('src', el.smallImageUrl);

                // brief metadata
                var briefHtml = getImageTitleFromOccurrence(el);
                $taxonThumb.find('.caption-brief').html(briefHtml);
                $taxonThumb.attr('data-title', briefHtml);
                $taxonThumb.find('.caption-detail').html(briefHtml);

                // write to DOM
                $taxonThumb.attr('data-footer', getImageFooterFromOccurrence(el));
                $categoryTmpl.find('.taxon-gallery').append($taxonThumb);
            });

            $('.loadMore.' + category).remove(); // remove 'load more images' button that was just clicked

            if (data.totalRecords > (start + pageSize)) {
                // add new 'load more images' button if required
                var spinnerLink = $('#gallerySpinner img').attr('src');
                var btn = '<div class="loadMore ' + category + '"><br><button class="btn" onCLick="loadGalleryType(\'' + category + '\','
                    + (start + pageSize)  + ');">Load more images <img src="' + spinnerLink + '" class="hide"/></button></div>';
                $categoryTmpl.find('.taxon-gallery').append(btn);
            }
        }
    }).fail(function(jqxhr, textStatus, error) {
        alert('Error loading gallery: ' + textStatus + ', ' + error);
    }).always(function() {
        $('#gallerySpinner').hide();
    });
}

function getImageTitleFromOccurrence(el){
    var br = "<br/>";
    var briefHtml = "";
    //include sci name when genus or higher taxon
    if(SHOW_CONF.taxonRankID  < 7000) {
        briefHtml += el.raw_scientificName;
    }

    if (el.typeStatus) {
        if(briefHtml.length > 0)  briefHtml += br;
        briefHtml += el.typeStatus;
    }

    if (el.institutionName) {
        if(briefHtml.length > 0)  briefHtml += br;
        briefHtml += ((el.typeStatus) ? ' | ' : br) + el.institutionName;
    }

    if(el.imageMetadata && el.imageMetadata.length > 0 && el.imageMetadata[0].creator != null){
        if(briefHtml.length > 0)  briefHtml += br;
        briefHtml += "Photographer: " + el.imageMetadata[0].creator;
    } else if(el.imageMetadata && el.imageMetadata.length > 0 && el.imageMetadata[0].rightsHolder != null) {
        if(briefHtml.length > 0)  briefHtml += br;
        briefHtml += "Rights holder: " + el.imageMetadata[0].rightsHolder;
    } else if(el.collector){
        if(briefHtml.length > 0)  briefHtml += br;
        briefHtml += "Supplied by: " + el.collector;
    }

    return briefHtml;
}

function getImageFooterFromOccurrence(el){
    var br = "<br/>";
    var detailHtml = el.raw_scientificName;
    if (el.typeStatus) detailHtml += br + 'Type: ' + el.typeStatus;
    if (el.collector) detailHtml += br + 'By: ' + el.collector;
    if (el.eventDate) detailHtml += br + 'Date: ' + moment(el.eventDate).format('YYYY-MM-DD');
    if (el.institutionName && el.institutionName !== undefined) {
        detailHtml += br + "Supplied by: " + el.institutionName;
    } else if (el.dataResourceName && el.dataResourceName !== undefined) {
        detailHtml += br + "Supplied by: " + el.dataResourceName;
    }
    if(el.imageMetadata && el.imageMetadata.length > 0 && el.imageMetadata[0].rightsHolder != null){
        detailHtml += br + "Rights holder: " + el.imageMetadata[0].rightsHolder;
    }

    // write to DOM
    detailHtml += '<div class="recordLink"><a href="' + SHOW_CONF.biocacheUrl + '/occurrences/' + el.uuid + '">View details of this record</a></div>';
    return detailHtml;
}

function loadBhl() {
    loadBhl(0, 10, false);
}

/**
 * BHL search to populate literature tab
 *
 * @param start
 * @param rows
 * @param scroll
 */
function loadBhl(start, rows, scroll) {
    if (!start) {
        start = 0;
    }
    if (!rows) {
        rows = 10;
    }
    // var url = "http://localhost:8080/bhl-ftindex-demo/search/ajaxSearch?q=" + $("#tbSearchTerm").val();
    var taxonName = SHOW_CONF.scientificName ;
    var synonyms = SHOW_CONF.synonymsQuery;
    var query = ""; // = taxonName.split(/\s+/).join(" AND ") + synonyms;
    if (taxonName) {
        var terms = taxonName.split(/\s+/).length;
        if (terms > 2) {
            query += taxonName.split(/\s+/).join(" AND ");
        } else if (terms == 2) {
            query += '"' + taxonName + '"';
        } else {
            query += taxonName;
        }
    }
    if (synonyms) {
        //synonyms = "  " + ((synonyms.indexOf("OR") != -1) ? "(" + synonyms + ")" : synonyms);
        query += (taxonName) ? ' OR ' + synonyms : synonyms;
    }

    if (!query) {
        return cancelSearch("No names were found to search BHL");
    }
    //var tail = "&wt=json&fl=name%2CpageId%2CitemId%2Cscore&hl=on&hl.fl=text&hl.fragsize=200&group=true&group.field=itemId&group.limit=7&group.ngroups=true&taxa=false";
    //var url = bhl.searchUrlStart + query + '&start=' + start + "&rows=" + rows + tail;
    //  console.log("BHL url: "+url);

        //bhl.searchUrlTail;

    var url = "http://bhlidx.ala.org.au/select?q=" + query + '&start=' + start + "&rows=" + rows +
        "&wt=json&fl=name%2CpageId%2CitemId%2Cscore&hl=on&hl.fl=text&hl.fragsize=200&" +
        "group=true&group.field=itemId&group.limit=7&group.ngroups=true&taxa=false";

    var buf = "";
    $("#status-box").css("display", "block");
    $("#synonyms").html("").css("display", "none")
    $("#bhl-results-list").html("");

    $.ajax({
        url: url,
        dataType: 'jsonp',
        jsonp: "json.wrf",
        success:  function(data) {
            var itemNumber = parseInt(data.responseHeader.params.start, 10) + 1;
            var maxItems = parseInt(data.grouped.itemId.ngroups, 10);
            if (maxItems == 0) {
                return cancelSearch("No references were found for <pre>" + query + "</pre>");
            }
            var startItem = parseInt(start, 10);
            var pageSize = parseInt(rows, 10);
            var showingFrom = startItem + 1;
            var showingTo = (startItem + pageSize <= maxItems) ? startItem + pageSize : maxItems ;
            buf += '<div class="results-summary">Showing ' + showingFrom + " to " + showingTo + " of " + maxItems +
                ' results for the query <pre>' + query + '</pre></div>'
            // grab highlight text and store in map/hash
            var highlights = {};
            $.each(data.highlighting, function(idx, hl) {
                highlights[idx] = hl.text[0];
            });
            //console.log("highlighting", highlights, itemNumber);
            $.each(data.grouped.itemId.groups, function(idx, obj) {
                buf += '<div class="result">';
                buf += '<h3><b>' + itemNumber++;
                buf += '.</b> <a target="item" href="http://biodiversitylibrary.org/item/' + obj.groupValue + '">' + obj.doclist.docs[0].name + '</a> ';
                var suffix = '';
                if (obj.doclist.numFound > 1) {
                    suffix = 's';
                }
                buf += '(' + obj.doclist.numFound + '</b> matching page' + suffix + ')</h3><div class="thumbnail-container">';

                $.each(obj.doclist.docs, function(idx, page) {
                    var highlightText = $('<div>'+highlights[page.pageId]+'</div>').htmlClean({allowedTags: ["em"]}).html();
                    buf += '<div class="page-thumbnail"><a target="page image" href="http://biodiversitylibrary.org/page/' +
                        page.pageId + '"><img src="http://biodiversitylibrary.org/pagethumb/' + page.pageId +
                        '" alt="' + escapeHtml(highlightText) + '"  width="60px" height="100px"/></a></div>';
                })
                buf += "</div><!--end .thumbnail-container -->";
                buf += "</div>";
            })

            var prevStart = start - rows;
            var nextStart = start + rows;

            buf += '<div id="button-bar">';
            if (prevStart >= 0) {
                buf += '<input type="button" class="btn" value="Previous page" onclick="loadBhl(' + prevStart + ',' + rows + ', true)">';
            }
            buf += '&nbsp;&nbsp;&nbsp;';
            if (nextStart <= maxItems) {
                buf += '<input type="button" class="btn" value="Next page" onclick="loadBhl(' + nextStart + ',' + rows + ', true)">';
            }

            buf += '</div>';

            $("#bhl-results-list").html(buf);
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
        error: function(jqXHR, textStatus, errorThrown) {
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

function loadExpertDistroMap() {
    var url = "http://spatial.ala.org.au/layers-service/distribution/map/" + SHOW_CONF.guid + "?callback=?";
    $.getJSON(url, function(data){
        if (data.available) {
            $("#expertDistroDiv img").attr("src", data.url);
            if (data.dataResourceName && data.dataResourceUrl) {
                var attr = $('<a>').attr('href', data.dataResourceUrl).text(data.dataResourceName)
                $("#expertDistroDiv #dataResource").html(attr);
            }
            $("#expertDistroDiv").show();
        }
    })
}