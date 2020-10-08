<section class="tab-pane fade" id="gallery">
    <g:each in="${["type","specimen","other","uncertain"]}" var="cat">
        <div id="cat_${cat}" class="hide image-section">
            <h2><g:message code="images.heading.${cat}" default="${cat}"/>&nbsp;
                <div class="btn-group btn-group-sm" role="group">
                    <button type="button" class="btn btn-sm btn-default collapse-image-gallery" onclick="collapseImageGallery(this)"><g:message code="gallery.button.collapse"/></button>
                    <button type="button" class="btn btn-sm btn-default btn-primary expand-image-gallery" onclick="expandImageGallery(this)"><g:message code="gallery.button.expand"/></button>
                </div>
            </h2>

            <div class="taxon-gallery"></div>
        </div>

    </g:each>

    <div id="cat_nonavailable">
        <h2><g:message code="gallery.title"/></h2>


        <p>
            <g:message code="gallery.description.01"/>
            ${raw(grailsApplication.config.skin.orgNameLong)},
            <g:message code="gallery.description.02"/>
        </p>
    </div>
    <img src="${resource(dir: 'images', file: 'spinner.gif', plugin: 'biePlugin')}" id="gallerySpinner" class="hide" alt="spinner icon"/>
</section>
