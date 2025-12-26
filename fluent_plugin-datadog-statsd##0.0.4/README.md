# fluentd-plugin-datadog-statsd

Fluend output plugin for Dogstatsd.

[![Build Status](https://travis-ci.org/kikusu/fluent-plugin-datadog-statsd.svg?branch=master)](https://travis-ci.org/kikusu/fluent-plugin-datadog-statsd)
[![Gem Version](https://badge.fury.io/rb/fluent-plugin-datadog-statsd.svg)](https://badge.fury.io/rb/fluent-plugin-datadog-statsd)

## Requirements
- fluentd >= 0.14

## Configuration
```
<match datadog.*>
 @type datadog_statsd

 # option: datadog statsd host, port
 host 127.0.0.1   (default: see dogstatsd-ruby)
 port 8125        (default: see dogstatsd-ruby)

 # required: metric type of datadog.
 # e.g. increment, decrement, count, gauge, histgram, timing, event
 metric_type increment

 # option: tag of datadog.
 tags [ "tag1:tag", "tag2:tag" ]

 # option: add fluentd_worker_id tag to tags
 add_fluentd_worker_id_to_tags true

 # required when metric_type is not event
 <metric>
    # required: metric name of datadog
    name test.datadog

    # required when metric_type in (count, gauge, histgram, timing)
    value 1
 </metric>

 # required when metric_type is event
 # see: http://docs.datadoghq.com/guides/dogstatsd/#events
 <evnet>
    # required
    title
    text

    # option
    aggregation_key
    alert_type
    date_happened
    priority
    source_type_name
 </event>

</match>
```

### using template

In this plugin you can use templates.
Implemented by `Fluent::Plugin::Output#extract_placeholders`.

#### Available Tags
- `${tag}`, `${tag[0]}`, `${tag[1]}`, ...
- `${record_key}`

```
<match datadog.*>
 @type datadog_statsd

 metric_type increment
 tags [ "tag:${tag}"]
 <metric>
    name ${metric_name}
 </metric>

 # add placeholder key
 <buffer ["tag", "metric_name"]>
 </buffer>
</match>
```

```
# src
fluentd_tag datadog.test
fluentd_record {"metric_name": "count.error_log"}
=>
# dest
metric_type increment
tags ["tag:datadog.test"}
<metric>
  name count.error_log
</metric>
```
