module MercadoBitcoin
  class Ticker < BaseApiCall

    def initialize(coin, opts = {})
      opts[:parser] = TickerParser
      super(coin, opts)
    end

    def action
      @action ||= bitcoin? ? 'ticker' : 'ticker_litecoin'
    end

    def base_url
      @base_url ||= "https://www.mercadobitcoin.net/api".freeze
    end

    def model
      MercadoBitcoin::Api::Data::Ticker
    end

    class TickerParser
      def self.parse(body)
        new.parse(body)
      end

      def parse(body)
        JSON.parse(body)['ticker']
      end
    end
  end
end