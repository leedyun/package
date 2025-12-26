# AliseeksApi::SearchApi

All URIs are relative to *https://api.aliseeks.com/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**realtime_search**](SearchApi.md#realtime_search) | **POST** /search/realtime | Searches AliExpress in realtime 
[**search**](SearchApi.md#search) | **POST** /search | Searches AliExpress in non-realtime. Uses the Aliseeks.com datasource which is continually updated from AliExpress. 
[**search_best_selling**](SearchApi.md#search_best_selling) | **POST** /search/bestSelling | Retrieves best selling products from AliExpress in realtime. 
[**search_by_image**](SearchApi.md#search_by_image) | **POST** /search/image | Searches AliExpress by image in realtime. 
[**upload_image_by_url**](SearchApi.md#upload_image_by_url) | **POST** /search/image/upload | Uploads an image to AliExpress to allow it to be used in the image search endpoint 


# **realtime_search**
> RealtimeSearchResponse realtime_search(realtime_search_request)

Searches AliExpress in realtime 

### Example
```ruby
# load the gem
require 'aliseeks_api'
# setup authorization
AliseeksApi.configure do |config|
  # Configure API key authorization: ApiKeyAuth
  config.api_key['X-API-CLIENT-ID'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['X-API-CLIENT-ID'] = 'Bearer'
end

api_instance = AliseeksApi::SearchApi.new
realtime_search_request = AliseeksApi::RealtimeSearchRequest.new # RealtimeSearchRequest | Realtime search request body 

begin
  #Searches AliExpress in realtime 
  result = api_instance.realtime_search(realtime_search_request)
  p result
rescue AliseeksApi::ApiError => e
  puts "Exception when calling SearchApi->realtime_search: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **realtime_search_request** | [**RealtimeSearchRequest**](RealtimeSearchRequest.md)| Realtime search request body  | 

### Return type

[**RealtimeSearchResponse**](RealtimeSearchResponse.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **search**
> SearchResponse search(search_request)

Searches AliExpress in non-realtime. Uses the Aliseeks.com datasource which is continually updated from AliExpress. 

### Example
```ruby
# load the gem
require 'aliseeks_api'
# setup authorization
AliseeksApi.configure do |config|
  # Configure API key authorization: ApiKeyAuth
  config.api_key['X-API-CLIENT-ID'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['X-API-CLIENT-ID'] = 'Bearer'
end

api_instance = AliseeksApi::SearchApi.new
search_request = AliseeksApi::SearchRequest.new # SearchRequest | Search request body 

begin
  #Searches AliExpress in non-realtime. Uses the Aliseeks.com datasource which is continually updated from AliExpress. 
  result = api_instance.search(search_request)
  p result
rescue AliseeksApi::ApiError => e
  puts "Exception when calling SearchApi->search: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search_request** | [**SearchRequest**](SearchRequest.md)| Search request body  | 

### Return type

[**SearchResponse**](SearchResponse.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **search_best_selling**
> BestSellingSearchResponse search_best_selling(best_selling_search_request)

Retrieves best selling products from AliExpress in realtime. 

### Example
```ruby
# load the gem
require 'aliseeks_api'
# setup authorization
AliseeksApi.configure do |config|
  # Configure API key authorization: ApiKeyAuth
  config.api_key['X-API-CLIENT-ID'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['X-API-CLIENT-ID'] = 'Bearer'
end

api_instance = AliseeksApi::SearchApi.new
best_selling_search_request = AliseeksApi::BestSellingSearchRequest.new # BestSellingSearchRequest | Search best selling request body 

begin
  #Retrieves best selling products from AliExpress in realtime. 
  result = api_instance.search_best_selling(best_selling_search_request)
  p result
rescue AliseeksApi::ApiError => e
  puts "Exception when calling SearchApi->search_best_selling: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **best_selling_search_request** | [**BestSellingSearchRequest**](BestSellingSearchRequest.md)| Search best selling request body  | 

### Return type

[**BestSellingSearchResponse**](BestSellingSearchResponse.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **search_by_image**
> ImageSearchResponse search_by_image(image_search_request)

Searches AliExpress by image in realtime. 

### Example
```ruby
# load the gem
require 'aliseeks_api'
# setup authorization
AliseeksApi.configure do |config|
  # Configure API key authorization: ApiKeyAuth
  config.api_key['X-API-CLIENT-ID'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['X-API-CLIENT-ID'] = 'Bearer'
end

api_instance = AliseeksApi::SearchApi.new
image_search_request = AliseeksApi::ImageSearchRequest.new # ImageSearchRequest | The image search request body 

begin
  #Searches AliExpress by image in realtime. 
  result = api_instance.search_by_image(image_search_request)
  p result
rescue AliseeksApi::ApiError => e
  puts "Exception when calling SearchApi->search_by_image: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **image_search_request** | [**ImageSearchRequest**](ImageSearchRequest.md)| The image search request body  | 

### Return type

[**ImageSearchResponse**](ImageSearchResponse.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **upload_image_by_url**
> UploadImageResponse upload_image_by_url(upload_image_by_url_request)

Uploads an image to AliExpress to allow it to be used in the image search endpoint 

### Example
```ruby
# load the gem
require 'aliseeks_api'
# setup authorization
AliseeksApi.configure do |config|
  # Configure API key authorization: ApiKeyAuth
  config.api_key['X-API-CLIENT-ID'] = 'YOUR API KEY'
  # Uncomment the following line to set a prefix for the API key, e.g. 'Bearer' (defaults to nil)
  #config.api_key_prefix['X-API-CLIENT-ID'] = 'Bearer'
end

api_instance = AliseeksApi::SearchApi.new
upload_image_by_url_request = AliseeksApi::UploadImageByUrlRequest.new # UploadImageByUrlRequest | The upload image by url request body 

begin
  #Uploads an image to AliExpress to allow it to be used in the image search endpoint 
  result = api_instance.upload_image_by_url(upload_image_by_url_request)
  p result
rescue AliseeksApi::ApiError => e
  puts "Exception when calling SearchApi->upload_image_by_url: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **upload_image_by_url_request** | [**UploadImageByUrlRequest**](UploadImageByUrlRequest.md)| The upload image by url request body  | 

### Return type

[**UploadImageResponse**](UploadImageResponse.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



