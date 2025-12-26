# AliseeksApi::ProductsApi

All URIs are relative to *https://api.aliseeks.com/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_product**](ProductsApi.md#get_product) | **POST** /products | Get products details as an aggregated request from AliExpress in realtime. 
[**get_product_details**](ProductsApi.md#get_product_details) | **POST** /products/details | Gets product details from AliExpress in realtime. 
[**get_product_html_description**](ProductsApi.md#get_product_html_description) | **POST** /products/description/html | Get product HTML description from AliExpress in realtime. 
[**get_product_reviews**](ProductsApi.md#get_product_reviews) | **POST** /products/reviews | Get product reviews from AliExpress in realtime 
[**get_product_shipping**](ProductsApi.md#get_product_shipping) | **POST** /products/shipping | Gets product shipping information AliExpress in realtime. 
[**get_product_skus**](ProductsApi.md#get_product_skus) | **POST** /products/variations | Gets product skus / variation information from AliExpress in realtime. 


# **get_product**
> Product get_product(opts)

Get products details as an aggregated request from AliExpress in realtime. 

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

api_instance = AliseeksApi::ProductsApi.new
opts = {
  product_request: AliseeksApi::ProductRequest.new # ProductRequest | The request body of get product 
}

begin
  #Get products details as an aggregated request from AliExpress in realtime. 
  result = api_instance.get_product(opts)
  p result
rescue AliseeksApi::ApiError => e
  puts "Exception when calling ProductsApi->get_product: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **product_request** | [**ProductRequest**](ProductRequest.md)| The request body of get product  | [optional] 

### Return type

[**Product**](Product.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_product_details**
> ProductDetail get_product_details(product_details_request)

Gets product details from AliExpress in realtime. 

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

api_instance = AliseeksApi::ProductsApi.new
product_details_request = AliseeksApi::ProductDetailsRequest.new # ProductDetailsRequest | The request body to get product details 

begin
  #Gets product details from AliExpress in realtime. 
  result = api_instance.get_product_details(product_details_request)
  p result
rescue AliseeksApi::ApiError => e
  puts "Exception when calling ProductsApi->get_product_details: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **product_details_request** | [**ProductDetailsRequest**](ProductDetailsRequest.md)| The request body to get product details  | 

### Return type

[**ProductDetail**](ProductDetail.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_product_html_description**
> ProductHtmlDescription get_product_html_description(product_html_description_request)

Get product HTML description from AliExpress in realtime. 

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

api_instance = AliseeksApi::ProductsApi.new
product_html_description_request = AliseeksApi::ProductHtmlDescriptionRequest.new # ProductHtmlDescriptionRequest | The request body to get product html description 

begin
  #Get product HTML description from AliExpress in realtime. 
  result = api_instance.get_product_html_description(product_html_description_request)
  p result
rescue AliseeksApi::ApiError => e
  puts "Exception when calling ProductsApi->get_product_html_description: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **product_html_description_request** | [**ProductHtmlDescriptionRequest**](ProductHtmlDescriptionRequest.md)| The request body to get product html description  | 

### Return type

[**ProductHtmlDescription**](ProductHtmlDescription.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_product_reviews**
> ProductReviews get_product_reviews(product_reviews_request)

Get product reviews from AliExpress in realtime 

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

api_instance = AliseeksApi::ProductsApi.new
product_reviews_request = AliseeksApi::ProductReviewsRequest.new # ProductReviewsRequest | The request body to get product reviews 

begin
  #Get product reviews from AliExpress in realtime 
  result = api_instance.get_product_reviews(product_reviews_request)
  p result
rescue AliseeksApi::ApiError => e
  puts "Exception when calling ProductsApi->get_product_reviews: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **product_reviews_request** | [**ProductReviewsRequest**](ProductReviewsRequest.md)| The request body to get product reviews  | 

### Return type

[**ProductReviews**](ProductReviews.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_product_shipping**
> ProductShipping get_product_shipping(product_shipping_request)

Gets product shipping information AliExpress in realtime. 

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

api_instance = AliseeksApi::ProductsApi.new
product_shipping_request = AliseeksApi::ProductShippingRequest.new # ProductShippingRequest | The request body to get product shipping 

begin
  #Gets product shipping information AliExpress in realtime. 
  result = api_instance.get_product_shipping(product_shipping_request)
  p result
rescue AliseeksApi::ApiError => e
  puts "Exception when calling ProductsApi->get_product_shipping: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **product_shipping_request** | [**ProductShippingRequest**](ProductShippingRequest.md)| The request body to get product shipping  | 

### Return type

[**ProductShipping**](ProductShipping.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_product_skus**
> ProductSkus get_product_skus(product_skus_request)

Gets product skus / variation information from AliExpress in realtime. 

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

api_instance = AliseeksApi::ProductsApi.new
product_skus_request = AliseeksApi::ProductSkusRequest.new # ProductSkusRequest | The request body to get product skus / variations 

begin
  #Gets product skus / variation information from AliExpress in realtime. 
  result = api_instance.get_product_skus(product_skus_request)
  p result
rescue AliseeksApi::ApiError => e
  puts "Exception when calling ProductsApi->get_product_skus: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **product_skus_request** | [**ProductSkusRequest**](ProductSkusRequest.md)| The request body to get product skus / variations  | 

### Return type

[**ProductSkus**](ProductSkus.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



