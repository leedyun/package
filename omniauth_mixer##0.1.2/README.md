[![Gem Version](https://badge.fury.io/rb/omniauth-mixer.svg)](https://badge.fury.io/rb/omniauth-mixer)

# OmniAuth::Mixer
OmniAuth strategy for Mixer

## Installation
Add this line to your application's Gemfile:

    gem 'omniauth-mixer'

Then run `bundle install`

Or install it yourself with `gem install omniauth-mixer`

### Using Directly
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :mixer, ENV['MIXER_CLIENT_ID'], ENV['MIXER_CLIENT_SECRET']
end
```

### Using With Devise
Add to `config/initializers/devise.rb`
```ruby
  config.omniauth :mixer, ENV['MIXER_CLIENT_ID'], ENV['MIXER_CLIENT_SECRET']
```

And apply it to your Devise user model:
```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable,
         omniauth_providers: %i(mixer)

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
      u.password = Devise.friendly_token[0, 20]
      u.provider = auth.provider
      u.uid      = auth.uid
    end
    user.update avatar_url: auth.info.image,
                email:      auth.info.email,
                name:       auth.info.name
    user
  end
end
```

## Default Scope

The default scope is set to _user:details:self_, making this hash available in `request.env['omniauth.auth']`:
```ruby
{
  provider:    'mixer',
  uid:         123456789,
  info:        {
    name:        'JohnDoe',
    email:       'johndoe@example.com',
    description: 'My channel.',
    image:       'https://uploads.mixer.com/avatar/12345678-1234.jpg',
    social:      {
      discord:  'johndoe#12345',
      facebook: 'https://facebook.com/John.Doe'
      player:   'https://player.me/johndoe',
      twitter:  'https://twitter.com/johndoe',
      youtube:  'https://youtube.com/user/johndoe'
    },
    urls:        { Mixer: 'https://mixer.com/johndoe' }
  },
  credentials: {
    token:         'asdfghjklasdfghjklasdfghjkl',
    refresh_token: 'qwertyuiopqwertyuiopqwertyuiop',
    expires_at:    1477577799,
    expires:       true
  }
}
```

## Credits

Derived from omniauth-beam: https://github.com/charmquark/omniauth-beam
