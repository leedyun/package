# Configuring Omnibus

Omnibus will, by default, contain the configuration specified in `Gitlab::QA::Runtime::OmnibusConfigurations::Default`.

Omnibus can be configured from two places:

1. Within a custom `Scenario::Template`.
1. Represented as a `Gitlab::QA::Runtime::OmnibusConfiguration` class.

## Adding an Omnibus Configurator

All configurators are held within `Gitlab::QA::Runtime::OmnibusConfigurations` and represented as separate classes.

Notes:

- If it is required that more than one GitLab instance is configured, 
  you may skip adding an Omnibus Configurator.  In this case, it should be handled by a separate `Scenario::Template`.
  An example of this would be a Geo Primary and Secondary.
- All classes should be a type of `Runtime::OmnibusConfiguration`.

### Add the Configurator Class

Create a new file in `lib/gitlab/qa/runtime/omnibus_configurations` called `registry.rb`.

```ruby
# frozen_string_literal: true

module Gitlab
  module QA
    module Runtime
      module OmnibusConfigurations
        class Registry < Default
          def configuration
            <<~OMNIBUS
              gitlab_rails['registry_enabled'] = true
            OMNIBUS
          end
        end
      end
    end
  end
end
```

Notes:

- Refrain from adding unnecessary statement terminations (`;`).

### Prepare Sidecar Container

If the tests require an additional container to be spun up adjacent to GitLab, you may override the `prepare` method.

```ruby
#=> lib/gitlab/qa/runtime/omnibus_configurations/registry.rb

# frozen_string_literal: true

module Gitlab
  module QA
    module Runtime
      module OmnibusConfigurations
        class Registry < Default
          def configuration
            <<~OMNIBUS
              gitlab_rails['registry_enabled'] = true
            OMNIBUS
          end

          def prepare
            Component::Sidecar.new
          end
        end
      end
    end
  end
end
```

Notes:

- `prepare` **must** return an instance of `Component::Base`.
- The sidecar container will be prepared before the test runs, and will run the tests after it is running.
- Extending the class from `Default` is only a nicety that adds a singleton method called `Registry.configuration` and returns the configuration.
  It is recommended to extend from `Default`, but you may also extend from any other Omnibus Configuration class, including `Runtime::OmnibusConfiguration`.

## Setting variables from components in Omnibus configuration using ERB template

Omnibus configurations can use ERB templates to serve as a placeholder for variables. These variable can be replaced with actual value in a component
when preparing the omnibus config.

for example:

 ```ruby
#=> lib/gitlab/qa/runtime/omnibus_configurations/github_oauth.rb

module Gitlab
  module QA
    module Runtime
      module OmnibusConfigurations
        class GithubOauth < Default
          def configuration
            <<~OMNIBUS
              ...
              external_url '<%= gitlab.address %>';
            OMNIBUS
          end
        end
      end
    end
  end
end
```

Here, `<%= gitlab.address %>` will be replaced by calling the `address` method on an instance of the `gitlab` component.

## Running tests with Omnibus Configured

All Omnibus Configurators can be called by passing arguments into the `gitlab-qa` executable.

```shell
exe/gitlab-qa Test::Instance::Image EE --omnibus-config registry
```

Notes:

- `--omnibus-config registry` must match the name of the Omnibus Configurator Class name (`Runtime::OmnibusConfigurations::Registry`), but lowercase.
- If the Configurator Class name contains several words, the argument will be named the same, but snake cased. E.g. `--omnibus-config some_class` matches `SomeClass`, `--omnibus-config some_other_class` matches `SomeOtherClass`.
- The Omnibus GitLab Instance will have the configuration from `Default` and `Registry` (in that order) put into `/etc/gitlab/gitlab.rb` and GitLab QA will proceed to run the tests.
- If a specified Omnibus Configuration does not exist, GitLab QA will raise an error and fail immediately.

## Further reading

### Multiple Configurators

