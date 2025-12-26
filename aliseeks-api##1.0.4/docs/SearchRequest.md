# AliseeksApi::SearchRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**text** | **String** | The search query  | [optional] 
**sort** | **String** |  | [optional] [default to &#39;BEST_MATCH&#39;]
**currency** | [**NonRealtimeCurrency**](NonRealtimeCurrency.md) |  | [optional] 
**category** | **Integer** | The AliExpress category to search in  | [optional] 
**include_subcategories** | **BOOLEAN** | When this flag is set to &#x60;true&#x60; the &#x60;category&#x60; field will be expanded so that all items in sub-categories will be included  | [optional] [default to false]
**sort_direction** | **String** | The direction to sort the results by. Only valid for certain &#x60;sort&#x60; values  | [optional] [default to &#39;ASC&#39;]
**ratings_range** | [**DoubleRange**](DoubleRange.md) |  | [optional] 
**quantity_range** | [**IntegerRange**](IntegerRange.md) |  | [optional] 
**price_range** | [**DoubleRange**](DoubleRange.md) |  | [optional] 
**unit_price_range** | [**DoubleRange**](DoubleRange.md) |  | [optional] 
**order_range** | [**IntegerRange**](IntegerRange.md) |  | [optional] 
**item_id_range** | [**StringRange**](StringRange.md) |  | [optional] 
**freight_types** | **Array&lt;String&gt;** | Filter by freight types  | [optional] 
**skip** | **Integer** | Skip a number of items, if you need to skip more than 10000 items then use the scroll feature  | [optional] 
**limit** | **Integer** | Limit the request to a number of items  | [optional] 
**scroll_pagination** | **BOOLEAN** | When this value is &#x60;true&#x60; then you will receive a scroll identifier which you can use to request the next page of results. The scroll identifier is good for 60 seconds.  | [optional] [default to false]
**scroll_identifier** | **String** | The scroll identifier which can be retrieved by sending an initial search request with &#x60;scrollPagination&#x60; set to &#x60;true&#x60;. Scroll identifiers are good for 60 seconds.  | [optional] 


