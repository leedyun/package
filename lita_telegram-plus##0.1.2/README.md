# lita-telegram-plus

A simple [Lita.io](https://lita.io) adapter for Telegram.

Other Lita Telegram adapters didn't handle Telegram users well,
making it impossible to use certain handlers.

## Installation

Add lita-telegram-plus to your Lita instance's Gemfile:

``` ruby
gem "lita-telegram-plus"
```

## Usage

In `lita-config.rb`:

```
config.robot.adapter = :telegram_plus
config.adapters.telegram_plus.token = "your telegram bot token here"
```
