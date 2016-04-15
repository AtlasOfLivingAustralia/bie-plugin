Feature: Species - 1. Footer

  Scenario: 1. Atlas description
    Given ALA description paragraphs
    When  any page is displayed
    Then  ALA description paragraphs are displayed

 Scenario: 2. National Research Infrastructure for Australia (NCRIS) attribution
    Given NCRIS logo
    When  any page is displayed
    Then  NCRIS attribtution and logo is displayed

 Scenario: 3. Global Biodiversity Information Facility (GBIF) attribution
    Given GBIF logo
    When  any page is displayed
    Then  The GBIF logo and attribution will be displayed and link through to GBIF site

 Scenario: 4. Copyright Licence
    Given Licence details
    When  any page is displayed
    Then  Licence logo and attribution will be displayed along with links to license details and terms of use

 Scenario: 5. Citizen Science Links
    Given Links to relevant pages
    When  any page is displayed
    Then  The following links will be provided; Citizen Science, Digivol, Record a sighting (authorisation required) and Upload media

 Scenario: 6. Atlas Feature links
    Given Links to relevant pages
    When  any page is displayed
    Then  The following links will be provided; About Atlas, Dashboard for stats, data upload Sandbox, web service API descriptor, ALA Mobile app page

 Scenario: 7. Atlas Data links
    Given Links to relevant pages
    When  any page is displayed
    Then  The following links will be provided; Biocache search box, about Sensitive data page, how we integrate data page, Uploading data set resource page, Species list page

  Scenario: 8. Contact Us links
    Given Links to relevant pages
    When  any page is displayed
    Then  The following links will be provided;  Contact us page, Communications information page, About Atlas page, Education resources page, FAQ page

 Scenario: 9. Social Media links
    Given Links to relevant pages
    When  any page is displayed
    Then  Icon links to facebook, twitter and email will be available

Scenario: 10. Other links
    Given Links to relevant pages
    When  any page is displayed
    Then  Links for Contact Us, Get Involved and System status will appear




