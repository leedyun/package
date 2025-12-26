# ApacheSling::DefaultApi

All URIs are relative to *http://localhost:8080/*

Method | HTTP request | Description
------------- | ------------- | -------------
[**resource**](DefaultApi.md#resource) | **GET** /{resource}.json | Get a resource


# **resource**
> Hash&lt;String, String&gt; resource(resource)

Get a resource

Returns a representation of a Sling resource.

### Example
```ruby
# load the gem
require 'apache_sling_api_client'
# setup authorization
ApacheSling.configure do |config|
  # Configure HTTP basic authorization: basic
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = ApacheSling::DefaultApi.new

resource = "resource_example" # String | The relative path to the resource.


begin
  #Get a resource
  result = api_instance.resource(resource)
  p result
rescue ApacheSling::ApiError => e
  puts "Exception when calling DefaultApi->resource: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **resource** | **String**| The relative path to the resource. | 

### Return type

**Hash&lt;String, String&gt;**

### Authorization

[basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



