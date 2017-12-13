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
        <h2>No images available for this taxon</h2>

        <p>
            If you have images for this taxon that you would like to share
            with ${raw(grailsApplication.config.skin.orgNameLong)},
            please upload using the upload tools.
        </p>
    </div>
    <img src="${resource(dir: 'images', file: 'spinner.gif', plugin: 'biePlugin')}" id="gallerySpinner" class="hide" alt="spinner icon"/>
</section>
