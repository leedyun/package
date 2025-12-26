Feature: GIT Repo Info
  In order to deploy maven artifacts
  As the jenkins build server
  I need to know details about the constructed artifacts
  
  Scenario Outline: There are no uncommitted changes in the current project
    Given the git repo: "<git repo directory>"
    Given there are no uncommitted changes in that directory
    When I ask if there are any uncommitted changes
    Then the program should return "<output>"

    Examples:
      | git repo directory                  | output  |
      | /tmp/git_repo_no_uncommitted        | true    |
      | /tmp/git_repo_uncommitted           | false   |