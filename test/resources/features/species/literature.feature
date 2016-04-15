Feature: Species -  5. Literature

  Scenario: 1. Name references found in the Biodiversity Heritage Library
    Given  name references are available
    When  the Literature panel is displayed
    Then  a formatted numbered list of the top 10 references will be displayed with an appropriate heading, count label and summary

 Scenario: 2. Biodiversity Heritage Library reference count
    Given  biodiversity heritage library name references
    When  the Literature panel is displayed
    Then  a label 'Showing 1 to 10 of x results for the query' will be displayed where x
   is the total number of results

 Scenario: 3. Biodiversity Heritage Library reference display details
    Given  a biodiversity heritage library name reference
    When  the Literature panel is displayed
    Then  The reference will appear in a formatted panel containing the source name as a link, linked thumbnails of each of the digital pages found and a count of the number of matching pages

 Scenario: 4. Biodiversity Heritage Library reference source name link
    Given  a biodiversity heritage library name reference
    When  the source name is clicked
    Then  the user will be taken to the source website

 Scenario: 5. Biodiversity Heritage Library reference page thumbnail link
    Given  a biodiversity heritage library name reference
    When  the a digital page thumbnail is clicked
    Then  the user will be taken to the source document page

 Scenario: 6. Biodiversity Heritage Library reference navigation
    Given  name references are available
    When  the Literature panel is displayed
    Then  contextual navigation will be available to navigate through the results

Scenario: 7. Biodiversity Heritage Library reference pagination
    Given  more than 10 name references are available
    When  the navigation controls are used
    Then  the appropriate reference records are displayed, numbered correctly and count label and navigation controls are updated

Scenario: 8. Biodiversity Heritage Library reference summary
    Given  name references are available
    When  the Literature panel is displayed
    Then  A summary of names will appear permanently above the list

Scenario: 9. Trove name references
    Given  Trove name references
    When  the Literature panel is displayed
    Then  a formatted numbered list of the top 10 references will be displayed with an appropriate heading, and count label

Scenario: 10. Trove name reference count
    Given  Trove name references
    When  the Literature panel is displayed
    Then  a label 'Number of matches in TROVE:' with the total number of references will be displayed

  Scenario: 11. Trove name reference display details
    Given  a Trove name reference
    When  the Literature panel is displayed
    Then  The reference will appear in a formatted panel containing the Trove record as a link, together with details about the Trove 'Contributors:'and the 'Date issued:'

  Scenario: 12. Trove record name link
    Given  a Trove name reference
    When  the record name is clicked
    Then  the user will be taken to the record in Trove

  Scenario: 13. Trove Name reference navigation
    Given  more than 10 name references are available
    When  the Literature panel is displayed
    Then  contextual navigation will be available to navigate through the results

  Scenario: 14. Trove Name reference pagination (enhancement)
    Given  more than 10 name references are available
    When  the navigation controls are used
    Then  the appropriate reference records are displayed, numbered correctly and count label and navigation controls are updated







