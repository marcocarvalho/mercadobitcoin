require 'spec_helper'

RSpec.describe MercadoBitcoin::Api::Data::Ticker, type: :model do
  subject { described_class.new(params) }

  let(:time) { Time.new }

  context 'symbol hash' do
    let(:params) do
      {
        high: '12.2',
        low: 11.1,
        vol: '10.10',
        last: '1',
        buy: 4,
        sell: '5.5',
        date: time.to_i
      }
    end

    it '#high' do
      expect(subject.high).to eq(12.2)
    end

    it '#low' do
      expect(subject.low).to eq(11.1)
    end

    it '#vol' do
      expect(subject.vol).to eq(10.1)
    end

    it '#last' do
      expect(subject.last).to eq(1.0)
    end

    it '#buy' do
      expect(subject.buy).to eq(4.0)
    end

    it '#sell' do
      expect(subject.sell).to eq(5.5)
    end

    it '#date' do
      expect(subject.date.to_i).to eq(time.to_i)
    end
  end

  context 'string key hash' do
    let(:params) do
      {
        'high' => '12.2',
        'low' => 11.1,
        'vol' => '10.10',
        'last' => '1',
        'buy' => 4,
        'sell' => '5.5',
        'date' => time.to_i
      }
    end

    it '#high' do
      expect(subject.high).to eq(12.2)
    end

    it '#low' do
      expect(subject.low).to eq(11.1)
    end

    it '#vol' do
      expect(subject.vol).to eq(10.1)
    end

    it '#last' do
      expect(subject.last).to eq(1.0)
    end

    it '#buy' do
      expect(subject.buy).to eq(4.0)
    end

    it '#sell' do
      expect(subject.sell).to eq(5.5)
    end

    it '#date' do
      expect(subject.date.to_i).to eq(time.to_i)
    end
  end
end