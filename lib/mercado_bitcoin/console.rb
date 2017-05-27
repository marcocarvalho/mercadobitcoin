class MercadoBitcoin::Console
  attr_accessor :options

  # Laizy way to check parameters :)
  def initialize(key:, code:, coin_pair:, **opts)
    @options = opts || {}
    @options[:key]          = key
    @options[:code]         = code
    @options[:coin_pair]    = coin_pair
  end

  def exec(command, opts)
    print send(command, *opts)
  end

  def list_system_messages(*args)
    trade_api.list_system_messages
  end

  def get_account_info(*args)
    trade_api.get_account_info
  end

  def get_order(*args)
    raise ArgumentError.new("faltando ORDER_ID") if args.count < 1
    ret = args.map do |id|
      trade_api.get_order(order_id: id)
    end
    if ret.size > 1
      ret
    else
      ret[0]
    end
  end

  def list_orders(*args)
    trade_api.list_orders(
      coin_pair: options[:coin_pair],
      order_type: options[:order_type],
      status_list: options[:status_list],
      has_fills: options[:has_fills],
      from_id: options[:from_id],
      to_id: options[:to_id],
      from_timestamp: options[:from_timestamp],
      to_timestamp: options[:to_timestamp])
  end

  def list_orderbook(*args)
    trade_api.list_orderbook(
      coin_pair: options[:coin_pair],
      full: options[:full]
    )
  end

  def place_buy_order(*args)
    trade_api.place_buy_order(
      coin_pair: options[:coin_pair],
      quantity: options[:quantity],
      limit_price: options[:limit_price]
    )
  end

  def place_sell_order(*args)
    trade_api.place_sell_order(
      coin_pair: options[:coin_pair],
      quantity: options[:quantity],
      limit_price: options[:limit_price]
    )
  end

  def cancel_order(*args)
    raise ArgumentError.new("faltando ORDER_ID") if args.count < 1
    ret = args.map do |id|
      trade_api.cancel_order(coin_pair: options[:coin_pair], order_id: id)
    end
    if ret.size > 1
      ret
    else
      ret[0]
    end
  end

  def get_withdrawal(*args)
    raise ArgumentError.new("faltando withdrawal_id") if args.count < 1
    ret = args.map do |id|
      trade_api.get_withdrawal(coin_pair: params[:coin_pair], withdrawal_id: id)
    end
    if ret.size > 1
      ret
    else
      ret[0]
    end
  end

  private

  def print(value)
    if pretty_print?
      Pry::ColorPrinter.pp value
    else
      puts value.to_json
    end
  end

  def pretty_print?
    @options[:pretty_print]
  end

  def trade_api
    @trade_api ||= MercadoBitcoin::TradeApi.new(
      key: options[:key],
      code: options[:code],
      debug: options[:debug]
    )
  end
end