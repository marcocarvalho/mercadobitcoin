require 'openssl'

module MercadoBitcoin
  class TradeApi
    using QueryStringRefinement

    attr_accessor :key, :code, :tonce_correction

    def initialize(key:, code:, tonce_correction: 0)
      @key = key
      @code = code
      @tonce_correction = tonce_correction
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

    def cancel_order(pair: 'btc_brl', order_id:)
      params = base_params('CancelOrder')
      params[:pair] = pair
      params[:order_id] = order_id
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
      params[:tonce] = Time.new.to_i + env_or_var_tonce
      signature = sign(params)
      result = JSON.parse(
        RestClient.post(
          base_url,
          params.to_query_string,
          header(signature)
        )
      )
      raise TonceDesyncError.new('desync') if tonce_error?(result)
      result 
    rescue TonceDesyncError
      @tonce_correction = get_tonce_correction(result)
      retry
    end

    def tonce_error?(result)
      if result['error'].to_s =~ /(\d+) e (\d+), tonce recebido (\d+)+/
        $1.to_i - $3.to_i + 10
      else
        false
      end
    end
    alias_method :get_tonce_correction, :tonce_error?

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
        method: method
      }
    end

    def env_or_var_tonce
      if ENV['TONCE_CORRECTION'].to_s =~ /\d+/
        ENV['TONCE_CORRECTION'].to_i
      else
        tonce_correction
      end
    end

    def sign(string_or_hash)
      string_or_hash = string_or_hash.to_query_string if string_or_hash.is_a?(Hash)
      hmac = OpenSSL::HMAC.new(code, OpenSSL::Digest.new('sha512'))
      hmac.update(string_or_hash).to_s
    end
  end
end