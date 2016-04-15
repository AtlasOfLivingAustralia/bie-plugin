Feature: Species - 3. Gallery

  Scenario: 1. Type Images
    Given  type images
    When  the gallery tab is displayed
    Then  type images from images.ala.org.au will be displayed as large thumb nails with attribution to original provider

 Scenario: 2. Speciman Images
    Given  speciman images
    When  the gallery tab is displayed
    Then  speciman images from images.ala.org.au will be displayed as large thumb nails with attribution to original provider

 Scenario: 3. Load More Images (specimen)
    Given  more specimen images
    When  the load more images button is clicked
    Then  more specimen images are displayed

 Scenario: 4. Images
    Given  type images
    When  the gallery tab is displayed
    Then  type images from images.ala.org.au will be displayed as large thumb nails with attribution to original provider

  Scenario: 5. Load More Images (general)
    Given  more general images
    When  the load more images button is clicked
    Then  more general images are displayed

  Scenario: 6. View an Image
    Given  images
    When  the gallery tab is displayed
    Then  images from images.ala.org.au will be displayed as large thumb nails with attribution to original provider

 Scenario: 7. Show Image Details
    Given  images
    When  image is clicked
    Then  the image is displayed in an image viewer

Scenario: 8. Videos
    Given videos
    When   the gallery tab is displayed
  Then  a list of video thumbnails and details will be displayed

Scenario: 9. Video Details
    Given  a video
    When  the gallery tab is displayed
    Then  The following details will appear beside the thumbnail; 'Video by', 'Licence', 'Rights:', 'Source' with the latter linked through to the host site

Scenario: 10. View video
    Given  a video
    When  the video thumbnail is clicked
    Then  the user is taken to the video on the source site






