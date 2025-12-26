# AliseeksApi::RealtimeSearchRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**category** | **Integer** | The category to filter by  | [optional] 
**text** | **String** | The text to filter by  | [optional] 
**price_range** | [**DoubleRange**](DoubleRange.md) |  | [optional] 
**ship_to_country** | **String** | The 2 character ISO code of the country where the item will be shipped to  | [optional] 
**ship_from_country** | **String** | The 2 character ISO code of the country where the item is shipped from  | [optional] 
**sort** | **String** | The sort order of the result  | [optional] [default to &#39;BEST_MATCH&#39;]
**skip** | **Integer** | Number of items to skip, used for pagination  | [optional] 


