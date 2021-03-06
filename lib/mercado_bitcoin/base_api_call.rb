module MercadoBitcoin
    class BaseApiCall
    attr_accessor :coin, :parser, :rest_client, :parser_error_class, :parsed
    def initialize(coin = :bitcoin, opts = {})
      @coin               = coin.to_s.downcase.to_sym
      raise MercadoBitcoin::CoinTypeError.new("bitcoin or litecoin expected #{coin} received") unless valid_coin?
      @parser             = opts[:parser]             || JSON
      @rest_client        = opts[:rest_client]        || RestClient
      @parser_error_class = opts[:parser_error_class] || JSON::ParserError
    end

    def valid_coin?
      bitcoin? || litecoin?
    end

    def fetch
      @parsed = parse(get(url))
      model.new(parsed)
    end

    def model
      raise NotImplementedError.new
    end

    def action
      ''
    end

    def base_url
      @base_url ||= "https://www.mercadobitcoin.net/api".freeze
    end

    def bitcoin?
      coin == :bitcoin
    end

    def litecoin?
      coin == :litecoin
    end

    def params
      {}
    end

    def url
      return @url if @url
      ac = action.is_a?(String) && action != '' ? File.join(base_url, action) : base_url
      @url = URI.parse(ac)
      @url.query = URI.encode_www_form(params) if !params.nil? && !params.empty?
      @url = @url.to_s
    end

    attr_reader :response

    def get(url)
      @response = rest_client.get(url)
    end

    def parse(body)
      parser.parse(body)
    rescue parser_error_class
      raise MercadoBitcoin::ParserError.new("#{url} responded an invalid json data")
    end
  end
end