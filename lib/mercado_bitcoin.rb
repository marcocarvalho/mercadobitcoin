require 'mercado_bitcoin/version'
require 'virtus'
require 'virtus/timestamp'
require 'rest-client'
require 'json'

module MercadoBitcoin
  require 'mercado_bitcoin/errors'
  autoload :Api,         'mercado_bitcoin/api'
  autoload :BaseApiCall, 'mercado_bitcoin/base_api_call'
  autoload :Ticker,      'mercado_bitcoin/ticker'
  autoload :Trade,       'mercado_bitcoin/trade'
  autoload :OrderBook,   'mercado_bitcoin/order_book'
end
