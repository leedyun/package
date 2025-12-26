# AngelList

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'angel_list'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install angel_list

## Usage

    require 'angel_list'
    a = AngelList::Auth.new(:client_id => 'client_id', 
                        :client_secret => 'client_secret', 
                        :redirect_uri => 'http://127.0.0.1:3000/auth/angel_list/callback') 
                        
    redirect_to a.redirect_url

then in the callback

    a = AngelList::Auth.new(:client_id => 'client_id', 
                        :client_secret => 'client_secret', 
                        :redirect_uri => 'http://127.0.0.1:3000/auth/angel_list/callback')
    token = a.code(params[:code])
    puts token.token
now you can save the token and get another access token later with it like this

    a.from_hash(token.token)

after you have a token, you can make authorized requests:

    su = AngelList::StatusUpdate.new(a)

    message = su.new(:message=> 'message to be posted to angel list')
    su.destroy(message.id) # will delete the message, etc
 
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
