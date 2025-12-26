Rails.application.routes.draw do
  get 'batch' => 'api_batch/batch#get'
end