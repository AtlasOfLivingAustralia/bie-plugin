Feature: Species - 8. Records

  Scenario: 1. Occurrence Records
    Given  occurrence records
    When  the Records tab is displayed
    Then  provide a link to the relevant records search results page in biocache

 Scenario: 2. Charts
    Given  occurrence records and charts
    When  the Records tab is displayed
    Then  display a by collection pie chart,by month and decade bar charts and hints on how to interact with charts

 Scenario: 3. Chart links
    Given  occurrence  charts
    When  a chart is clicked
    Then  take the user to Occurence records in Biocache

 Scenario: 4. No Charts (new scenario)
    Given  occurrence records and no charts
    When  the Records tab is displayed
    Then  display an appropriate message instead

 Scenario: 5. Record maps from other sources
    Given  occurrence map from third party
    When  the Records tab is displayed
    Then  display a thumnail of this map,provide a link it and record the 'Source:' with a link to their home page.




