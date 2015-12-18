require 'spec_helper'

RSpec.describe MercadoBitcoin::Api::Data::AskBid, type: :model do
  subject { described_class.new(params) }

  context 'symbol hash' do
    let(:params) do
      {
        price: '12.2',
        volume: 11.1,
      }
    end

    it 'to_hash' do
      expect(subject.to_hash).to eq({
        price: 12.2,
        volume: 11.1
      })
    end

    it 'to_json' do
      expect(subject.to_json).to eq({
        price: 12.2,
        volume: 11.1
      }.to_json)
    end
  end

  context 'string key hash' do
    let(:params) do
      {
        'price' => '12.2',
        'volume' => 11.1
      }
    end

    it '#price' do
      expect(subject.price).to eq(12.2)
    end

    it '#volume' do
      expect(subject.volume).to eq(11.1)
    end
  end
end