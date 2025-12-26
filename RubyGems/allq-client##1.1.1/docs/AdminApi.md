# Allq::AdminApi

All URIs are relative to *http://localhost:8090*

Method | HTTP request | Description
------------- | ------------- | -------------
[**stats_get**](AdminApi.md#stats_get) | **GET** /stats | Stats
[**update_servers_put**](AdminApi.md#update_servers_put) | **PUT** /update_servers | Reset Server Urls


# **stats_get**
> Array&lt;StatsResults&gt; stats_get

Stats

Get Stats

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::AdminApi.new

begin
  #Stats
  result = api_instance.stats_get
  p result
rescue Allq::ApiError => e
  puts "Exception when calling AdminApi->stats_get: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Array&lt;StatsResults&gt;**](StatsResults.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_servers_put**
> BasicResponse update_servers_put(server_urls)

Reset Server Urls

Change server URLs

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::AdminApi.new

server_urls = "server_urls_example" # String | Comma Separated List URL String


begin
  #Reset Server Urls
  result = api_instance.update_servers_put(server_urls)
  p result
rescue Allq::ApiError => e
  puts "Exception when calling AdminApi->update_servers_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **server_urls** | **String**| Comma Separated List URL String | 

### Return type

[**BasicResponse**](BasicResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



