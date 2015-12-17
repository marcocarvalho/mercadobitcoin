class MercadoBitcoin::Api::Data::Ticker
  include Virtus.model

  attribute :high, Float  
  attribute :low, Float  
  attribute :vol, Float  
  attribute :last, Float  
  attribute :buy, Float  
  attribute :sell, Float  
  attribute :date, Timestamp

  def to_hash
    {
      high: high,
      low: low,
      vol: vol,
      last: last,
      buy: buy,
      sell: sell,
      date: date
    }
  end

  def to_json
    to_hash.to_json
  end
end