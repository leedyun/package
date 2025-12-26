# AliseeksApi::Product

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | The AliExpress item ID  | [optional] 
**category_id** | **String** | The item category  | [optional] 
**company_id** | **String** | The company ID  | [optional] 
**seller_id** | **String** | The seller ID  | [optional] 
**title** | **String** | The subject / title of the item  | [optional] 
**status_id** | **Integer** | The AliExpress status ID  | [optional] 
**status** | **String** | The AliExpress status  | [optional] 
**count_per_lot** | **Integer** | The number of items per lot  | [optional] 
**wish_list_count** | **Integer** | Number of times the item has been added to a wishlist  | [optional] 
**unit** | **String** | The unit of the item  | [optional] 
**multi_unit** | **String** | The unit for multiple items  | [optional] 
**seller** | [**ProductSeller**](ProductSeller.md) |  | [optional] 
**reviews** | [**ProductReviews**](ProductReviews.md) |  | [optional] 
**trade** | [**TradeInformation**](TradeInformation.md) |  | [optional] 
**promotion** | [**ProductPromotion**](ProductPromotion.md) |  | [optional] 
**product_images** | **Array&lt;String&gt;** | The item images  | [optional] 
**attributes** | [**Array&lt;ProductAttribute&gt;**](ProductAttribute.md) | Attributes associated with the AliExpress product  | [optional] 
**html_description** | **String** | The product HTML description  | [optional] 
**price_summary** | [**PriceSummary**](PriceSummary.md) |  | [optional] 
**prices** | [**Array&lt;SkuPriceOption&gt;**](SkuPriceOption.md) | All the variations of an AliExpress item and prices associated with each variation  | [optional] 
**shipping** | [**Array&lt;ProductShippingOptions&gt;**](ProductShippingOptions.md) | The shipping options of an AliExpress item  | [optional] 


