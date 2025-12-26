# AcceptionClient

An API facade for the acception service.


## Installation

Add this line to your application's Gemfile:

    gem 'acception_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acception_client

## Usage

All of the API facades use the /messages endpoint.  The messages endpoint is very adaptable due to its architecture and the API facade 
tries to abstract some of the complexities away with specific use cases that are useful.  The most adaptable facade class is the 
OpenMessage.  The OpenMessage is the closest abstraction to the server side design.  As such, it accepts any of the aspects that are 
available in Acception.

The application parameter is only required if not proivded in the configuraiton (we strongly suggest to include this in the configuration).  
If you do not include occurred_at in a data, message or open message, the current time is used.

### Data

    data   = "some-data-to-send-to-server"
    client = Acception::Client::Data::Create.new( data, application: 'ncite',
                                                        name: "token", 
                                                        content_type: "text/plain" ) 
    # defaults to MessageType::DATA
    client.call


### Error

    client = Acception::Client::Errors::Create.new( error, application: 'ncite',       # the application can be excluded if provided in the configuraiton
                                                           occurred_at: Time.now.utc ) 
    # defaults to MessageType::ERROR
    client.call

In order to override the default message type for an error, just pass it as an option.

    client = Acception::Client::Errors::Create.new( error, application: 'ncite', 
                                                           message_type: Acception::MessageType::FATAL,
                                                           occurred_at: Time.now.utc ) 
    client.call


### Message

    client = Acception::Client::Messages::Create.new( application: 'ncite', 
                                                      occurred_at: Time.now.utc,
                                                      message: 'An message' )
    # defaults to MessageType::INFO
    client.call


### Open Message

    client = Acception::Client::OpenMessages::Create.new( message_type: Acception::MessageType::EMERGENCY, 
                                                          application: 'ncite', 
                                                          occurred_at: Time.now.utc,
                                                          message: 'An open message', 
                                                          path: 'asdf/asdf/asdf' )
    client.call
