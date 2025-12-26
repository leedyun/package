# AliseeksApi::ProductDetail

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | The AliExpress item ID  | [optional] 
**category_id** | **String** | The item category  | [optional] 
**company_id** | **String** | The company ID  | [optional] 
**seller_id** | **String** | The seller ID  | [optional] 
**title** | **String** | The subject / title of the item  | [optional] 
**product_images** | **Array&lt;String&gt;** | The item images  | [optional] 
**status_id** | **Integer** | The AliExpress status  | [optional] 
**count_per_lot** | **Integer** | The number of items per lot  | [optional] 
**wish_list_count** | **Integer** | Number of times the item has been added to a wishlist  | [optional] 
**unit** | **String** | The unit of the item  | [optional] 
**multi_unit** | **String** | The unit for multiple items  | [optional] 
**promotions** | [**Array&lt;PromotionOption&gt;**](PromotionOption.md) | The promotions present on an item  | [optional] 
**attributes** | [**Array&lt;ProductAttribute&gt;**](ProductAttribute.md) | The attributes of an item  | [optional] 
**prices** | [**Array&lt;ProductPriceOption&gt;**](ProductPriceOption.md) | List of price options for an item  | [optional] 
**reviews** | [**ProductReviews**](ProductReviews.md) |  | [optional] 
**trade** | [**TradeInformation**](TradeInformation.md) |  | [optional] 
**sku_properties** | [**Array&lt;SkuProperty&gt;**](SkuProperty.md) | List of sku properties that correspond to an item  | [optional] 


