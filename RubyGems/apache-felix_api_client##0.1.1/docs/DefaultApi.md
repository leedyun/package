# ApacheFelix::DefaultApi

All URIs are relative to *http://localhost:8080/system/console*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bundles**](DefaultApi.md#bundles) | **GET** /bundles.json | Bundles list


# **bundles**
> BundleList bundles

Bundles list

List all the bundles in the Felix system. Properties for a bundle will not be populated.

### Example
```ruby
# load the gem
require 'apache_felix_api_client'
# setup authorization
ApacheFelix.configure do |config|
  # Configure HTTP basic authorization: basic
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = ApacheFelix::DefaultApi.new

begin
  #Bundles list
  result = api_instance.bundles
  p result
rescue ApacheFelix::ApiError => e
  puts "Exception when calling DefaultApi->bundles: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BundleList**](BundleList.md)

### Authorization

[basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



