<meta property="og:url" content="${grailsApplication.config.bie.baseURL}/species/${tc?.taxonConcept?.guid}">
<meta property="og:type" content="website">
<meta property="og:title" content="${tc?.taxonConcept?.nameString} ${(tc?.commonNames) ? ' : ' + tc?.commonNames?.get(0)?.nameString : ''}">
<meta property="og:description" content="${raw(grailsApplication.config.skin.orgNameLong)}">
<g:if test="${grailsApplication.config.facebook.app_id}">
    <meta property="fb:app_id" content="${grailsApplication.config.facebook.app_id}">
</g:if>

<g:if test="${tc.imageIdentifier}">
    <meta property="og:image" content="${grailsApplication.config.image.thumbnailUrl}${tc.imageIdentifier}">
    <meta property="og:image:type" content="image/jpeg">
    <meta property="og:image:width" content="300">
    <meta property="og:image:height" content="225">
</g:if>
<g:else>
    <g:if test="${logoFile}">
        <meta property="og:image" content="${resource(dir: 'images', file: logoFile)}">
        <meta property="og:image:type" content="image/png">
        <meta property="og:image:width" content="300">
        <meta property="og:image:height" content="271">
    </g:if>
    <g:else>
        <meta property="og:image" content="${resource(dir: 'images', file: 'noImage.jpg')}">
        <meta property="og:image:type" content="image/jpeg">
        <meta property="og:image:width" content="300">
        <meta property="og:image:height" content="300">
    </g:else>
</g:else>
