module MercadoBitcoin
    class Ticker
    attr_accessor :kind
    def initialize(kind = :bitcoin)
      @kind = kind.to_sym
    end

    def fetch
      parsed = parse(get(url))
      MercadoBitcoin::Api::Data::Ticker.new(parsed['ticker'])
    end

    private

    def bitcoin?
      kind == :bitcoin 
    end

    def lite_coin?
      kind == :litecoin
    end

    def action
      @action ||= bitcoin? ? 'ticker' : 'ticker_litecoin'
    end

    def url
      @url ||= "https://www.mercadobitcoin.net/api/#{action}"
    end

    attr_reader :response

    def get(url)
      @response = RestClient.get(url)
    end

    def parse(body)
      JSON.parse(body)
    rescue JSON::ParserError
      raise MercadoBitcoin::TickerError.new("#{url} responded an invalid json data")
    end
  end
end