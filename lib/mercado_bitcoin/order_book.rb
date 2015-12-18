class MercadoBitcoin::OrderBook < MercadoBitcoin::BaseApiCall
  def model
    MercadoBitcoin::Api::Data::OrderBook
  end

  def action
    @action ||= bitcoin? ? 'orderbook' : 'orderbook_litecoin'
  end
end