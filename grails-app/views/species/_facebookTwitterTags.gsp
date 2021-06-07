<g:set var="description" value="${raw(grailsApplication.config.skin.orgNameLong)} species page for the ${scientificName}"/>

<meta property="og:url" content="${grailsApplication.config.bie.baseURL}/species/${tc?.taxonConcept?.guid}"/>
<meta property="og:type" content="website"/>
<meta property="og:title" content="${taxonRank}: ${scientificName}${commonNameDisplay ? ' (' + commonNameDisplay +')' : ''}"/>
<meta property="og:description" content="${description}"/>

<meta name="twitter:card" content="summary_large_image"/>
<meta name="twitter:description" content="${description}"/>

<g:if test="${grailsApplication.config.facebook.app_id}">
    <meta property="fb:app_id" content="${grailsApplication.config.facebook.app_id}"/>
</g:if>

<g:if test="${tc.imageIdentifier}">
    <g:set var="image" value="${grailsApplication.config.image.thumbnailUrl}${tc.imageIdentifier}"/>
    <meta name="twitter:image" content="${image}"/>
    <meta name="twitter:image:alt" content="Photograph of ${scientificName}"/>

    <meta property="og:image" content="${image}"/>
    <meta property="og:image:type" content="image/jpeg"/>
    <meta property="og:image:width" content="300"/>
    <meta property="og:image:height" content="225"/>
</g:if>
<g:else>
    <g:if test="${logoFile}">
        <g:set var="image" value="${resource(dir: 'images', file: logoFile)}"/>
        <meta name="twitter:image" content="${image}"/>
        <meta name="twitter:image:alt" content="logo"/>

        <meta property="og:image" content="${image}"/>
        <meta property="og:image:type" content="image/png"/>
        <meta property="og:image:width" content="300"/>
        <meta property="og:image:height" content="271"/>
    </g:if>
    <g:else>
        <g:set var="image" value="${resource(dir: 'images', file: 'noImage.jpg')}"/>
        <meta name="twitter:image" content="${image}"/>
        <meta name="twitter:image:alt" content="no image"/>

        <meta property="og:image" content="${image}"/>
        <meta property="og:image:type" content="image/jpeg"/>
        <meta property="og:image:width" content="300"/>
        <meta property="og:image:height" content="300"/>
    </g:else>
</g:else>
