# AliseeksApi::SearchItem

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | AliExpress Product ID  | [optional] 
**title** | **String** | The subject / title of the product  | [optional] 
**category_id** | **Integer** | The category of the item  | [optional] 
**image_url** | **String** | Image URL for the item  | [optional] 
**detail_url** | **String** | The detail URL of the item  | [optional] 
**lot_size** | **Integer** | The lot size that the item is sold in  | [optional] 
**lot_unit** | **String** | The unit when describing a lot for this item  | [optional] 
**price** | [**Amount**](Amount.md) |  | [optional] 
**ratings** | **Float** | The ratings of this item  | [optional] 
**orders** | **Float** | The number of orders of this item  | [optional] 
**freight** | [**SearchItemFreight**](SearchItemFreight.md) |  | [optional] 
**seller** | [**SearchItemSeller**](SearchItemSeller.md) |  | [optional] 
**freight_types** | [**Array&lt;SearchItemFreightType&gt;**](SearchItemFreightType.md) | List of freight types available for this item  | [optional] 


