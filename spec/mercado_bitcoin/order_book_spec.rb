require 'spec_helper'

RSpec.describe MercadoBitcoin::OrderBook, type: :service do
  let(:params) { {} }

  let(:valid_json) { '{"asks":[[1.2,2.2]],"bids":[[3.1,4.1]]}' }

  subject { described_class.new(coin, params) }

  context 'bitcoin' do
    let(:coin) { :bitcoin }
    it '#fetch' do
      expect(subject).to receive(:get).with('https://www.mercadobitcoin.net/api/orderbook').and_return(valid_json)
      expect(subject.fetch.to_hash).to eq({
        asks: [ { price: 1.2, volume: 2.2 } ],
        bids: [ { price: 3.1, volume: 4.1 } ]
      })
    end
  end

  context 'litecoin' do
    let(:coin) { :litecoin }

    it '#fetch' do
      expect(subject).to receive(:get).with('https://www.mercadobitcoin.net/api/orderbook_litecoin').and_return(valid_json)
      expect(subject.fetch.to_hash).to eq({
        asks: [ { price: 1.2, volume: 2.2 } ],
        bids: [ { price: 3.1, volume: 4.1 } ]
      })
    end
  end
end