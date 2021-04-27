<section class="tab-pane fade" id="literature">
    <div class="row">
        <!--left-->
        <div class="col-md-3 sidebarCol">
            <div class="side-menu" id="sidebar">
                <nav class="navbar navbar-default" role="navigation">
                    <ul class="nav nav-stacked">
                        <li><a href="#bhl-integration"><g:message code="bhl.title.bhl"/></a></li>
                        <li><a href="#trove-integration"><g:message code="bhl.title.trove"/></a></li>
                    </ul>
                </nav>
            </div>
        </div><!--/left-->

    <!--right-->
        <div class="col-md-9" style="padding-top:14px;">

            <div id="bhl-integration">
                <%-- Scientific name search --%>
                <h3><g:message code="bhl.reference.found.bhl"/> <a href="${grailsApplication.config.literature.bhl.url}/search?SearchTerm=%22${synonyms?.join('%22+OR+%22')}%22&SearchCat=M#/names" target="_blank"><g:message code="bhl.title.bhl"/></a></h3>
                <div id="bhl-results-list" class="result-list">
                    <!-- Search results go here -->
                </div>
            </div>

            <div id="trove-integration" class="column-wrap" style="padding-top:50px;">
                %{--<h2>&nbsp;</h2>--}%
                <hr />
                <h3><g:message code="bhl.reference.found.trove"/> <a href="${grailsApplication.config.literature.trove.url}/result?q=%22${synonyms?.join('%22+OR+%22')}%22" target="_trove"><g:message code="bhl.title.trove"/></a></h3>

                <div id="trove-result-list" class="result-list">
                    <!-- Search results go here -->
                </div>
            </div>
        </div><!--/right-->
    </div><!--/row-->
</section>
