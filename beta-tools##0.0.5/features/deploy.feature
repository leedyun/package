Feature: Deployment
  In order to easily deploy artifacts to their servers
  As the jenkins build server
  I want to be able to deploy all artifacts that I build
  
  Scenario: Deploy assembly artifact
    Given I have built the assembly jar
    When I press execute deploy
    Then the artifact should get deployed
