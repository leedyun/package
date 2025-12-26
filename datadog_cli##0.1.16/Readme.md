# datadog-cli

Track your datadog monitors.

When you have several environments and want to consitently guarantee alerts
across them it's better to have templates and extract the differences between
them to variables.


## Installation

```
gem install datadog-cli
```


## Usage

Right now the only supported Datadog feature are monitors with the
`monitor` subcommand. Adding a `dashboard` subcommand shouldn't be
the hardest thing.

```
$ ./bin/datadog monitor
Commands:
  datadog monitor check PATH                      # Checks if monitor(s) from PATH exist
  datadog monitor download DIR [FILTER] [INVERT]  # Downloads all monitors that match FILTER
  datadog monitor generate PATH [DIR] [VARS]      # Renders template(s) from PATH into DIR with a VARS file
  datadog monitor help [COMMAND]                  # Describe subcommands or one specific subcommand
  datadog monitor ls [FILTER] [EXCLUDE]           # Lists all monitors that match FILTER
  datadog monitor render PATH [VARS]              # Renders template(s) from PATH with a VARS file
  datadog monitor update PATH                     # Updates or creates monitor(s) from PATH

Options:
  [--vars=VARS]
```

Check https://github.schibsted.io/spt-payment/datadog-monitors for a real example
of how templates and variables can be structured.

The required access to the Datadog API can be set by either env vars or using a
configuration file. The env vars are `DATADOG_API_KEY` and `DATADOG_APP_KEY`.

If neither env vars are set the code does a file lookup. **In order**:

- Currentl working directory level: `./datadog-cli.yaml`.
- User level: (your home directory): `~/.datadog-cli.yaml`.
- System level: `/etc/datadog-cli.yaml`

The first found file prevails. There's no merging involved. The content of the file
should look like:

```yaml
---
creds:
  api_key: 123456789-123456789-123456789-12
  app_key: 123456789-123456789-123456789-1234567890
```


## What makes this different

It allows to:

  - generate json monitors files from rendering templates against variables
  - have as many variables files as needed as a way to tweak thresholds per
    env. You can be lazy and use the `import: file.yaml` to det defaults.
  - create/update monitors from an arbitrary folder

These steps combined allows people to grab monitors from one environment and
apply to another.

## What this doesn't do

  - This tool does not delete existing monitors. That's manual work left up
    to you. The tool does a look up based on the monitor title to decide if
    it will create or update. This can still mess up current monitors so it's
    not a bad idea to download all current monitors, even if for archival
    purposes.

  - This tools uses the `liquid` gem which unfortunately does not support
    recursive variable resolution like ansible brilliantly does.
