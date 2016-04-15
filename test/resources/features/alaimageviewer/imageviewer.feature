Feature: Species - 1. ImageViewer

  Scenario: 1. Display Image
    Given  an image
    When  the viewer is loaded
    Then  then a larger version of the image is displayed

 Scenario: 2. Navigation
    Given   images
    When  the image or navigation arrows are clicked
    Then  a new image is displayed relative to the action taken and the image count is updated

 Scenario: 3. Navigation Controls
    Given  images
    When  the viewer is loaded
    Then  navigation controls are present and the label is dynamic and shows the # of the image and the total number of images i.e. # of #

 Scenario: 4. Detail summary
    Given  an image
    When  the view is loaded
    Then  information about the image is displayed including the name of the image, 'By:' 'Date:' and owning organisation.

  Scenario: 5. View details
    Given  an image
    When   a view details of this record link is clicked
    Then  details about the image from biocache are displayed

 Scenario: 6. Close
    Given  an image
    When  the close viewer control is clicked
    Then  the image is closed and the view returns to the original page






