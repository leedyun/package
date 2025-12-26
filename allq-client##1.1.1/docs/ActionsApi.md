# Allq::ActionsApi

All URIs are relative to *http://localhost:8090*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bury_put**](ActionsApi.md#bury_put) | **PUT** /bury | Bury
[**job_delete**](ActionsApi.md#job_delete) | **DELETE** /job | Delete
[**job_get**](ActionsApi.md#job_get) | **GET** /job | Job
[**job_post**](ActionsApi.md#job_post) | **POST** /job | Job
[**parent_job_post**](ActionsApi.md#parent_job_post) | **POST** /parent_job | Parent  Job
[**peek_get**](ActionsApi.md#peek_get) | **GET** /peek | Peek
[**release_put**](ActionsApi.md#release_put) | **PUT** /release | Release
[**set_children_started_put**](ActionsApi.md#set_children_started_put) | **PUT** /set_children_started | Set Children Started
[**throttle_post**](ActionsApi.md#throttle_post) | **POST** /throttle | Throttle
[**touch_put**](ActionsApi.md#touch_put) | **PUT** /touch | Touch
[**tube_delete**](ActionsApi.md#tube_delete) | **DELETE** /tube | Clear Tube


# **bury_put**
> BasicResponse bury_put(job_id)

Bury

Bury Job

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::ActionsApi.new

job_id = "job_id_example" # String | Job ID


begin
  #Bury
  result = api_instance.bury_put(job_id)
  p result
rescue Allq::ApiError => e
  puts "Exception when calling ActionsApi->bury_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **job_id** | **String**| Job ID | 

### Return type

[**BasicResponse**](BasicResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **job_delete**
> BasicResponse job_delete(job_id, opts)

Delete

Finished Job

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::ActionsApi.new

job_id = "job_id_example" # String | Job ID

opts = { 
  tube: "tube_example" # String | Name of Tube (For deleting \"ready\" objects)
}

begin
  #Delete
  result = api_instance.job_delete(job_id, opts)
  p result
rescue Allq::ApiError => e
  puts "Exception when calling ActionsApi->job_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **job_id** | **String**| Job ID | 
 **tube** | **String**| Name of Tube (For deleting \&quot;ready\&quot; objects) | [optional] 

### Return type

[**BasicResponse**](BasicResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **job_get**
> JobResponse job_get(tube)

Job

Get job from queue

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::ActionsApi.new

tube = "tube_example" # String | Name of tube


begin
  #Job
  result = api_instance.job_get(tube)
  p result
rescue Allq::ApiError => e
  puts "Exception when calling ActionsApi->job_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tube** | **String**| Name of tube | 

### Return type

[**JobResponse**](JobResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **job_post**
> JobRef job_post(new_job)

Job

Put job into queue

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::ActionsApi.new

new_job = Allq::NewJob.new # NewJob | New Job Object


begin
  #Job
  result = api_instance.job_post(new_job)
  p result
rescue Allq::ApiError => e
  puts "Exception when calling ActionsApi->job_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **new_job** | [**NewJob**](NewJob.md)| New Job Object | 

### Return type

[**JobRef**](JobRef.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **parent_job_post**
> JobRef parent_job_post(new_parent_job)

Parent  Job

Create a parent job

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::ActionsApi.new

new_parent_job = Allq::NewParentJob.new # NewParentJob | New Parent Job Data


begin
  #Parent  Job
  result = api_instance.parent_job_post(new_parent_job)
  p result
rescue Allq::ApiError => e
  puts "Exception when calling ActionsApi->parent_job_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **new_parent_job** | [**NewParentJob**](NewParentJob.md)| New Parent Job Data | 

### Return type

[**JobRef**](JobRef.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **peek_get**
> JobResponse peek_get(tube, opts)

Peek

Peek at next job

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::ActionsApi.new

tube = "tube_example" # String | Tube name

opts = { 
  buried: "false" # String | Look in buried
}

begin
  #Peek
  result = api_instance.peek_get(tube, opts)
  p result
rescue Allq::ApiError => e
  puts "Exception when calling ActionsApi->peek_get: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tube** | **String**| Tube name | 
 **buried** | **String**| Look in buried | [optional] [default to false]

### Return type

[**JobResponse**](JobResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **release_put**
> BasicResponse release_put(job_id)

Release

Releases job back into queue

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::ActionsApi.new

job_id = "job_id_example" # String | Job ID


begin
  #Release
  result = api_instance.release_put(job_id)
  p result
rescue Allq::ApiError => e
  puts "Exception when calling ActionsApi->release_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **job_id** | **String**| Job ID | 

### Return type

[**BasicResponse**](BasicResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **set_children_started_put**
> BasicResponse set_children_started_put(job_id)

Set Children Started

When a parent job doesn't know how many children are going to be added, this is the event that sets the final children count on the parent_job, allowing it to run when the children are done.

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::ActionsApi.new

job_id = "job_id_example" # String | Job ID


begin
  #Set Children Started
  result = api_instance.set_children_started_put(job_id)
  p result
rescue Allq::ApiError => e
  puts "Exception when calling ActionsApi->set_children_started_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **job_id** | **String**| Job ID | 

### Return type

[**BasicResponse**](BasicResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **throttle_post**
> TubeRef throttle_post(throttle)

Throttle

Creates a throttle on a tube

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::ActionsApi.new

throttle = Allq::Throttle.new # Throttle | Throttle info


begin
  #Throttle
  result = api_instance.throttle_post(throttle)
  p result
rescue Allq::ApiError => e
  puts "Exception when calling ActionsApi->throttle_post: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **throttle** | [**Throttle**](Throttle.md)| Throttle info | 

### Return type

[**TubeRef**](TubeRef.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **touch_put**
> BasicResponse touch_put(job_id)

Touch

Touch job

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::ActionsApi.new

job_id = "job_id_example" # String | Job ID


begin
  #Touch
  result = api_instance.touch_put(job_id)
  p result
rescue Allq::ApiError => e
  puts "Exception when calling ActionsApi->touch_put: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **job_id** | **String**| Job ID | 

### Return type

[**BasicResponse**](BasicResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **tube_delete**
> BasicResponse tube_delete(tube)

Clear Tube

Delete all contents of tube

### Example
```ruby
# load the gem
require 'allq_client'

api_instance = Allq::ActionsApi.new

tube = "tube_example" # String | Tube Name


begin
  #Clear Tube
  result = api_instance.tube_delete(tube)
  p result
rescue Allq::ApiError => e
  puts "Exception when calling ActionsApi->tube_delete: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tube** | **String**| Tube Name | 

### Return type

[**BasicResponse**](BasicResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



