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
      @retries = 0
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

    def get_withdrawal(coin: 'BTC', withdrawal_id:)
      params = base_params('get_withdrawal')
      params[:coin] = coin.upcase
      params[:withdrawal_id] = withdrawal_id
      post(params)
    end

    def withdraw_coin(coin: 'BTC', quantity:, description: nil, **opts)
      params = base_params('withdraw_coin')
      params[:quantity] = quantity
      params[:coin] = coin.upcase
      params[:description] = description if description

      if params[:coin] == 'BRL'
        params[:account_ref] = opts[:account_ref] || (raise MissingParameter.new('account_ref is missing for coin BRL'))
      else
        params[:address] = opts[:address]
        if params[:coin] == 'BTC'
          params[:tx_fee]         = opts[:tx_fee] || 0.00005
          params[:tx_aggregate]   = opts[:tx_aggregate]   unless opts[:tx_aggregate].nil?
          params[:via_blockchain] = opts[:via_blockchain] unless opts[:via_blockchain].nil?
        end
      end
      post(params)
    end

    attr_writer :last_tapi_nonce

    def last_tapi_nonce
      @last_tapi_nonce ||= (Time.new.to_f * 10).to_i
    end

    def tapi_nonce
      self.last_tapi_nonce += 1
    end

    def post(params)
      params[:tapi_nonce] = tapi_nonce
      signature = sign(params)
      puts params.to_query_string if debug?
      result = JSON.parse(
        RestClient.post(
          base_url,
          params.to_query_string,
          header(signature)
        )
      )
      deal_with_errors(result)
    rescue MercadoBitcoin::TonceAlreadyUsed
      retry
    end

    def deal_with_errors(result)
      if result['status_code'] == 100
        @retries = 0
        return result
      end

      @retries += 1
      if @retries >= 6
        @retries = 0
        result[:_mb_gem] = { code: 1, retries: @retries, error: 'maximum retries reached' }
        return result
      end

      return deal_with_tapi_nonce(result) if result['status_code'] == 203

      deal_with_errors_not_treated(result)
    end

    def deal_with_tapi_nonce(result)
      if result['error_message'] =~ /utilizado: (\d+)/
        self.last_tapi_nonce = $1.to_i
        raise MercadoBitcoin::TonceAlreadyUsed.new
      else
        result[:_mb_gem] = { code: 2, retries: @retries, error: 'last tapi_nonce not found.' }
        result
      end
    end

    def deal_with_errors_not_treated(result)
      result[:_mb_gem] = { code: 0, retries: @retries, error: 'not treated' }
      @retries = 0
      result
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
        .map { |i| i.to_i }
        .to_json
    end

    def parse_order_type(type)
      type
        .gsub(/(buy|sell)/i, { 'buy' => 1, 'sell' => 2 })
    end
  end
end
