# MercadoBitcoin [![Build Status](https://travis-ci.org/marcocarvalho/mercadobitcoin.png?branch=master)](https://travis-ci.org/marcocarvalho/mercadobitcoin)

Thin layer to [MercadoBitcoin.com.br](http://mercadobitcoin.com.br/) public price api layer.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mercado_bitcoin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mercado_bitcoin

## Usage

TODO:
 - write documentation.
 - V3 protocol implementation

### Trade Api (v3)

####
```
  mb = MercadoBitcoin::TradeApi.new(key: '<key>', code: '<secret>')
  mb.get_account_info
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcocarvalho/mercado_bitcoin. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

