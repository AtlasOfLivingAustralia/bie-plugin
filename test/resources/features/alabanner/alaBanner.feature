Feature: Species - 1. Organisation Banner

  Scenario: 1. Organisation Logo
    Given  Organisation Logo
    When   any page is displayed
    Then  the Organisation logo appears next to the Organisation name

  Scenario: 2. Organisation Name
    Given  The Organisation banner
    When   any page is displayed
    Then  the Organisation name and home page link appears next to the Organisation Logo

  Scenario: 3. Organisation Apps
    Given  Organisation banner
    When   any page is displayed
    Then   display a drop down menu with links to each of - Spatial portal, Occurance search, Fish Map, Regions, Explore Your Area;
    Record a sighting, Collections, Biocollect, DigiVol, MERIT, Soils To Satellite, Traits,species list, Phylolink;
    Community Portals, Dashboard, Datasets browser

  Scenario: 4. Organisation Info
    Given  Organisation banner
    When   any page is displayed
    Then  display a drop down menu with links to each of - About the Atlas, Get Involved, Education Resources, Contact Us

  Scenario: 5. Search Box
    Given  Organisation banner
    When   any page is displayed
    Then  display the Atlas search box followed by search button labelled 'Search'

  Scenario: 6. User Settings
    Given  Organisation banner
    When   any page is displayed
    Then  on the far right hand side display a drop down menu with links to each of - My profile, Log In, Register




