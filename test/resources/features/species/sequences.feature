Feature: Species -  9. Sequences

  Scenario: 1. Display Genbank results
    Given  gene information is available
    When  the Sequences panel is displayed
    Then  the first 20 records will be displayed

 Scenario: 2. Display number of items
    Given  gene information is available
    When  the Sequences panel is displayed
    Then  a label 'view all results - Items: 1 to 20 of x' will be visible where x is the total number of records in the source system

 Scenario: 3. Link to the data
    Given  gene information is available
    When  the view all results label is clicked
    Then the user will be taken to the data in the source sysemt

  Scenario: 4. Record details
    Given  gene information
    When  the Sequences panel is displayed
    Then the record information displayed will be the 3 line summary from the source system

Scenario: 5. Record details link
    Given  gene information
    When  the record link is clicked
    Then the full record information will be displayed in the source system


 (http://www.ncbi.nlm.nih.gov/nuccore/?term=%22Cracticus+tibicen%22)

