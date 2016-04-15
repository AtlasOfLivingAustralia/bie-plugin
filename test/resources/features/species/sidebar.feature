Feature: Species - 10. Sidebar

  Scenario: 1. Name Source
    Given  name sources are available
    When  the species results page is displayed
    Then  name source and urls will be displayed

 Scenario: 2. Rank
    Given  rank id is available
    When  the species results page is displayed
    Then  rank name will be displayed

 Scenario: 3. Data links
    Given  data links are available
    When  the species results page is displayed
    Then  data links will be displayed and will link to data in the matching format

 Scenario: 4. Species Presence
    Given species presence data
    When  the species results page is displayed
    Then  species presence icons and labels will be displayed such as 'Recorded in Australia', 'Terrestial Habitats'...

 Scenario: 5. Conservation Status
    Given   converstation status data
    When  the species results page is displayed
    Then  convservation status icon(s) and label(s) will be displayed, e.g. 'Least Concern' and linked through to the Conservation Status page




