Feature: Species - 6. Names And sources

  Scenario: 1. Accepted Name
    Given  name sources are available
    When  names is displayed
    Then  An accepted name is displayed in a separate section along with a link to the source

Scenario: 2. Synonyms
    Given  name sources are available
    When  names is displayed
    Then  A list of known synonyms are displayed along with links to their sources


  Scenario: 3. Common Names
    Given  name sources are available
    When  names is displayed
    Then  A common name is displayed along with 1 or more sources (linked)




