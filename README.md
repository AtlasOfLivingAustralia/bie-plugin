# bie-plugin  [![Build Status](https://travis-ci.org/AtlasOfLivingAustralia/bie-plugin.svg?branch=master)](https://travis-ci.org/AtlasOfLivingAustralia/bie-plugin)

**bie-plugin** is a Grails plugin that provides the core functionality for the _Atlas of Living Australia_ (ALA) [BIE search and taxon pages application](http://bie.ala.org.au/search) front-end. It should be used by a client Grails application, e.g. [ala-bie](https://github.com/AtlasOfLivingAustralia/ala-bie).

This application/plugin provides a web UI for the associated back-end service  [**bie-index**](https://github.com/AtlasOfLivingAustralia/bie-index) (see [bbie-service API](http://bie.ala.org.au/ws)) - a full-text search and document retreival for taxon profile pages and general web content (Wordpress pages, data resources, etc.), using JSON data format.

### Getting started

[Download Grails](https://grails.org/download.html) version 3.2.11 or later. Fork and then checkout both this repository and [ala-bie](https://github.com/AtlasOfLivingAustralia/ala-bie) into the same directory. 

To run and be able to make changes to the plugin "in place", edit these files in `ala-bie`:
* `build.gradle`
* `settings.gradle`

and change the following variable `inplace = true` in both files and save. Run the app with `grails run-app` and any changes made in `bie-plugin` will be reflected in the running web application. 

Customisations of code and i18n files should be made in the copy of `ala-bie` (note: and file in the `bie-plugin` can be copied and pasted into `ala-bie` and this will override the plugin version). Bug fixes and enhancement for `bie-plugin` should be provided via a pull request.

### Languages

The bie-plugin uses ISO-639 language codes, particularly ISO-639-3, drawn from http://www.sil.org/iso639-3/ and the AIATSIS codes, drawn from https://aiatsis.gov.au/


### Common Names Pull

It is possible to "pull" common names with special status into their own section and have them displayed in a special way.
To do this, use the following configuration settings:

* `vernacularName.pull.active` Set to true for a pull display (*false* by default)
* `vernacularName.pull.categories` A comma-separated list of status values that will cause the names to be pulled (*empty* by default)
* `vernacularName.pull.label` The label for the pull section in the names tab (*Special Common Names* by default)
* `vernacularName.pull.labelDetail` The detail to put into the label title
* `vernacularName.pull.showHeader` List these names in the header, just below the preferred common name (*false* by default)
* `vernacularName.pull.showLanguage` Show the language of the common name (*false* by default)

### Change log
See the [releases page](https://github.com/AtlasOfLivingAustralia/bie-plugin/releases) for this repository.

