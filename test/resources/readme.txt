These are Cucumber files.

There were written initially by observation of an existing system. This means that some implementation details may have crept in unintentionally.

They align strongly with the Agile practice known as Behaviour driven development (BDD) and can also support Acceptance-based Test Driven Development (ATDD) - both of which endeavour to align code strongly with business expectations.

They can be used as documentation, and/or the basis for automated testing. Because they are written in English text, they can be read and understood by everyone and they can be stored and accessed in a number of ways - as part of the code base, copied into a Word document or into a Wiki for example.

They lend themselves to manual conversion to Spock unit and integration tests, or Geb functional tests.

They are the specification half of a Cucumber test suite. The other half being the (unwritten Cucumber tests).  https://cucumber.io/docs/reference/jvm

If you are going to use them as the basis for testing they need to in the test/resources folder.

One of the advantages of further developing them along the testing path is that they will then be kept up to date - in the case of Cucumber acceptance tests, if the doco falls out of date the tests will fail.

The Serenity open source product has some good documentation about further uses
  (http://thucydides.info/docs/articles/an-introduction-to-serenity-bdd-with-cucumber.html)
  (http://www.thucydides.info/#/).

Serenity is an Australian product.

"Serenity BDD helps you write better, more effective automated acceptance tests, and use these acceptance tests to produce world-class test reports and living documentation."

Intellij IDEA ships with 2 plugins that allow the IDE to understand Cucumber files written in Groovy or Java. To add a new Cucumber file Choose File -> New file and give it a .feature extension when naming it. NB The file structure is very important for self-documentation purposes; i.e. it goes features/FEATURE GROUPING NAME/feature files.
For example the 'species' directory contains all the stories that relate to this feature, they all appear grouped on the one screen in the original application. The parts of the application which represent generic features such as items that appear on all pages like the banner and footer or can be used in multiple locations/applications, like the imageviewer have their own separate 'feature' directory.


Notes on Names:

Cucumber talks about 'Features' and 'Scenarios'. In Agile terms I equate these as follows: A feature directory is a feature, a feature file is an Epic (or story if it has only one scenario or a small number of tightly related scenarios), a scenario is a combined story/scenario - i.e. a story with an example and acceptance criteria.

