class MercadoBitcoin::Api::Data::OrderBook
  using MercadoBitcoin::Api::Data::AskBidRefinement

  attr_reader :asks, :bids

  def initialize(opts = {})
    self.asks = opts[:asks] || opts['asks']
    self.bids = opts[:bids] || opts['bids']
  end

  def asks=(v)
    v ||= []
    @asks = v.map { |i| MercadoBitcoin::Api::Data::AskBid.new(i.to_model_hash) }
  end

  def bids=(v)
    v ||= []
    @bids = v.map { |i| MercadoBitcoin::Api::Data::AskBid.new(i.to_model_hash) }
  end

  def to_hash
    {
      asks: asks.map { |i| i.to_hash },
      bids: bids.map { |i| i.to_hash }
    }
  end

  def to_json
    to_hash.to_json
  end
end