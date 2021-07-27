<section class="tab-pane fade" id="literature">
    <div class="row">
        <!--left-->
        <div class="col-md-3 sidebarCol">
            <div class="side-menu" id="sidebar">
                <nav class="navbar navbar-default" role="navigation">
                    <ul class="nav nav-stacked">
                        <li><a href="#bhl-integration">Biodiversity Heritage Library</a></li>
                        <li><a href="#trove-integration">Trove</a></li>
                    </ul>
                </nav>
            </div>
        </div><!--/left-->

    <!--right-->
        <div class="col-md-9" style="padding-top:14px;">

            <div id="bhl-integration">
                <h3>${message(code: 'literature.title.references')} <a href="${grailsApplication.config.literature.bhl.url}/search?SearchTerm=%22${synonyms?.join('%22+OR+%22')}%22&SearchCat=M#/names" target="_blank">Biodiversity Heritage Library</a></h3>
                <div id="bhl-results-list" class="result-list">
                    <!-- Search results go here -->
                </div>
            </div>
            <div id="trove-integration" class="column-wrap" style="padding-top:50px;">
                %{--<h2>&nbsp;</h2>--}%
                <hr />
                <h3>${message(code: 'literature.title.references')} <a href="${grailsApplication.config.literature.trove.url}/result?q=%22${synonyms?.join('%22+OR+%22')}%22" target="_blank">Trove - NLA</a></h3>

                <div id="trove-result-list" class="result-list">

                </div>
            </div>
        </div><!--/right-->
    </div><!--/row-->
</section>
