module MercadoBitcoin
    class BaseApiCall
    attr_accessor :kind, :parser, :rest_client
    def initialize(kind = :bitcoin, opts = {})
      @kind               = kind.to_sym
      @parser             = opts[:parser]             || JSON
      @rest_client        = opts[:rest_client]        || RestClient
      @parser_error_class = opts[:parser_error_class] || JSON::ParserError
    end

    def fetch
      parsed = parse(get(url))
      model.new(parsed['ticker'])
    end

    def model
      raise NotImplementedError.new
    end

    def action
      raise NotImplementedError.new
    end

    def base_url
      raise NotImplementedError.new
    end

    def bitcoin?
      kind == :bitcoin 
    end

    def lite_coin?
      kind == :litecoin
    end

    def url
      @url ||= "https://www.mercadobitcoin.net/api/#{action}?#{params}"
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