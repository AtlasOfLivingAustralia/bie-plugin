Feature: Species - 1. Authorisation Required

  Scenario: 1. Email Alert
    Given  a successful species search and a species
    When   the user requests an Alert and they are not logged in
    Then  they are redirect to ALA authenication page before being taken to the Profile Alert page

  Scenario: 2. Completion of Alert Page after passing through the login screen
    Given  The user has finished with the Profile Alert page
    When   any they finalise their request
    Then  returned to the page they came from

 Scenario: 3. Record a sighting
    Given  a successful species search and a species
    When   click record a sighting  and they are not logged in
    Then  they are redirect to ALA authenication page before being taken to Report a sighting





