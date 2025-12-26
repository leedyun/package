# AliseeksApi::BestSellingSearchRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**range** | **String** | The time range to look for best selling products. Can be Top best selling products or Weekly best selling products.  | [optional] [default to &#39;top&#39;]
**category** | **String** | The category to look for best selling products. Only certain categories can be searched for depending on the &#x60;range&#x60;. When range is \&quot;top\&quot;, only the categories [ \&quot;all\&quot;, \&quot;fashion\&quot;, \&quot;electronics\&quot;, \&quot;sports\&quot;, \&quot;health_beauty\&quot;, \&quot;kids_baby\&quot;, \&quot;home_garden\&quot;, \&quot;automotive\&quot; ] are supported. When range is \&quot;weekly\&quot;, only the categories [ \&quot;woman\&quot;, \&quot;men\&quot;, \&quot;electronics\&quot;, \&quot;sports\&quot;, \&quot;health_beauty\&quot;, \&quot;kids_baby\&quot;, \&quot;automotive\&quot; ] are supported.  | [optional] [default to &#39;electronics&#39;]
**skip** | **Integer** | The number of results to skip. Allows for pagination.  | [optional] [default to 0]
**locale** | **String** | AliExpress locale to use.  | [optional] [default to &#39;en_US&#39;]
**currency** | [**RealtimeCurrency**](RealtimeCurrency.md) |  | [optional] 


