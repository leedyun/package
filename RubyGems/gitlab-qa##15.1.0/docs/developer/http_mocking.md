# HTTP mocking

Some scenario types might require mocking third party services. [Mock server](../../lib/gitlab/qa/component/mock_server.rb) component
can be used for that. It is based on simple http mock server called [smocker](https://smocker.dev/).

## Using

Simple usage example:

```ruby
Component::Gitlab.perform do |gitlab|
  gitlab.network = 'test'
  gitlab.instance do
    Component::MockServer.perform do |mock|
      mock.network = gitlab.network
      mock.instance do
        Component::Specs.perform do
          ...
        end
      end
    end
  end
end
```

Mock server will be accessible from within gitlab or qa test container via `http://smocker.test` url and admin interface will be
accessible via `http://smocker.test:8081`. Refer to [Getting Started](https://smocker.dev/guide/getting-started.html) guide on
how to use the server and define mocked requests and responses.
