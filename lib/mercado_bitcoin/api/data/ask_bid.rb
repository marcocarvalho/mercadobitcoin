class MercadoBitcoin::Api::Data::AskBid
  include Virtus.model

  attribute :price, Float
  attribute :volume, Float

  def to_hash
    {
      price: price.to_f,
      volume: volume.to_f
    }
  end

  def to_json
    to_hash.to_json
  end
end