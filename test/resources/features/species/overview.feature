Feature: Species - 7. Overview

  Scenario: 1. Compiled Distribution Map
    Given  distribution map is available
    When  the overview is displayed
    Then  the map for this species will be displayed together with a 'Compiled distribution map provided by '
    acknowledgement displaying the name of the provider and linking to their website

  Scenario: 2. Primary Image
    Given  primary image
    When  the overview is displayed
    Then  image will be displayed along with 'Source:' and 'Image by:' attributions

  Scenario: 3. Occurrence records map
    Given  Occurrence data
    When  the overview is displayed
    Then  access to 'View records list' and 'Map & analyse records' will be avialable

  Scenario: 4. Sounds
    Given  sound data
    When  the overview is displayed
    Then  a Sounds heading and audio player control is displayed with 'Source:' label and link to more details

  Scenario: 5. Play Audio
    Given  sound data
    When  the audio control is started
    Then  the audio is played and audio control updated

  Scenario: 6. Audio details
    Given  sound data
    When  the View more details of this audio
    Then  the user is taken to the audio record in biocache

  Scenario: 7. View Records List
    Given  occurrence data
    When  the View Records List button is clicked
    Then  the user will be taken to the correct occurrences search results page in Biocache

  Scenario: 8. Map & analyse records
    Given  spatial occurrence data
    When  the Map & analyse button is clicked
    Then  The correct map view in spatial portal will be displayed

  Scenario: 9. Description
    Given  third party descriptions
    When  the overview is displayed
    Then  textual information from third party authorities such as Wikipedia or Oz Animals will be displayed, acknowledged and linked back to.

  Scenario: 10. Online Resources
    Given  Online resource links
    When  the overview is displayed
    Then  a list of online resources with links will be displayed

  Scenario: 11. Species List
    Given  species list data from lists.ala.org.au
    When  the overview is displayed
    Then  a list of relevant lists will be displayed and linked to




