class MercadoBitcoin::Api::Data::Ticker
  include Virtus.model

  attribute :high, Float  
  attribute :low, Float  
  attribute :vol, Float  
  attribute :last, Float  
  attribute :buy, Float  
  attribute :sell, Float  
  attribute :date, Timestamp
end