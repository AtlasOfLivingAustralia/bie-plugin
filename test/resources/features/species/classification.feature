Feature: Species - 2. Classification

  Scenario: 1. Working classification
    Given  taxonomy for species
    When  Classification tab is displayed
    Then  the taxonomicaly heirarchy is displayed in indented format from kingdom to subspecies linked to the internal classification data at each level

  Scenario: 2. Species
    Given  taxonomy for species
    When  Classification tab is displayed
    Then  highlight the display of the species entry within taxonomy and mark it with any species presence icons

  Scenario: 3. Subspecies
    Given  taxonomy for species
    When  Classification tab is displayed
    Then  mark each entry with any species presence icons






