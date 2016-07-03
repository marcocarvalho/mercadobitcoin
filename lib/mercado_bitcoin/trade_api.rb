require 'openssl'

module MercadoBitcoin
  class TradeApi
    BTC = 'BRLBTC'
    LTC = 'BRLLTC'

    using QueryStringRefinement

    attr_accessor :key, :code

    def initialize(key:, code:)
      @key = key
      @code = code
    end

    def get_account_info
      params = base_params('get_account_info')
      post(params)
    end

    def list_system_messages
      params = base_params('list_system_messages')
      post(params)
    end

    def get_order(pair: BTC, order_id:)
      params = base_params('get_order')
      params[:order_id]  = order_id
      params[:coin_pair] = pair
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
      params[:tapi_nonce] = Time.new.to_i
      signature = sign(params)
      result = JSON.parse(
        RestClient.post(
          base_url,
          params.to_query_string,
          header(signature)
        )
      )
    end

    def base_path
      @base_path ||= "/tapi/v3/".freeze
    end

    def base_url
      @base_url ||= "https://www.mercadobitcoin.net#{base_path}".freeze
    end

    def header(signature)
      {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'TAPI-ID' => key,
        'TAPI-MAC' => signature
      }
    end

    def base_params(method)
      {
        tapi_method: method
      }
    end

    def sign(string_or_hash, path = nil)
      path ||= base_path
      string_or_hash = path + '?' + string_or_hash.to_query_string if string_or_hash.is_a?(Hash)
      hmac = OpenSSL::HMAC.new(code, OpenSSL::Digest.new('sha512'))
      hmac.update(string_or_hash).to_s
    end
  end
end
