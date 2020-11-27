<section class="tab-pane fade" id="records">

    <div class="pull-right btn-group btn-group-vertical">
        <a class="btn btn-default"
           href="${biocacheUrl}/occurrences/search?q=lsid:${tc?.taxonConcept?.guid ?: ''}">
            <i class="glyphicon glyphicon-th-list"></i>
            ${message(code: 'charts.button.viewlist01')}<span class="occurrenceRecordCount">0</span> ${message(code: 'charts.button.viewlist02')}
        </a>
        <a class="btn btn-default"
           href="${biocacheUrl}/occurrences/search?q=lsid:${tc?.taxonConcept?.guid ?: ''}#tab_mapView">
            <i class="glyphicon glyphicon-map-marker"></i>
            ${message(code: 'charts.button.viewMap01')}<span class="occurrenceRecordCount">0</span> ${message(code: 'charts.button.viewMap02')}
        </a>
    </div>

    <div id="occurrenceRecords">
        <div id="recordBreakdowns" style="display: block;">
            <h2>${message(code: 'charts.title.breakdown01')}<span class="occurrenceRecordCount">0</span> ${message(code: 'charts.title.breakdown02')}</h2>
            %{--<div id="chartsHint">Hint: click on chart elements to view that subset of records</div>--}%
            <div id="charts"></div>
        </div>
    </div>
</section>
