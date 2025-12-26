# Changelog

## 2.0.1

* [Fix helpers not available by default in Grape endpoints](https://gitlab.com/gitlab-org/ruby/gems/grape-path-helpers/-/merge_requests/46)


## 2.0.0

* [Adds support for Rack 3](https://gitlab.com/gitlab-org/ruby/gems/grape-path-helpers/-/merge_requests/45)

## 1.7.1

* Fix undefined method error (https://gitlab.com/gitlab-org/grape-path-helpers/-/merge_requests/42)

## 1.7.0

* [Further improve performance of route matching](https://gitlab.com/gitlab-org/grape-path-helpers/-/merge_requests/38)

## 1.6.3

* [Fix route matcher when method ends in path and arg isn't a Hash](https://gitlab.com/gitlab-org/grape-path-helpers/-/merge_requests/35)

## 1.6.2

* [Improve performance of route matching](https://gitlab.com/gitlab-org/grape-path-helpers/-/merge_requests/33)

## 1.6.1

* [Use ruby2_keywords to fix 2.7 warning](https://gitlab.com/gitlab-org/grape-path-helpers/-/merge_requests/31)

## 1.6.0

* [Extract kwargs to fix 2.7 warnings](https://gitlab.com/gitlab-org/grape-path-helpers/-/merge_requests/29)

## 1.5.0

* [Relax rake dependency](https://gitlab.com/gitlab-org/grape-path-helpers/-/merge_requests/27)

## 1.4.0

* [Support using a base class other than Grape::API::Instance](https://gitlab.com/gitlab-org/grape-path-helpers/-/merge_requests/23)

## 1.3.0

* [Upgrade to Grape 1.3.1](https://gitlab.com/gitlab-org/grape-path-helpers/-/merge_requests/21)

## 1.2.0

* [Add wildcard segments support](https://gitlab.com/gitlab-org/grape-path-helpers/merge_requests/16)

## 1.1.0

* [Relax dependency on ActiveSupport](https://gitlab.com/gitlab-org/grape-path-helpers/merge_requests/12)

## 1.0.6

* [Fix segments parsing for optional segments](https://gitlab.com/gitlab-org/grape-path-helpers/merge_requests/10)

## 1.0.5

* [Relax dependencies](https://gitlab.com/gitlab-org/grape-path-helpers/merge_requests/9)

## 1.0.4

* [Fix respond_to_missing? for included modules](https://gitlab.com/gitlab-org/grape-path-helpers/merge_requests/8)

## 1.0.3

* [Fix return value in method_missing? implementation](https://gitlab.com/gitlab-org/grape-path-helpers/merge_requests/7)
* [Fix broken respond_to_missing? implementation](https://gitlab.com/gitlab-org/grape-path-helpers/merge_requests/6)

## 1.0.2

* [Rename rake task from `grape:route_helpers` to `grape:path_helpers`](https://gitlab.com/gitlab-org/grape-path-helpers/merge_requests/5)

## 1.0.1

* [Do not shadow helpers with the same name but more params](https://gitlab.com/gitlab-org/grape-path-helpers/merge_requests/3)
* [Reduce the number of calls to HashWithIndifferentAccess](https://gitlab.com/gitlab-org/grape-path-helpers/merge_requests/4)
* Update to Grape 1.0

# Changelog for grape-route-helpers

## December 17 2016

* Bump to 2.1.0
* Fix bug that caused POST routes to be ignored if more than one was defined
* Many thanks to @njd5475 for the bug report and pull request that helped me write this

## April 28 2016

* Release 2.0.0
* Fix incompatibility between grape-route-helpers and grape 0.16.0

## April 11 2016

* Release 1.2.2
* Fixed incompatibility between grape-route-helpers and Ruby 2.3 by merging PR #8 from phallguy

## October 11 2015

* Release 1.2.1
* Fixed issue #4

## September 27 2015

* Release 1.2.0

* You can now assign custom helper names to Grape routes
* Fixed a bug where routes would be listed more than once in the rake task if they are mounted to another API
* Added the HTTP verb to rake task output

## July 5 2015

* You can now pass query parameters to helper functions in order to generate your own query string (Issue #1)

## June 28 2015

Release 1.0.1

* Rename rake task from `grape:routes` to `grape:route_helpers`

* If a Grape::Route has a specific format (json, etc.) in its route_path attribute, the helper will return a path with this extension at the end
