require 'openssl'

module MercadoBitcoin
  class TradeApi
    using QueryStringRefinement

    attr_accessor :key, :code

    def initialize(key:, code:)
      @key = key
      @code = code
    end

    def get_info
      params = base_params('getInfo')
      post(params)
    end

    # type: buy, sell
    def trade(pair: 'btc_brl', type:, volume:, price:)
      params = base_params('Trade')
      params[:pair]   = pair
      params[:type]   = type
      params[:volume] = volume
      params[:price]  = price
      post(params)
    end

    # status: active, canceled, completed
    # since and end: in Unix timestamp: Time.new.to_i
    def order_list(pair: 'btc_brl', type: nil, status: nil, from_id: nil, end_id: nil, since: nil, _end: nil)
      params = base_params('OrderList')
      params[:pair] = pair
      params[:type] = type if type
      params[:status] = status if status 
      params[:from_id] = from_id if from_id 
      params[:end_id] = end_id if end_id 
      params[:since] = since if since 
      params[:end] = _end if _end
      post(params) 
    end

    def post(params)
      signature = sign(params)
      JSON.parse(
        RestClient.post(
          base_url,
          params.to_query_string,
          header(signature)
        )
      )
    end

    def base_url
      @base_url ||= "https://www.mercadobitcoin.net/tapi/".freeze
    end

    def header(signature)
      {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Key' => key,
        'Sign' => signature
      }
    end

    def base_params(method)
      {
        method: method,
        tonce: Time.new.to_i + (ENV['TONCE_CORRECTION'].to_i)
      }
    end

    def sign(string_or_hash)
      string_or_hash = string_or_hash.to_query_string if string_or_hash.is_a?(Hash)
      hmac = OpenSSL::HMAC.new(code, OpenSSL::Digest.new('sha512'))
      hmac.update(string_or_hash).to_s
    end
  end
end