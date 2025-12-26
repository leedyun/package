# GitLab Application SDK - Ruby

This SDK is for using GitLab Application Services with Ruby.

## How to use the SDK

### Using the gem

Add the gem to your Gemfile:

```ruby
gem 'gitlab-sdk'
```

### Using the client

Initialize the client:

```ruby
client = GitlabSDK::Client.new(app_id: 'YOUR_APP_ID', host: 'YOUR_HOST')
```

## Client initialization options

| Option          | Description                                                                                                                                        |
|:----------------|:---------------------------------------------------------------------------------------------------------------------------------------------------|
| `app_id`        | The ID specified in the GitLab Project Analytics setup guide. It ensures your data is sent to your analytics instance.                             |
| `host`          | The GitLab Project Analytics instance specified in the setup guide. When using a non-standard port, includde it here, e.g. `http://localhost:9091` |
| `buffer_size`   | Optional. Default `1`. How many events are sent in one request at a time. Setting more than `1` will change the HTTP method from `GET` to `POST`.  |
| `async`         | Optional. Default `true`. Use `AsyncEmitter` instead of `Emitter` for non-blocking requests.                                                       |

For more details see Snowplow Ruby Tracker [docs](https://snowplow.github.io/snowplow-ruby-tracker/).

## Methods

### `flush`

Used to manually flush all events from Snowplow Ruby Tracker's emitters, defaults to synchronous.

```ruby
# Flush events synchronously (default)
client.flush_events

# Flush events asynchronously
client.flush_events(async: true)
```

| Property         | Type      | Description                                                               |
|:-----------------|:----------|:--------------------------------------------------------------------------|
| `async`          | `Boolean` | Optional. Default `false`. Use `true` to flush all events asynchronously. |

### `identify`

Used to associate a user and their attributes with the session and tracking events.

```ruby
client.identify('123abc', { user_name: 'Matthew' })
```

| Property         | Type      | Description                                                              |
|:-----------------|:----------|:-------------------------------------------------------------------------|
| `user_id`         | `String` | The ID of the user.                                                      |
| `user_attributes` | `Hash`   | Optional. The user attributes to add to the session and tracking events. |

### `track`

Used to trigger a custom event.

```ruby
client.track(event_name, event_attributes)
```

| Property          | Type      | Description                                                      |
|:------------------|:----------|:-----------------------------------------------------------------|
| `event_name`       | `String` | The name of the event.                                           |
| `event_attributes` | `Hash`   | The event attributes to add to the tracked event.                |

## Developing with the devkit

To develop with a local Snowplow pipeline, use Analytics devkit's [Snowplow setup](https://gitlab.com/gitlab-org/analytics-section/product-analytics/devkit/-/tree/main#setup).

To test the gem's functionality, run `bin/console`.

## Releasing the gem

To release a new version of the gem, create an MR using the "Release" template.
After merging the MR, the gem will be automatically uploaded to [RubyGems](https://rubygems.org/gems/gitlab-sdk).