Multiple Configurators may be specified and the order will be preserved in which the arguments were passed.

E.g., given the arguments:

```ruby
exe/gitlab-qa Test::Instance::Image EE --omnibus-config packages,registry
# or
exe/gitlab-qa Test::Instance::Image EE --omnibus-config packages --omnibus-config registry
```

Omnibus will be configured in the order they appear.

```ruby
# /etc/gitlab/gitlab.rb
#=> Runtime::OmnibusConfiguration::Default#configuration
#=> Runtime::OmnibusConfiguration::Packages#configuration
#=> Runtime::OmnibusConfiguration::Registry#configuration
```

The order is also preserved for Sidecar containers.  If the `Packages` and `Registry` Configurators each prepare a sidecar container, they will be spun up in order from first to last.

### Adding one-off configurations

#### From a new Scenario::Template

If it is required to create a new `Scenario::Template`, you may add new Configurations to the respective GitLab Instances by invoking `omnibus_configuration#<<`

```ruby
# Geo example

Component::Gitlab.perform do |primary|
  primary.omnibus_configuration << <<~OMNIBUS
    geo_primary_role['enable'] = true
  OMNIBUS

  primary.instance do
    Component::Gitlab.perform do |secondary|
      secondary.omnibus_configuration << <<~OMNIBUS
        geo_secondary_role['enable'] = true
      OMNIBUS
    end
  end
end
```

Notes:

- The `primary` instance will be configured using the `Runtime::OmnibusConfigurations::Default` configuration, *then* `geo_primary_role['enable'] = true` will be affixed afterwards.
- The `secondary` instance will be configured using the `Runtime::OmnibusConfigurations::Default` configuration, *then* `geo_secondary_role['enable'] = true` will be affixed afterwards.

#### From Component::Gitlab

Any additional one-off configurations needing to be added may be directly appended to `@omnibus_configuration` as such:

```ruby
disable_animations = true

@omnibus_configuration << "gitlab_rails['gitlab_disable_animations'] = true" if disable_animations
```

This will add the specified configuration **after** what has already been specified beforehand (Configurators or Default configurations).

Note:

- If there is no issue appending this configuration to the **rest** of the GitLab Instances that might be spun up, you can add this
  to the global Omnibus Configuration. E.g., use `Runtime::Scenario.omnibus_configuration << ...` instead of `@omnibus_configuration << ...`

#### Difference between Runtime::Scenario.omnibus_configuration and Gitlab#omnibus_configuration

Generally, while running GitLab QA, only one GitLab instance is necessary. `Runtime::Scenario.omnibus_configuration` contains all of the global
Omnibus configurations required for this one environment.  This also contains the configuration for any other GitLab instance.

When multiple GitLab Instances are required, `@omnibus_configuration#<<` is preferred over `Runtime::Scenario.omnibus_configuration#<<` since the First Instance might require
one Omnibus configuration that might be unneccesary or Invalid for the Second Instance.

#### Load order and precedence

1. `Runtime::OmnibusConfigurations::Default`
1. `Runtime::OmnibusConfigurations::[A,B,...]` where `A` and `B` are Configurators specified through the positional arguments `--a --b`
1. Custom written `Scenario::Template` (such as `Test::Integration::Geo`)
1. `lib/gitlab/qa/component/gitlab.rb`

From top to bottom, configurations will be loaded and any configurations that are superseded, will take precedence over the one before it, and so on.

### Executing arbitrary shell commands within the GitLab Instance

Sometimes it's necessary to execute arbitrary commands within the GitLab instance before the tests start.

You may specify these commands by overriding the `exec_commands` method within the Configurator.

```ruby
class Registry < Default
  def configuration
    # configuration
  end
  
  def exec_commands
    [
      'cp /etc/gitlab/gitlab.rb /etc/gitlab/gitlab.bak.rb',
      'rm /etc/gitlab/gitlab.bak.rb'
    ]
  end
end
```
