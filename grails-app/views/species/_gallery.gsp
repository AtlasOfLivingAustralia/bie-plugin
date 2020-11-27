<section class="tab-pane fade" id="gallery">
    <g:each in="${["type","specimen","other","uncertain"]}" var="cat">
        <div id="cat_${cat}" class="hide image-section">
            <h2><g:message code="images.heading.${cat}" default="${cat}"/>&nbsp;
                <div class="btn-group btn-group-sm" role="group">
                    <button type="button" class="btn btn-sm btn-default collapse-image-gallery" onclick="collapseImageGallery(this)">Collapse</button>
                    <button type="button" class="btn btn-sm btn-default btn-primary expand-image-gallery" onclick="expandImageGallery(this)">Expand</button>
                </div>
            </h2>

            <div class="taxon-gallery"></div>
        </div>

    </g:each>

    <div id="cat_nonavailable">
        <h2>${message(code: 'gallery.noimages')}</h2>

        <p>
            ${message(code: 'gallery.noimages.descr01')} ${raw(grailsApplication.config.skin.orgNameLong)},
            ${message(code: 'gallery.noimages.descr02')}
        </p>
    </div>
    <img src="${resource(dir: 'images', file: 'spinner.gif', plugin: 'biePlugin')}" id="gallerySpinner" class="hide" alt="spinner icon"/>
</section>
