# AirbrakeNotifyingThreads
Threads with exception rescue and airbrake notice delivering ( You need to configure airbrake for you application previously ).
Add the original stack to the notice, not the thread clear stack.

Suitable for handling simple one liners, like email.deliver, or some external calls which can be async. 

Do not use it if you are dealing with thread unsafe code. 

# AirbrakeNotifyingThreads (рус)
Небольшой инструментик для исполнения коротких асинхронных методов с ловлей эксепшенов и доставкой их через Airbrake.
Не стоит использовать, если код не thread safe. Потому что внутри это Thread.

См. примеры использования.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'airbrake_notifying_threads'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install airbrake_notifying_threads

## Usage


```ruby
class User
  # Using NotifyingThread class Ex:
  # devise async mail delivering with threads
  def send_devise_notification(notification, *args)
      # don't forget email not sended without deliver
      message = devise_mailer.send(notification, self, *args)
      
      # this is the params you want to anylise whgen something crashes here
      add_to_airbrake_notice = attributes.slice('email', 'name', 'surname', 'cell', 'id')
      
      # run message delivering
      NotifyingThread.run_async_with_rescue(add_to_airbrake_notice) { message.deliver }
  end
  
  #Using AirbrakeNotifyingThreads module 
  include AirbrakeNotifyingThreads
  
  # making some external call async, for example push some data in SalesForce app
  def send_to_sf
    # sf_params - is the params you want to anylise whgen something crashes here, in this case it's params sended to SF app
    run_async_with_rescue(sf_params) { send_sf_raw }
  end
  
end  
  
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

