Feature: Maven
  In order to deploy maven artifacts
  As the jenkins build server
  I need to know details about the constructed artifact
  
  Scenario: I get the correct artifact name for an assembly project
    Given I have an assembly pom.xml
    Given that the assembly jar is built
    When I ask for the artifact name
    Then I should return the name of the assembly jar
  
  Scenario Outline: I get the correct artifact name for an assembly project and a regular project
    Given I have an "<input pom>"
    Given its artifact "<artifact>" is built
    When I ask for the artifact name
    Then I should return the name of the "<artifact>"

    Examples:
      | input pom                           | artifact                                                 |
      | CRMOD_WS_Wriassembly_pom.xml        | hrmsToCrmodUserDataIntegration-jar-with-dependencies.jar |
      | autosr2_ear_pom.xml                 | autoSR2-EAR.ear                                          |