require 'openssl'

module MercadoBitcoin
  class TradeApi
    BTC = 'BRLBTC'
    LTC = 'BRLLTC'

    using QueryStringRefinement

    attr_accessor :key, :code

    def initialize(key:, code:, debug: false)
      @key = key
      @code = code
      @debug = debug
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

    def list_orders(
      coin_pair: BTC,
      order_type: nil,
      status_list: nil,
      has_fills: nil, # com ou sem execução
      from_id: nil,
      to_id: nil,
      from_timestamp: nil,
      to_timestamp: nil)
      params = base_params('list_orders')
      params[:coin_pair] = coin_pair
      params[:order_type] = parse_order_type(order_type) if order_type
      params[:status_list] = parse_status_list(status_list) if status_list
      params[:has_fills] = has_fills if has_fills != nil
      params[:from_id] = from_id if from_id
      params[:to_id] = to_id if to_id
      params[:from_timestamp] = from_timestamp if from_timestamp
      params[:to_timestamp] = to_timestamp if to_timestamp
      post(params)
    end

    def list_orderbook(coin_pair: BTC, full: nil)
      params = base_params('list_orderbook')
      params[:coin_pair] = coin_pair
      params[:full] = full if full != nil
      post(params)
    end

    def place_buy_order coin_pair: BTC, quantity:, limit_price:
      params = base_params('place_buy_order')
      params[:coin_pair] = coin_pair
      params[:quantity] = quantity
      params[:limit_price] = limit_price
      post(params)
    end

    def place_sell_order coin_pair: BTC, quantity:, limit_price:
      params = base_params('place_sell_order')
      params[:coin_pair] = coin_pair
      params[:quantity] = quantity
      params[:limit_price] = limit_price
      post(params)
    end

    def cancel_order(coin_pair: BTC, order_id:)
      params = base_params('cancel_order')
      params[:coin_pair] = coin_pair
      params[:order_id] = order_id
      post(params)
    end

    def get_withdrawal(coin_pair: BTC, withdrawal_id:)
      params = base_params('get_withdrawal')
      params[:withdrawal_id] = withdrawal_id
      post(params)
    end

    def withdraw_coin(coin_pair: BTC, quantity:, destiny:, description: nil)
      params = base_params('withdraw_coin')
      params[:quantity] = quantity
      params[:destiny] = destiny
      params[:description] = description if description
      post(params)
    end

    def post(params)
      params[:tapi_nonce] = (Time.new.to_f * 10).to_i
      signature = sign(params)
      puts params.to_query_string if debug?
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

    private

    def debug?
      @debug
    end

    def parse_status_list(list)
      list
        .gsub(/(cancelled|open|filled)/i, { 'cancelled' => 3, 'open' => 2, 'filled' => 4 })
        .split(',')
        .to_json
    end

    def parse_order_type(type)
      type
        .gsub(/(buy|sell)/i, { 'buy' => 1, 'sell' => 2 })
    end
  end
end
