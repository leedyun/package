# Allq::NewJob

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**tube** | **String** | Tube name | [default to &quot;default&quot;]
**body** | **String** | Text payload | [default to &quot;&lt;BODY_TEXT&gt;&quot;]
**ttl** | **Integer** | Time to live when reserved (in seconds) | [default to 1200]
**delay** | **Integer** | Delay before becoming available for processing | [default to 0]
**priority** | **Integer** | Priority of job in tube | [default to 5]
**parent_id** | **String** | Parent job id (if applicable) | [optional] 


