require 'spec_helper'

RSpec.describe MercadoBitcoin::Api::Data::OrderBook, type: :model do
  let(:options) { { } }

  subject { described_class.new(options) }

  context 'empty' do
    it 'asks bids' do
      expect(subject.asks).to eq([])
      expect(subject.bids).to eq([])
    end

    it 'to_hash' do
      expect(subject.to_hash).to eq({ asks: [], bids: [] })
    end

    it 'to_json' do
      expect(subject.to_json).to eq({ asks: [], bids: [] }.to_json)
    end
  end

  context 'parsing' do
    let(:options) { { asks: [ [ 1, 2 ] ], bids: [ [ 3, 4 ] ] } }

    it 'to_hash' do
      expect(subject.to_hash).to eq({
        asks: [{ price: 1.0, volume: 2.0 }],
        bids: [{ price: 3.0, volume: 4.0 }]
      })
    end

    it 'to_json' do
      expect(subject.to_json).to eq({
        asks: [{ price: 1.0, volume: 2.0 }],
        bids: [{ price: 3.0, volume: 4.0 }]
      }.to_json)
    end
  end
end