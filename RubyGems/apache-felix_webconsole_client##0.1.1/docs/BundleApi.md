# ApacheFelix::BundleApi

All URIs are relative to *http://localhost:8080/system/console*

Method | HTTP request | Description
------------- | ------------- | -------------
[**info**](BundleApi.md#info) | **GET** /bundles/{bundleId}.json | Bundle Info
[**install**](BundleApi.md#install) | **POST** /bundles/install | Upload a bundle.
[**list**](BundleApi.md#list) | **GET** /bundles.json | List bundles
[**modify**](BundleApi.md#modify) | **POST** /bundles/{bundleSymbolicName} | Modify bundles operation.
[**refresh_packages**](BundleApi.md#refresh_packages) | **POST** /bundles | Modify bundles operation.


# **info**
> BundleList info(bundle_id)

Bundle Info

Display all information about a bundle, including properties. The returned list will contain one entry, the requested bundle. (See org.apache.felix.webconsole.internal.core.BundlesServlet.java)

### Example
```ruby
# load the gem
require 'apache_felix_webconsole_client'
# setup authorization
ApacheFelix.configure do |config|
  # Configure HTTP basic authorization: basic
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = ApacheFelix::BundleApi.new

bundle_id = "bundle_id_example" # String | The symbolic name or id of the bundle.


begin
  #Bundle Info
  result = api_instance.info(bundle_id)
  p result
rescue ApacheFelix::ApiError => e
  puts "Exception when calling BundleApi->info: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bundle_id** | **String**| The symbolic name or id of the bundle. | 

### Return type

[**BundleList**](BundleList.md)

### Authorization

[basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



# **install**
> install(bundlefile, action, opts)

Upload a bundle.

Install the provided bundle. (See org.apache.felix.webconsole.internal.core.BundlesServlet.java)

### Example
```ruby
# load the gem
require 'apache_felix_webconsole_client'
# setup authorization
ApacheFelix.configure do |config|
  # Configure HTTP basic authorization: basic
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = ApacheFelix::BundleApi.new

bundlefile = File.new("/path/to/file.txt") # File | The bundle to upload.

action = "action_example" # String | The action to execute. Only allowed value is 'install', must be provided. Limitation of Swagger.

opts = { 
  bundlestart: true, # BOOLEAN | Flag to indicate whether or not bundle should be started.
  bundlestartlevel: 56, # Integer | The start level of the provided bundle.
  refresh_packages: true # BOOLEAN | Flag to indicate whether or not to refresh all pacakges once installed.
}

begin
  #Upload a bundle.
  api_instance.install(bundlefile, action, opts)
rescue ApacheFelix::ApiError => e
  puts "Exception when calling BundleApi->install: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bundlefile** | **File**| The bundle to upload. | 
 **action** | **String**| The action to execute. Only allowed value is &#39;install&#39;, must be provided. Limitation of Swagger. | 
 **bundlestart** | **BOOLEAN**| Flag to indicate whether or not bundle should be started. | [optional] 
 **bundlestartlevel** | **Integer**| The start level of the provided bundle. | [optional] 
 **refresh_packages** | **BOOLEAN**| Flag to indicate whether or not to refresh all pacakges once installed. | [optional] 

### Return type

nil (empty response body)

### Authorization

[basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: Not defined



# **list**
> BundleList list

List bundles

List all the bundles in the Felix system. Properties for a bundle will not be populated. (See org.apache.felix.webconsole.internal.core.BundlesServlet.java)

### Example
```ruby
# load the gem
require 'apache_felix_webconsole_client'
# setup authorization
ApacheFelix.configure do |config|
  # Configure HTTP basic authorization: basic
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = ApacheFelix::BundleApi.new

begin
  #List bundles
  result = api_instance.list
  p result
rescue ApacheFelix::ApiError => e
  puts "Exception when calling BundleApi->list: #{e}"
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



# **modify**
> BundleState modify(bundle_symbolic_name, action)

Modify bundles operation.

Take action on a bundle; start, stop, update, refresh, uninstall. (See org.apache.felix.webconsole.internal.core.BundlesServlet.java)

### Example
```ruby
# load the gem
require 'apache_felix_webconsole_client'
# setup authorization
ApacheFelix.configure do |config|
  # Configure HTTP basic authorization: basic
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = ApacheFelix::BundleApi.new

bundle_symbolic_name = "bundle_symbolic_name_example" # String | The OSGi Symbolic name of the bundle.

action = "action_example" # String | The action to execute.


begin
  #Modify bundles operation.
  result = api_instance.modify(bundle_symbolic_name, action)
  p result
rescue ApacheFelix::ApiError => e
  puts "Exception when calling BundleApi->modify: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bundle_symbolic_name** | **String**| The OSGi Symbolic name of the bundle. | 
 **action** | **String**| The action to execute. | 

### Return type

[**BundleState**](BundleState.md)

### Authorization

[basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: application/x-www-form-urlencoded
 - **Accept**: Not defined



# **refresh_packages**
> BundleList refresh_packages(action)

Modify bundles operation.

Take action on all bundles - refresh packages. (See org.apache.felix.webconsole.internal.core.BundlesServlet.java)

### Example
```ruby
# load the gem
require 'apache_felix_webconsole_client'
# setup authorization
ApacheFelix.configure do |config|
  # Configure HTTP basic authorization: basic
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = ApacheFelix::BundleApi.new

action = "action_example" # String | The action to execute. Only allowed value is 'refreshPackages', must be provided. Limitation of Swagger.


begin
  #Modify bundles operation.
  result = api_instance.refresh_packages(action)
  p result
rescue ApacheFelix::ApiError => e
  puts "Exception when calling BundleApi->refresh_packages: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **action** | **String**| The action to execute. Only allowed value is &#39;refreshPackages&#39;, must be provided. Limitation of Swagger. | 

### Return type

[**BundleList**](BundleList.md)

### Authorization

[basic](../README.md#basic)

### HTTP request headers

 - **Content-Type**: application/x-www-form-urlencoded
 - **Accept**: Not defined



