<section class="tab-pane fade" id="records">

    <div class="pull-right btn-group btn-group-vertical">
        <a class="btn btn-default"
           href="${biocacheUrl}/occurrences/search?q=lsid:${tc?.taxonConcept?.guid ?: ''}">
            <i class="glyphicon glyphicon-th-list"></i>
            <g:message code="records.list.all.records.button"/>
            (<span class="occurrenceRecordCount">0</span> <g:message code="records"/>)
        </a>
        <a class="btn btn-default"
           href="${biocacheUrl}/occurrences/search?q=lsid:${tc?.taxonConcept?.guid ?: ''}#tab_mapView">
            <i class="glyphicon glyphicon-map-marker"></i>
            <g:message code="records.list.all.map.button"/>
            (<span class="occurrenceRecordCount">0</span> <g:message code="records"/>)
        </a>
    </div>

    <div id="occurrenceRecords">
        <div id="recordBreakdowns" style="display: block;">
            <h2>
                <g:message code="records.title"/>
                (<span class="occurrenceRecordCount">0</span> <g:message code="records"/>)
            </h2>
            %{--<div id="chartsHint">Hint: click on chart elements to view that subset of records</div>--}%
            <div id="charts"></div>
        </div>
    </div>
</section>
