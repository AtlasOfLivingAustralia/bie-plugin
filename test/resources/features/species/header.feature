Feature: Species - 4. Header

  Scenario: 1. Breadcrumb trail
    Given  a successful species search and a species
    When  the species results page is displayed
    Then  a breadcrumb trail consisting of a links to Home, Australian Species and specific species name will be displayed

Scenario: 2. Species Scientific Name
    Given  a successful species search and a species
    When  the species results page is displayed
    Then  the scientific name will be displayed

Scenario: 3. Species Common Name
    Given  a successful species search and a species
    When  the species results page is displayed
    Then  the common name will be displayed

Scenario: 4. Record a sighting
    Given  a successful species search and a species
    When  the species results page is displayed
    Then  a facility to access 'record a sighting' will be available

Scenario: 5. Request Email Alert
    Given  a successful species search and a species
    When  the species results page is displayed
    Then  a breadcrumb trail consisting of a links to Home, Australian Species and specific species name will be displayed




