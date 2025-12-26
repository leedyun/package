# apptuit-fluent-plugin
[![Build Status](https://travis-ci.com/hari9973/apptuit-fluent-plugin.svg?branch=master)](https://travis-ci.com/hari9973/apptuit-fluent-plugin)
[![codecov](https://codecov.io/gh/hari9973/apptuit-fluent-plugin/branch/master/graph/badge.svg)](https://codecov.io/gh/hari9973/apptuit-fluent-plugin)
[![PyPI](https://img.shields.io/gem/v/apptuit-fluent-plugin.svg)](https://rubygems.org/gems/apptuit-fluent-plugin)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[Fluentd](https://fluentd.org/) filter plugin to get the fingerprint of error messages

It is a simple filter plugin for fluentd and it is used to generate SHA1 hash for error messages.

## Installation

### RubyGems

Install with gem or td-agent-gem as below

```bash
# for system installed fluentd
$ gem install apptuit-fluent-plugin
```
```bash
# for td-agent
$ sudo td-agent-gem install apptuit-fluent-plugin
```
## Usage
```
<filter>
  @type apptuit
  lang python
  syslog true
  error_msg_tag error_message
  fingerprint_name fingerprint
  exception_name error_exception
</filter>
```

### Configuration

* **lang (string) (required)**
  * This config parameter specifies the language of the error message to be parsed and generate fingerprint

    The supported values of lang are

           1.  python
           2.  java
           3.  nodejs

* **syslog (bool) (optional)**
  * This is boolean config parameter and its default value is `false`.
    
    This specifies whether the given error message is from syslog or not.It will be used to convert some octal converted strings back to strings

    eg:- `\n` is converted to `#012` etc

* **error_msg_tag (string) (optional)**
  * This config parameter is used to give the tag name of the error message.

    Default value: `message`.
    
## Result
If the provided message is valid then the record is added with an two new tags that is `error` and `error_hash` and the can be specified in labels section for exposing in metrics
```
demo_error_count{error_exception="NameError",fingerprint="d85a855fe660c936ea88492a6bd4c3d5f4a448cf"} 1.0
```

## LICENSE
```
Copyright 2017 Agilx, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

