[![pipeline status](https://gitlab.com/gitlab-org/ruby/gems/gitlab-triage/badges/master/pipeline.svg)](https://gitlab.com/gitlab-org/ruby/gems/gitlab-triage/-/commits/master)

# GitLab Triage Project

This project allows to automate triaging of issues and merge requests for GitLab projects or groups.

## Note this Gem is not supported by the GitLab Support team

If you are a customer who has a GitLab License, **support for this gem is not covered by that license agreement as this is not part of the GitLab Product**. Feel free to open an issue in this project and the maintainers may be able to help.

## gitlab-triage gem

### Abstract

The `gitlab-triage` gem aims to enable project managers and maintainers to
automatically triage Issues and Merge Requests in GitLab projects or groups
based on defined policies.

See [Running with the installed gem](#running-with-the-installed-gem) for how to specify a project or a
group.

### What is a triage policy?

Triage policies are defined on a resource level basis, resources being:
- Epics
- Issues
- Merge Requests
- Branches

Each policy can declare a number of conditions that must all be satisfied before
a number of actions are carried out.

Summary policies are special policies that join multiple policies together to
create a summary issue with all the sub-policies' summaries, see
[Summary policies](#summary-policies).

### Defining a policy

Policies are defined in a policy file (by default `./.triage-policies.yml`).
The format of the file is [YAML](https://en.wikipedia.org/wiki/YAML).

> **Note:** You can use the [`--init`](#usage) option to add an example
[`.triage-policies.yml` file](support/.triage-policies.example.yml) to your
project.

Select which resource to add the policy to:
- `epics`
- `issues`
- `merge_requests`
- `branches`

And create an array of `rules` to define your policies:

For example:

```yml
resource_rules:
  epics:
    rules:
      - name: My epic policy
        conditions:
          date:
            attribute: updated_at
            condition: older_than
            interval_type: days
            interval: 5
          state: opened
          labels:
            - None
        actions:
          labels:
            - needs attention
          mention:
            - markglenfletcher
          comment: |
            {{author}} This epic is unlabelled after 5 days. It needs attention. Please take care of this before the end of #{2.days.from_now.strftime('%Y-%m-%d')}
  issues:
    rules:
      - name: My issue policy
        conditions:
          date:
            attribute: updated_at
            condition: older_than
            interval_type: days
            interval: 5
          state: opened
          labels:
            - None
        limits:
          most_recent: 50
        actions:
          labels:
            - needs attention
          mention:
            - markglenfletcher
          move: gitlab-org/backlog
          comment: |
            {{author}} This issue is unlabelled after 5 days. It needs attention. Please take care of this before the end of #{2.days.from_now.strftime('%Y-%m-%d')}
          summarize:
            destination: gitlab-org/ruby/gems/gitlab-triage
            title: |
              #{resource[:type].capitalize} require labels
            item: |
              - [ ] [{{title}}]({{web_url}}) {{labels}}
            redact_confidential_resources: false
            summary: |
              The following issues require labels:

              {{items}}

              Please take care of them before the end of #{7.days.from_now.strftime('%Y-%m-%d')}

              /label ~"needs attention"
  merge_requests:
    rules:
      - name: My merge request policy
        conditions:
          state: opened
          labels:
            - None
        limits:
          most_recent: 50
        actions:
          labels:
            - needs attention
          comment_type: thread
          comment: |
            {{author}} This issue is unlabelled. Please add one or more labels.
  branches:
    rules:
      - name: My branch policy
        conditions:
          date:
            attribute: committed_date
            condition: older_than
            interval_type: months
            interval: 6
          name: ^feature
        actions:
          delete: true
```

### Real world example

We're enforcing multiple polices with pipeline schedules at [triage-ops](
https://gitlab.com/gitlab-org/quality/triage-ops), where we're also
extensively utilizing the [plugins system](#can-i-customize).

### Fields

A policy consists of the following fields:
- [Name field](#name-field)
- [Conditions field](#conditions-field)
- [Limits field](#limits-field)
- [Actions field](#actions-field)

#### Name field

The name field is used to describe the purpose of the individual policy.

Example:

```yml
name: Policy name
```

#### Conditions field

Used to declare a condition that must be satisfied by a resource before actions will be taken.

Available condition types:
- [`date` condition](#date-condition)
- [`milestone` condition](#milestone-condition)
- [`iteration` condition](#iteration-condition)
- [`state` condition](#state-condition)
- [`votes` condition](#votes-condition)
- [`labels` condition](#labels-condition)
- [`forbidden_labels` condition](#forbidden-labels-condition)
- [`no_additional_labels` condition](#no-additional-labels-condition)
- [`author_username` condition](#author-username-condition)
- [`author_member` condition](#author-member-condition)
- [`assignee_member` condition](#assignee-member-condition)
- [`draft` condition](#draft-condition)
- [`source_branch` condition](#source-branch-condition)
- [`target_branch` condition](#target-branch-condition)
- [`health_status` condition](#health-status-condition)
- [`weight` condition](#weight-condition)
- [`issue_type` condition](#issue-type-condition)
- [`discussions` condition](#discussions-condition)
- [`protected` condition](#protected-condition)
- [`ruby` condition](#ruby-condition)
- [`reviewer_id` condition](#reviewer-id-condition)

##### Date condition

Accepts a hash of fields.

| Field           | Type    | Values                                                                     | Required  |
| ---------       | ----    |----------------------------------------------------------------------------| --------  |
| `attribute`     | string  | `created_at`, `updated_at`, `merged_at`, `authored_date`, `committed_date` | yes       |
| `condition`     | string  | `older_than`, `newer_than`                                                 | yes       |
| `interval_type` | string  | `minutes`, `hours`, `days`, `weeks`, `months`, `years`                     | yes       |
| `interval`      | integer | integer                                                                    | yes       |
> **Note:**
>   - `merged_at` only works on merge requests.
>   - `closed_at` is not supported in the GitLab API, but can be used in a [`ruby` condition](#ruby-condition).
>   - `committed_date` and `authored_date` only works for branches.

Example:

```yml
conditions:
  date:
    attribute: updated_at
    condition: older_than
    interval_type: months
    interval: 12
```

> **Note:** If the GitLab server is giving 500 error with this option, it
> can mean that it's taking too much time to query this, and it's timing out.
> A workaround for this is that we can filter in Ruby. If you need this
> workaround, specify this with `filter_in_ruby: true`
>
> ```yaml
> conditions:
> date:
>   attribute: updated_at
>   condition: older_than
>   interval_type: months
>   interval: 12
>   filter_in_ruby: true
> ```

##### Milestone condition

Accepts the name of a milestone to filter upon. Also accepts the following timebox values:

- `none`
- `any`
- `upcoming`
- `started`

See the [`milestone_id` API field documentation](https://docs.gitlab.com/ee/api/issues.html) for their meaning.

Example:

```yml
conditions:
  milestone: v1
```

##### Iteration condition

Accepts the name of an iteration to filter upon. Also accepts the following
timebox values:

- `none`
- `any`

See the [`iteration_id` API field documentation](https://docs.gitlab.com/ee/api/issues.html) for their meaning.

Example:

```yml
conditions:
  iteration: none
```

> **Note:** This query is not supported using GraphQL yet.

##### State condition

Accepts a string.

| State             | Type    | Value    |
| ---------         | ----    | ------   |
| Closed issues/MRs | string  | `closed` |
| Open issues/MRs   | string  | `opened` |
| Locked issues     | string  | `locked` |
| Merged merge requests | string  | `merged` |

Example:

```yml
conditions:
  state: opened
```

##### Votes condition

Accepts a hash of fields.

| Field           | Type    | Values                              | Required  |
| ---------       | ----    | ----                                | --------  |
| `attribute`     | string  | `upvotes`, `downvotes`              | yes       |
| `condition`     | string  | `less_than`, `greater_than`         | yes       |
| `threshold`     | integer | integer                             | yes       |

Example:

```yml
conditions:
  votes:
    attribute: upvotes
    condition: less_than
    threshold: 10
```

##### Labels condition

Accepts an array of strings. Each element in the array represents the name of a label to filter on.

> **Note:** **All** specified labels must be present on the resource for the condition to be satisfied

Example:

```yml
conditions:
  labels:
    - feature proposal
```

###### Predefined special label names

Basing on the [issues API](https://docs.gitlab.com/ee/api/issues.html), there
are two special predefined label names we can use here:

* `None`: This indicates that no labels were present
* `Any`: This indicates that any labels were presented

Example:

```yml
conditions:
  labels:
    - None
```

###### Labels brace expansion

We could expand the labels by using brace expansion, which is a pattern
surrounded by using braces: `{}`. For now, we support 2 kinds of brace
expansion:

1. List: `{ apple, orange }`
2. Sequence: `{1..4}`

> **Note:**
>   - Spaces around the items are ignored.
>   - Do not rely on the expansion ordering. This is subject to change.

###### List

The name of a label can contain a list of items, written like
`{ apple, orange }`. For each item, the rule will be duplicated with the new
label name.

Example:

```yml
resource_rules:
  issues:
    rules:
      - name: Add missing ~Quality label
        conditions:
          labels:
            - Quality:test-{ gap, infra }
        actions:
          labels:
            - Quality
```

Which will be expanded into:

```yml
resource_rules:
  issues:
    rules:
      - name: Add missing ~Quality label
        conditions:
          labels:
            - Quality:test-gap
        actions:
          labels:
            - Quality

      - name: Add missing ~Quality label
        conditions:
          labels:
            - Quality:test-infra
        actions:
          labels:
            - Quality
```

> **Note:**
>   If you want to define a full label expansion, you'll need to [force string](https://yaml.org/YAML_for_ruby.html#forcing_strings) or [quote string](https://yaml.org/YAML_for_ruby.html#single-quoted_strings) because otherwise it won't be considered a string due to the YAML parser.
>   For example, we can quote the expression like `'{ apple, orange }'`, which will create 2 rules, for the two specified labels.

###### Sequence

The name of a label can contain one or more sequence conditions, written
like `{0..9}`, which means `0`, `1`, `2`, and so on up to `9`. For each
number, the rule will be duplicated with the new label name.

Example:

```yml
resource_rules:
  issues:
    rules:
      - name: Add missing ~"missed\-deliverable" label
        conditions:
          labels:
            - missed:{10..11}.{0..1}
            - deliverable
        actions:
          labels:
            - missed deliverable
```

Which will be expanded into:

```yml
resource_rules:
  issues:
    rules:
      - name: Add missing ~"missed\-deliverable" label
        conditions:
          labels:
            - missed:10.0
            - deliverable
        actions:
          labels:
            - missed deliverable

      - name: Add missing ~"missed\-deliverable" label
        conditions:
          labels:
            - missed:10.1
            - deliverable
        actions:
          labels:
            - missed deliverable

      - name: Add missing ~"missed\-deliverable" label
        conditions:
          labels:
            - missed:11.0
            - deliverable
        actions:
          labels:
            - missed deliverable

      - name: Add missing ~"missed\-deliverable" label
        conditions:
          labels:
            - missed:11.1
            - deliverable
        actions:
          labels:
            - missed deliverable
```

##### Forbidden labels condition

Accepts an array of strings. Each element in the array represents the name of a label to filter on.

> **Note:** **All** specified labels must be absent on the resource for the condition to be satisfied

Example:

```yml
conditions:
  forbidden_labels:
    - awaiting feedback
```

##### No additional labels condition

Accepts a boolean. If `true` the resource cannot have more labels than those specified by the `labels` condition.

Example:

```yml
conditions:
  labels:
    - feature proposal
  no_additional_labels: true
```

##### Author username condition

Accepts the username to filter on.

Example:

```yml
conditions:
  author_username: gitlab-bot
```

##### Author Member condition

This condition determines whether the author of a resource is a member of the specified group or project.

This is useful for determining whether Issues or Merge Requests have been raised by a Community Contributor.

Accepts a hash of fields.

| Field           | Type    | Values                              | Required  |
| ---------       | ----    | ----                                | --------  |
| `source`        | string  | `group`, `project`                  | yes       |
| `condition`     | string  | `member_of`, `not_member_of`        | yes       |
| `source_id`     | integer or string | gitlab-org/gitlab      | yes       |

Example:

```yml
conditions:
  author_member:
    source: group
    condition: not_member_of
    source_id: 9970
```

##### Assignee member condition

This condition determines whether the assignee of a resource is a member of the specified group or project.

Accepts a hash of fields.

| Field           | Type    | Values                              | Required  |
| ---------       | ----    | ----                                | --------  |
| `source`        | string  | `group`, `project`                  | yes       |
| `condition`     | string  | `member_of`, `not_member_of`        | yes       |
| `source_id`     | integer or string | gitlab-org/gitlab      | yes       |

Example:

```yml
conditions:
  assignee_member:
    source: group
    condition: not_member_of
    source_id: 9970
```

##### Draft condition

**This condition is only applicable for merge requests.**

Accepts a boolean. If `true`, only draft MRs are returned. If `false`, only non-draft MRs are returned.

Example:

```yml
conditions:
  draft: true
```

##### Source branch condition

**This condition is only applicable for merge requests.**

Accepts the name of a source branch to filter upon.

Example:

```yml
conditions:
  source_branch: 'feature-branch'
```

##### Target branch condition

**This condition is only applicable for merge requests.**

Accepts the name of a target branch to filter upon.

Example:

```yml
conditions:
  target_branch: 'master'
```

##### Health Status condition

**This condition is only applicable for issues.**

Accepts a string per the [API documentation](https://docs.gitlab.com/ee/api/issues.html#list-issues).

| State                  | Type    | Value     |
| ---------              | ----    | ------    |
| Any health status      | string  | `Any`  |
| No health status       | string  | `None`  |
| Specific health status | string  | One of `on_track`, `needs_attention` or `at_risk` |

Example:

```yml
conditions:
  health_status: Any
```

> **Note:** This query is not supported using GraphQL yet.

##### Weight condition

**This condition is only applicable for issues.**

Accepts a string per the [API documentation](https://docs.gitlab.com/ee/api/issues.html#list-issues).

| State           | Type    | Value     |
| ---------       | ----    | ------    |
| Any weight      | string  | `Any`  |
| No weight       | string  | `None`  |
| Specific weight | integer  | integer |

Example:

```yml
conditions:
  weight: Any
```

##### Issue type condition

**This condition is only applicable for issues.**

Accepts a string per the [API documentation](https://docs.gitlab.com/ee/api/issues.html#list-issues). This condition can only filter by one issue type.

| Issue type      | Type    | Value       |
| ---------       | ----    | ------      |
| Regular issue   | string  | `issue`     |
| Incident        | string  | `incident`  |
| Test case       | string  | `test_case` |

Example:

```yml
conditions:
  issue_type: issue
```

##### Discussions condition

Accepts a hash of fields.

| Field           | Type    | Values                              | Required  |
| ---------       | ----    | ----                                | --------  |
| `attribute`     | string  | `threads`, `notes`                  | yes       |
| `condition`     | string  | `less_than`, `greater_than`         | yes       |
| `threshold`     | integer | integer                             | yes       |

Example:

```yml
conditions:
  discussions:
    attribute: threads
    condition: greater_than
    threshold: 15
```

##### Protected condition

**This condition is only applicable for branches**

Accept a boolean.
If not specified, default to `false` to filter out protected branches.

##### Ruby condition

This condition allows users to write a Ruby expression to be evaluated for
each resource. If it evaluates to a truthy value, it satisfies the condition.
If it evaluates to a falsey value, it does not satisfy the condition.

Accepts a string as the Ruby expression.

Example:

```yml
conditions:
  ruby: Date.today > milestone.succ.start_date
```

In the above example, this describes that we want to act on the resources
which passed the next active milestone's starting date.

Here `milestone` will return a `Gitlab::Triage::Resource::Milestone` object,
representing the milestone of the questioning resource. `Milestone#succ` would
return the next active milestone, based on the `start_date` of all milestones
along with the representing milestone. If the milestone was coming from a
project, then it's based on all active milestones in that project. If the
milestone was coming from a group, then it's based on all active milestones
in the group.

If we also want to handle some edge cases, for example, a resource might not
have a milestone, and a milestone might not be active, and there might not
have a next milestone. We could instead write something like:

```yml
conditions:
  ruby: milestone&.active? && milestone&.succ && Date.today > milestone.succ.start_date
```

This will make it only act on resources which have active milestones and
there exists next milestone which has already started.

Since `closed_at` is not a queryable attribute in the GitLab API, we can use a Ruby expression to filter resources like:

```yml
conditions:
  ruby: resource[:closed_at] > 7.days.ago.strftime('%Y-%m-%dT00:00:00.000Z')
```

See [Ruby expression API](#ruby-expression-api) for the list of currently
available API.

#### Limits field

Limits restrict the number of resources on which an action is carried out. They
can be useful when combined with conditions that return a large number of
resources. For example, if the conditions are satisfied by thousands of issues a
limit can be configured to process only fifty of them to avoid making an
overwhelming number of changes at once.

Accepts a key and value pair where the key is `most_recent` or `oldest` and the
value is the number of resources to act on. The following table outlines how
each key affects the sorting and order of resources that it limits.

| Name / Key    | Sorted by    | Order      |
| ---------     | ----         | ------     |
| `most_recent` | `created_at` | descending |
| `oldest`      | `created_at` | ascending  |

Example:

```yml
limits:
  most_recent: 50
```

##### Reviewer id condition

**This condition is only applicable for merge requests.**

Accepts the id of a user to filter on. Also accepts `none` or `any`.

Example:

```yml
conditions:
  reviewer_id: any
```

#### Actions field

Used to declare an action to be carried out on a resource if **all** conditions are satisfied.

Available action types:
- [`labels` action](#labels-action)
- [`remove_labels` action](#remove-labels-action)
- [`status` action](#status-action)
- [`mention` action](#mention-action)
- [`move` action](#move-action)
- [`comment` action](#comment-action)
  - [`redact_confidential_resources` option](#redact-confidential-resources-option)
- [`comment_type` action option](#comment-type-action-option)
- [`summarize` action](#summarize-action)
- [`comment_on_summary` action](#comment-on-summary-action)
- [`issue` action](#create-a-new-issue-from-each-resource)
- [`delete` action](#delete-action)

##### Labels action

Adds a number of labels to the resource.

Accepts an array of strings. Each element is the name of a label to add.

If any of the labels doesn't exist, the automation will stop immediately so
that if a label is renamed or deleted, you'll have to explicitly update or remove
it in your policy file.

Example:

```yml
actions:
  labels:
    - feature proposal
    - awaiting feedback
```

##### Remove labels action

Removes a number of labels from the resource.

Accepts an array of strings. Each element is the name of a label to remove.

If any of the labels doesn't exist, the automation will stop immediately so
that if a label is renamed or deleted, you'll have to explicitly update or remove
it in your policy file.

Example:

```yml
actions:
  remove_labels:
    - feature proposal
    - awaiting feedback
```

##### Status action

Changes the status of the resource.

Accepts a string.

| State transition    | Type    | Value     |
| ---------           | ----    | ------    |
| Close the resource  | string  | `close`   |
| Reopen the resource | string  | `reopen`  |

Example:

```yml
actions:
  status: close
```

##### Mention action

Mentions a number of users.

Accepts an array of strings. Each element is the username of a user to mention.

Example:

```yml
actions:
  mention:
    - rymai
    - markglenfletcher
```

##### Move action

Moves an issue (merge request is not supported yet) to the specified project.

Accepts a string containing the target project path.

Example:

```yml
actions:
  move: target/project_path
```

##### Comment action

Adds a comment to the resource.

Accepts a string, and placeholders. Placeholders should be wrapped in double
curly braces, e.g. `{{author}}`.

The following placeholders are supported:

- `created_at`: the resource's creation date
- `updated_at`: the resource's last update date
- `closed_at`: the resource's closed date (if applicable)
- `merged_at`: the resource's merged date (if applicable)
- `state`: the resources's current state: `opened`, `closed`, `merged`
- `author`: the username of the resource's author as `@user1`
- `assignee`: the username of the resource's assignee as `@user1`
- `assignees`: the usernames of the resource's assignees as `@user1, @user2`
- `reviewers`: the usernames ot the resource's reviewers as `@user1, @user2` (if applicable)
- `closed_by`: the user that closed the resource as `@user1` (if applicable) 
- `merged_by`: the user that merged the resource as `@user1` (if applicable)
- `milestone`: the resource's current milestone
- `labels`: the resource's labels as `~label1, ~label2`
- `upvotes`: the resources's upvotes count
- `downvotes`: the resources's downvotes count
- `title`: the resource's title
- `web_url`: the web URL pointing to the resource
- `full_reference`: the full reference of the resource as `namespace/project#12`, `namespace/project!42`, `namespace/project&72`
- `type`: the type of the resources. For now, only `issues`, `merge_requests`, and `epics` are supported.

If the resource doesn't respond to the placeholder, or if the field is `nil`,
the placeholder is not replaced.

Example without placeholders:

```yml
actions:
  comment: |
    Closing this issue automatically
```

Example with placeholders:

```yml
actions:
  comment: |
    {{author}} Are you still interested in finishing this merge request?
```

###### Redact confidential resources option

Determines if the data of confidential resources is redacted.

If the option is set to `true` or not set, data from confidential will appear as `(confidential)`. \
When it is set to `false`, everything will be revealed and visible.

Example:

```yml
actions:
  redact_confidential_resources: false
  comment: |
    {{author}} Are you still interested in finishing this merge request?
```

##### Comment type action option

Determines the type of comment to be added to the resource.

The following comment types are supported:

- `comment` (default): creates a regular comment on the resource
- `thread`: starts a resolvable thread (discussion) on the resource

For merge requests, if `comment_type` is set to `thread`, we can also configure that [all threads should be resolved before merging](https://docs.gitlab.com/ee/user/discussions/#only-allow-merge-requests-to-be-merged-if-all-threads-are-resolved), therefore this comment can prevent it from merging.

Example:

```yml
actions:
  comment_type: thread
  comment: |
    {{author}} Are you still interested in finishing this merge request?
```

###### Comment internal action option

Determines whether the note is added as an internal comment to the resource.

If the option is set to `false` or not set, the comment will not be internal. \
When it is set to `true`, the comment will be internal.

Example:

```yml
actions:
  comment_internal: true
  comment: |
    This issue has breached SLA, please take a look @team!
```

###### Harnessing Quick Actions

[GitLab's quick actions feature](https://docs.gitlab.com/ce/user/project/quick_actions.html) is available in Core.
All of the operations supported by executing a quick action can be carried out via the comment action.

If GitLab triage does not support an operation natively, it may be possible via a quick action in a comment.

For example:
- Flagging an issue as [confidential](https://docs.gitlab.com/ce/user/project/issues/confidential_issues.html)
- [Locking issue discussion](https://docs.gitlab.com/ce/user/discussions/#lock-discussions)

```yml
resource_rules:
  issues:
    rules:
      - name: Mark bugs as confidential
        conditions:
          state: opened
          ruby: !resource[:confidential]
          labels:
            - bug
        actions:
          comment: |
            /confidential
```

###### Ruby expression

The comment can also contain Ruby expression, using Ruby's own string
interpolation syntax: `#{ expression }`. This gives you the most flexibility.
Suppose you want to mention the next active milestone relative to the one
associated with the resource, you can write:

```yml
actions:
  comment: |
    Please move this to %"#{milestone.succ.title}".
```

See [Ruby expression API](#ruby-expression-api) for the list of currently
available API.

> **Note:** If you get a syntax error due to stray braces (`{` or `}`), use `\`
to escape it. For example:
>
> ```yml
> actions:
>  comment: |
>    If \} comes first and/or following \{, you'll need to escape them. If it's just { wrapping something } then you don't need to, but it's also fine to escape them like \{ this \} if you prefer.
> ```

##### Summarize action

Generates an issue summarizing what was triaged.

Accepts a hash of fields.

| Field         | Type   | Description                                     | Required | Placeholders | Ruby expression | Default        |
| ----          | ----   | ----                                            | ----     | ----         | ----            | ----           |
| `title`       | string | The title of the generated issue                | yes      | yes          | yes             |                |
| `destination` | integer or string | The project ID or path to create the generated issue in | no   | no              | no             | source project |
| `item`        | string | Template representing each triaged resource     | no       | yes          | yes             |                |
| `summary`     | string | The description of the generated issue          | no       | Only `{{title}}`, `{{items}}`, `{{type}}` | yes | |
| `redact_confidential_resources` | boolean | Whether redact fields for confidential resources | no | no | no | true |

The following placeholders are supported for `summary`:

- `title`: The title of the generated issue
- `items`: Concatenated markdown separated by a newline for each `item`
- `type`: The resource type for the summary. For now `issues`, `merge_requests`, or `epics`,

> **Note:**
> - Both `item` and `summary` fields act like a [comment action](#comment-action),
>   therefore [Ruby expression](#ruby-expression) is supported.
> - Placeholders work regularly for `item`, but for `summary` only `{{title}}`,
>   `{{items}}`, `{{type}}` are supported because it's not tied to a particular
>   resource like the comment action.
> - No issues will be created if:
>    - the specific policy doesn't yield any resources; or
>    - the source type is a group and `destination` is not set.
> - `redact_confidential_resources` defaults to `true`, so fields on
> confidential resources will be converted to `(confidential)` except for
> `{{web_url}}`. Setting it to `false` will reveal the confidential fields.
> This will be useful if the summary is confidential itself (not implemented
> yet), or if we're posting to another private project (not implemented yet).

Example:

```yml
resource_rules:
  issues:
    rules:
      - name: Issues require labels
        limits:
          most_recent: 15
        actions:
          summarize:
            title: |
              #{resource[:type].capitalize} require labels
            item: |
              - [ ] [{{title}}]({{web_url}}) {{labels}}
            summary: |
              The following {{type}} require labels:

              {{items}}

              Please take care of them before the end of #{7.days.from_now.strftime('%Y-%m-%d')}

              /label ~"needs attention"
```

Which could generate an issue like:

Title:

```
Issues require labels
```

Description:

```markdown
The following issues require labels:

- [ ] [An example issue](http://example.com/group/project/issues/1) ~"label A", ~"label B"
- [ ] [Another issue](http://example.com/group/project/issues/2) ~"label B", ~"label C"

Please take care of them before the end of 2000-01-01

/label ~"needs attention"
```

##### Comment on summary action

Generates one comment for each resource, attaching these comments to the summary
created by the [`summarize` action](#summarize-action).

The use case for this is wanting to create a summary with an overview, and then
a threaded discussion for each resource, with a header comment starting each
discussion.

Accepts a single string value: the template used to generate the comments. For
details of the syntax of this template, see the [comment action](#comment-action).

Since this action depends on the summary, it is invalid to supply a
`comment_on_summary` action without an accompanying `summarize` sibling action.
The `summarize` action will always be completed first.

Just like for [comment action](#comment-action), setting `comment_type` in the
`actions` set controls whether the comment must be resolved for merge requests.
See: [`comment_type` action option](#comment-type-action-option).

Example:

```yml
resource_rules:
  issues:
    rules:
      - name: List of issues to discuss
        limits:
          most_recent: 15
        actions:
          comment_type: thread
          comment_on_summary: |
            # {{title}}

            author: {{author}}
          summarize:
            title: |
              #{resource[:type].capitalize} require labels
            item: |
              - [ ] [{{title}}]({{web_url}}) {{labels}}
            summary: |
              The following {{type}} require labels:

              {{items}}

              Please take care of them before the end of #{7.days.from_now.strftime('%Y-%m-%d')}

              /label ~"needs attention"
```

##### Create a new issue from each resource

Generates one issue for each resource, by default in the same project as the resource.

The use case for this is, for example, creating test issues in the same (or different)
project for issues labeled "extended-testing"; or automatically splitting one issue with a
certain label into multiple ones.

Accepts a hash of fields.

| Field         | Type   | Description                                     | Required | Placeholders | Ruby expression | Default        |
| ----          | ----   | ----                                            | ----     | ----         | ----            | ----           |
| `title`       | string | The title of the generated issue                | yes      | yes          | yes             |                |
| `destination` | integer or string | The project ID or path to create the generated issue in | no   | no              | no             | source project |
| `description`     | string | The description of the generated issue          | no       | yes | yes | |
| `redact_confidential_resources` | boolean | Whether redact fields for confidential resources | no | no | no | true |

The placeholders available in `title` and `destination` are the properties of the resource being used to generate the issue.

Example

```yml
resource_rules:
  issues:
    rules:
      - name: Issues requiring extra testing
        labels:
          - needs-testing
        actions:
          issue:
            title: |
              Testing: {{ title }}
            description: |
              The issue {{ full_reference }} needs testing.

              Please take care of them before the end of #{7.days.from_now.strftime('%Y-%m-%d')}

              /label ~"needs attention"
```

##### Delete action

**This action is only applicable for branches.**

Delete the resource.

Accept a boolean. Set to `true` to enable.

Example :
```yaml
resource_rules:
  branches:
    rules:
      - name: My branch policy
        conditions:
          date:
            attribute: committed_date
            condition: older_than
            interval_type: months
            interval: 30
        actions:
          delete: true
```

### Summary policies

Summary policies are special policies that join multiple rule policies together
to create a summary issue with all the sub-policies' summaries.
They have the same structure as Rule policies that define `actions.summarize`.

One key difference is that the `{{items}}` placeholder represents the array of
sub-policies' summary.

Note that only the `summarize` keys in the sub-policies' `actions` is used. Any
other keys (e.g. `mention`, `comment`, `labels` etc.) are ignored.

You can define such policy as follows:

```yml
resource_rules:
  issues:
    summaries:
      - name: Newest and oldest issues summary
        rules:
          - name: New issues
            conditions:
              state: opened
            limits:
              most_recent: 2
            actions:
              summarize:
                item: "- [ ] [{{title}}]({{web_url}}) {{labels}}"
                summary: |
                  Please triage the following new {{type}}:

                  {{items}}
          - name: Old issues
            conditions:
              state: opened
            limits:
              oldest: 2
            actions:
              summarize:
                item: "- [ ] [{{title}}]({{web_url}}) {{labels}}"
                summary: |
                  Please triage the following old {{type}}:

                  {{items}}
        actions:
          summarize:
            title: "Newest and oldest {{type}} summary"
            summary: |
              Please triage the following {{type}}:

              {{items}}

              Please take care of them before the end of #{7.days.from_now.strftime('%Y-%m-%d')}

              /label ~"needs attention"
```

Which could generate an issue like:

Title:

```
Newest and oldest issues summary
```

Description:

```markdown
Please triage the following issues:

Please triage the following new issues:

- [ ] [A new issue](http://example.com/group/project/issues/4)
- [ ] [Another new issue](http://example.com/group/project/issues/3) ~"label B", ~"label C"

Please triage the following old issues:

- [ ] [An old issue](http://example.com/group/project/issues/1) ~"label A", ~"label B"
- [ ] [Another old issue](http://example.com/group/project/issues/2) ~"label C"

Please take care of them before the end of 2000-01-01

/label ~"needs attention"
```

> **Note:** If a specific policy doesn't yield any resources, it will not
> generate the corresponding description. If all policies yield no resources,
> then no issues will be created.

### Ruby expression API

Here's a list of currently available Ruby expression API:

##### Methods for `Issue` and `MergeRequest` (the context)

| Name                    | Return type     | Description |
| ----                    | ----            | ----        |
| resource                | Hash            | The hash containing the raw data of the resource. Note that `resource[:type]` is the type of the policy (`issues`, `merge_requests`, or `epics`), not the API `type` field. |
| author                  | String          | The username of the resource author |
| state                   | String          | The state of the resource |
| milestone               | Milestone       | The milestone attached to the resource |
| labels                  | [Label]         | A list of labels, having only names |
| labels_with_details     | [Label]         | A list of labels which has more information loaded from another API request |
| labels_chronologically  | [Label]         | Same as `labels_with_details` but sorted chronologically |
| label_events            | [LabelEvent]    | A list of label events on the resource |
| instance_version        | InstanceVersion | The version for the GitLab instance we're triaging with |
| project_path            | String          | The path with namespace to the issues or merge requests project |
| full_resource_reference | String          | A full reference including project path to the issue or merge request |

##### Methods for `Issue` and `LinkedIssue` (issue context)

| Name                   | Return type    | Description |
| ----                   | ----           | ----        |
| merge_requests_count   | Integer        | The number of merge requests related to the issue |
| related_merge_requests | [MergeRequest] | The list of merge requests related to the issue |
| closed_by              | [MergeRequest] | The list of merge requests that close the issue |
| linked_issues          | [LinkedIssue]  | The list of issues that are linked to the issue |
| due_date               | Date           | The due date of the issue. Could be `nil` |

##### Methods for `LinkedIssue`

| Method    | Return type | Description |
| ----      | ----        | ----        |
| link_type | String      | The link type of the linked issue (`blocks`, `is_blocked_by`, or `relates_to`) |

##### Methods for `MergeRequest` (merge request context)

| Method              | Return type | Description |
| ----                | ----        | ----        |
| first_contribution? | Boolean     | `true` if it's the author's first contribution to the project; `false` otherwise. This API requires an additional API request for the merge request, thus would be slower. |
| closes_issues       | [Issue]     | The list of issues that would be closed by merging the provided merge request |

##### Methods for `Milestone`

| Method      | Return type | Description |
| ----        | ----        | ----        |
| id          | Integer     | The id of the milestone |
| iid         | Integer     | The iid of the milestone |
| project_id  | Integer     | The project id of the milestone if available |
| group_id    | Integer     | The group id of the milestone if available |
| title       | String      | The title of the milestone |
| description | String      | The description of the milestone |
| state       | String      | The state of the milestone. Could be `active` or `closed` |
| due_date    | Date        | The due date of the milestone. Could be `nil` |
| start_date  | Date        | The start date of the milestone. Could be `nil` |
| updated_at  | Time        | The updated timestamp of the milestone |
| created_at  | Time        | The created timestamp of the milestone |
| succ        | Milestone   | The next active milestone beside this milestone |
| active?     | Boolean     | `true` if `state` is `active`; `false` otherwise |
| closed?     | Boolean     | `true` if `state` is `closed`; `false` otherwise |
| started?    | Boolean     | `true` if `start_date` exists and in the past; `false` otherwise |
| expired?    | Boolean     | `true` if `due_date` exists and in the past; `false` otherwise |
| in_progress?| Boolean     | `true` if `started?` and `!expired`; `false` otherwise |

##### Methods for `Label`

| Method      | Return type | Description |
| ----        | ----        | ----        |
| id          | Integer     | The id of the label |
| project_id  | Integer     | The project id of the label if available |
| group_id    | Integer     | The group id of the label if available |
| name        | String      | The name of the label |
| description | String      | The description of the label |
| color       | String      | The color of the label in RGB |
| priority    | Integer     | The priority of the label |
| added_at    | Time        | When the label was added to the resource |

##### Methods for `LabelEvent`

| Method        | Return type | Description |
| ----          | ----        | ----        |
| id            | Integer     | The id of the label event |
| resource_type | String      | The resource type of the event. Could be `Issue` or `MergeRequest` |
| resource_id   | Integer     | The id of the resource |
| action        | String      | The action of the event. Could be `add` or `remove` |
| created_at    | Time        | When the event happened |

##### Methods for `InstanceVersion`

| Method        | Return type | Description |
| ----          | ----        | ----        |
| version       | String      | The full string of version. e.g. `11.3.0-rc11-ee` |
| version_short | String      | The short string of version. e.g. `11.3` |
| revision      | String      | The revision of GitLab. e.g. `231b0c7` |

### Installation

    gem install gitlab-triage

### Usage

    gitlab-triage --help

Will show:

```
Usage: gitlab-triage [options]

    -n, --dry-run                    Don't actually update anything, just print
    -f, --policies-file [string]     A valid policies YML file
        --all-projects               Process all projects the token has access to
    -s, --source [type]              The source type between [ projects or groups ], default value: projects
    -i, --source-id [string]         Source ID or path
    -p, --project-id [string]        [Deprecated] A project ID or path, please use `--source-id`
        --resource-reference [string]
                                     Resource short-reference, e.g. #42, !33, or &99
    -t, --token [string]             A valid API token
    -H, --host-url [string]          A valid host url
    -r, --require [string]           Require a file before performing
    -d, --debug                      Print debug information
    -h, --help                       Print help message
    -v, --version                    Print version
        --init                       Initialize the project with a policy file
        --init-ci                    Initialize the project with a .gitlab-ci.yml file
```

#### Running with the installed gem

Triaging against a specific project:

```
gitlab-triage --dry-run --token $GITLAB_API_TOKEN --source-id gitlab-org/triage
```

Triaging against a whole group:

```
gitlab-triage --dry-run --token $GITLAB_API_TOKEN --source-id gitlab-org --source groups
```

Triaging against an entire instance:

```
gitlab-triage --dry-run --token $GITLAB_API_TOKEN --all-projects
```

> **Note:** The `--all-projects` option will process all resources for all projects visible to the specified `$GITLAB_API_TOKEN`

#### Running from source

Execute the `gitlab-triage` script from the `./bin` directory.

For example- after cloning this project, from the root `gitlab-triage` directory:

```
bundle exec bin/gitlab-triage --dry-run --token $GITLAB_API_TOKEN --source-id gitlab-org/triage
```

Triaging against specific resource:

```
gitlab-triage --dry-run --token $API_TOKEN --source-id gitlab-org/triage --resource-reference '#42'
gitlab-triage --dry-run --token $API_TOKEN --source-id gitlab-org/triage --resource-reference '!33'
gitlab-triage --dry-run --token $API_TOKEN --source groups --source-id gitlab-org --resource-reference '&99'
```

#### Running on GitLab CI pipeline

You can enforce policies using a scheduled pipeline:

```yml
run:triage:triage:
  stage: triage
  script:
    - gem install gitlab-triage
    - gitlab-triage --token $GITLAB_API_TOKEN --source-id $CI_PROJECT_PATH
  rules:
    - if: $CI_PIPELINE_SOURCE == "schedule"
```

> **Note:** You can use the [`--init-ci`](#usage) option to add an example [`.gitlab-ci.yml` file](support/.gitlab-ci.example.yml) to your project

#### Can I use gitlab-triage for my self-hosted GitLab instance?

Yes, you can override the host url using the following options:

##### CLI

```
gitlab-triage --dry-run --token $GITLAB_API_TOKEN --source-id gitlab-org/triage --host-url https://gitlab.host.com
```

##### Policy file

```yml
host_url: https://gitlab.host.com
resource_rules:
```

#### Can I customize?

You can take the advantage of command line option `-r` or `--require` to
load a Ruby file before performing the actions. This allows you to do
whatever you want. For example, you can put this in a file like `my_plugin.rb`:

```ruby
module MyPlugin
  def has_severity_label?
    labels.grep(/^S\d+$/).any?
  end

  def has_priority_label?
    labels.grep(/^P\d+$/).any?
  end

  def labels
    resource[:labels]
  end
end

Gitlab::Triage::Resource::Context.include MyPlugin
```

And then run it with:

```shell
gitlab-triage -r ./my_plugin.rb --token $GITLAB_API_TOKEN --source-id gitlab-org/triage
```

This allows you to use `has_severity_label?` in the Ruby condition:

```yml
resource_rules:
  issues:
    rules:
      - name: Apply default severity or priority labels
        conditions:
          ruby: |
            !has_severity_label? || !has_priority_label?
        actions:
          comment: |
            #{'/label ~S3' unless has_severity_label?}
            #{'/label ~P3' unless has_priority_label?}
```

### Contributing

Please refer to the [Contributing Guide](CONTRIBUTING.md).

## Release Process

We release `gitlab-triage` on an ad-hoc basis. There is no regularity to when
we release, we just release when we make a change - no matter the size of the
change.

To release a new version:

1. Create a Merge Request.
1. Use Merge Request template [Release.md](https://gitlab.com/gitlab-org/ruby/gems/gitlab-triage/-/blob/master/.gitlab/merge_request_templates/Release.md).
1. Follow the instructions.
1. After the Merge Request has been merged, a new gem version is [published automatically](https://gitlab.com/gitlab-org/quality/pipeline-common/-/blob/master/ci/gem-release.yml)
