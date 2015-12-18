class MercadoBitcoin::Api::Data::Trade
  include Virtus.model
  
  attribute :price, Float
  attribute :amount, Float
  attribute :tid, Integer
  attribute :type, String
  attribute :date, Timestamp

  def to_hash
    {
      price: price,
      amount: amount,
      tid: tid,
      type: type,
      date: date
    }
  end

  def to_json
    to_hash.to_json
  end
end