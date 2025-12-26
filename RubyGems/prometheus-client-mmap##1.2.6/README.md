# Prometheus Ruby Mmap Client

This Prometheus library is fork of [Prometheus Ruby Client](https://github.com/prometheus/client_ruby)
that uses mmap'ed files to share metrics from multiple processes.
This allows efficient metrics processing for Ruby web apps running in multiprocess setups like Unicorn.

A suite of instrumentation metric primitives for Ruby that can be exposed
through a HTTP interface. Intended to be used together with a
[Prometheus server][1].

[![Gem Version][4]](http://badge.fury.io/rb/prometheus-client-mmap)
[![Build Status][3]](https://gitlab.com/gitlab-org/prometheus-client-mmap/commits/master)

## Installation

prometheus-client-mmap ships with [precompiled native gems](https://rubygems.org/gems/prometheus-client-mmap).
Install the gem via:

```shell
gem install prometheus-client-mmap
```

### Requirements for building from source

Building from source requires a number of dependencies:

* Rust v1.65+
* clang 5.0 or higher for [bindgen](https://rust-lang.github.io/rust-bindgen/requirements.html)
* `make`
* A C compiler (for legacy extension, which will be removed soon)

## Usage

### Overview

```ruby
require 'prometheus/client'

# returns a default registry
prometheus = Prometheus::Client.registry

# create a new counter metric
http_requests = Prometheus::Client::Counter.new(:http_requests, 'A counter of HTTP requests made')
# register the metric
prometheus.register(http_requests)

# equivalent helper function
http_requests = prometheus.counter(:http_requests, 'A counter of HTTP requests made')

# start using the counter
http_requests.increment
```

## Rust extension

This gem now uses a rewritten Rust extension instead of C.
implementation that reads the metric files and outputs the multiprocess
metrics to text. This implementation is significantly faster than the C extension.

### Rack middleware

There are two [Rack][2] middlewares available, one to expose a metrics HTTP
endpoint to be scraped by a prometheus server ([Exporter][9]) and one to trace all HTTP
requests ([Collector][10]).

It's highly recommended to enable gzip compression for the metrics endpoint,
for example by including the `Rack::Deflater` middleware.

```ruby
# config.ru

require 'rack'
require 'prometheus/client/rack/collector'
require 'prometheus/client/rack/exporter'

use Rack::Deflater, if: ->(env, status, headers, body) { body.any? && body[0].length > 512 }
use Prometheus::Client::Rack::Collector
use Prometheus::Client::Rack::Exporter

run ->(env) { [200, {'Content-Type' => 'text/html'}, ['OK']] }
```

Start the server and have a look at the metrics endpoint:
[http://localhost:5000/metrics](http://localhost:5000/metrics).

For further instructions and other scripts to get started, have a look at the
integrated [example application](examples/rack/README.md).

### Pushgateway

The Ruby client can also be used to push its collected metrics to a
[Pushgateway][8]. This comes in handy with batch jobs or in other scenarios
where it's not possible or feasible to let a Prometheus server scrape a Ruby
process. TLS and HTTP basic authentication are supported.

```ruby
require 'prometheus/client'
require 'prometheus/client/push'

registry = Prometheus::Client.registry
# ... register some metrics, set/increment/observe/etc. their values

# push the registry state to the default gateway
Prometheus::Client::Push.new(job: 'my-batch-job').add(registry)

# optional: specify a grouping key that uniquely identifies a job instance, and gateway.
#
# Note: the labels you use in the grouping key must not conflict with labels set on the
# metrics being pushed. If they do, an error will be raised.
Prometheus::Client::Push.new(
  job: 'my-batch-job',
  gateway: 'https://example.domain:1234',
  grouping_key: { instance: 'some-instance', extra_key: 'foobar' }
).add(registry)

# If you want to replace any previously pushed metrics for a given grouping key,
# use the #replace method.
#
# Unlike #add, this will completely replace the metrics under the specified grouping key
# (i.e. anything currently present in the pushgateway for the specified grouping key, but
# not present in the registry for that grouping key will be removed).
#
# See https://github.com/prometheus/pushgateway#put-method for a full explanation.
Prometheus::Client::Push.new(job: 'my-batch-job').replace(registry)

# If you want to delete all previously pushed metrics for a given grouping key,
# use the #delete method.
Prometheus::Client::Push.new(job: 'my-batch-job').delete
```

## Metrics

The following metric types are currently supported.

### Counter

Counter is a metric that exposes merely a sum or tally of things.

```ruby
counter = Prometheus::Client::Counter.new(:service_requests_total, '...')

# increment the counter for a given label set
counter.increment({ service: 'foo' })

# increment by a given value
counter.increment({ service: 'bar' }, 5)

# get current value for a given label set
counter.get({ service: 'bar' })
# => 5
```

### Gauge

Gauge is a metric that exposes merely an instantaneous value or some snapshot
thereof.

```ruby
gauge = Prometheus::Client::Gauge.new(:room_temperature_celsius, '...')

# set a value
gauge.set({ room: 'kitchen' }, 21.534)

# retrieve the current value for a given label set
gauge.get({ room: 'kitchen' })
# => 21.534
```

### Histogram

A histogram samples observations (usually things like request durations or
response sizes) and counts them in configurable buckets. It also provides a sum
of all observed values.

```ruby
histogram = Prometheus::Client::Histogram.new(:service_latency_seconds, '...')

# record a value
histogram.observe({ service: 'users' }, Benchmark.realtime { service.call(arg) })

# retrieve the current bucket values
histogram.get({ service: 'users' })
# => { 0.005 => 3, 0.01 => 15, 0.025 => 18, ..., 2.5 => 42, 5 => 42, 10 = >42 }
```

### Summary

Summary, similar to histograms, is an accumulator for samples. It captures
Numeric data and provides an efficient percentile calculation mechanism.

```ruby
summary = Prometheus::Client::Summary.new(:service_latency_seconds, '...')

# record a value
summary.observe({ service: 'database' }, Benchmark.realtime { service.call() })

# retrieve the current quantile values
summary.get({ service: 'database' })
# => { 0.5 => 0.1233122, 0.9 => 3.4323, 0.99 => 5.3428231 }
```

## Configuration

### Memory mapped files storage location

Set `prometheus_multiproc_dir` environment variable to the path where you want metric files to be stored. Example:

```
prometheus_multiproc_dir=/tmp
```

## Pitfalls

### PID cardinality

In multiprocess setup e.g. running under Unicorn or Puma, having worker process restart often
can lead to performance problems when proccesing metric files. By default each process using
Prometheus metrics will create a set of files based on that process PID. With high worker
churn this will lead to creation of thousands of files and in turn will cause very noticable
slowdown when displaying metrics

To reduce this problem, a surrogate process id can be used. Set of all such IDs needs
have low cardinality, and each process id must be unique among all running process.

For Unicorn and Puma a worker id/number can be used to greatly speedup the metrics rendering.

If you are using Unicorn, add this line to your `configure` block:

```ruby
  config.pid_provider = Prometheus::Client::Support::Unicorn.method(:worker_pid_provider)
```

If you are using Puma, add this line to your `configure` block:

```ruby
  config.pid_provider = Prometheus::Client::Support::Puma.method(:worker_pid_provider)
```

## Tools

### `bin/parse`

This command can be used to parse metric files located on the filesystem just like a metric exporter would.
It outputs either `json` formatted raw data or digested data in prometheus `text` format.

#### Usage:

```bash
$ ./bin/parse -h
Usage: parse [options] files...
    -t, --to-prometheus-text         format output using Prometheus text formatter
    -p, --profile                    enable profiling
    -h, --help                       Show this message
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Releasing a new version

To release a new version:

1. Update `lib/prometheus/client/version.rb` with the version number.
1. Update `CHANGELOG.md` with the changes in the release.
1. Create a merge request and merge it to `master`.
1. Push a new tag to the repository.

The new version with precompiled, native gems will automatically be
published to [RubyGems](https://rubygems.org/gems/prometheus-client-mmap) when the
pipeline for the tag completes.

[1]: https://github.com/prometheus/prometheus
[2]: http://rack.github.io/
[3]: https://gitlab.com/gitlab-org/prometheus-client-mmap/badges/master/pipeline.svg
[4]: https://badge.fury.io/rb/prometheus-client.svg
[8]: https://github.com/prometheus/pushgateway
[9]: lib/prometheus/client/rack/exporter.rb
[10]: lib/prometheus/client/rack/collector.rb
