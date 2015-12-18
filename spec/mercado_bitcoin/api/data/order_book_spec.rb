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
end