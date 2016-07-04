require 'spec_helper'

RSpec.describe MercadoBitcoin::Ticker, type: :service do
  subject { described_class.new(kind) }

  let(:valid) do
    {
      "ticker" =>  {
        "high" => 1870.00000000,
        "low" => 1783.35001000,
        "vol" => 144.10222775,
        "last" => 1869.00000000,
        "buy" => 1845.90001000,
        "sell" => 1867.99999000,
        "date" => 1450379846
      }
    }
  end

  let(:invalid) { '<HTML!>...</HTML>' }

  context 'bitcoin' do
    let(:kind) { :bitcoin }

    it '#invalid' do
      expect(subject).to receive(:get).with('https://www.mercadobitcoin.net/api/ticker').once.and_return(invalid)
      expect { subject.fetch }.to raise_error('https://www.mercadobitcoin.net/api/ticker responded an invalid json data')
    end

    it '#fetch' do
      expect(subject).to receive(:get).with('https://www.mercadobitcoin.net/api/ticker').once.and_return(valid.to_json)
      expect(subject.fetch.to_hash).to eq({
        high: 1870.00000000,
        low: 1783.35001000,
        vol: 144.10222775,
        last: 1869.00000000,
        buy: 1845.90001000,
        sell: 1867.99999000,
        date: Time.at(1450379846)
      })
    end
  end

  context 'litecoin' do
    let(:kind) { :litecoin }
    it '#fetch' do
      expect(subject).to receive(:get).with('https://www.mercadobitcoin.net/api/ticker_litecoin').once.and_return(valid.to_json)
      expect(subject.fetch.to_hash).to eq({
        high: 1870.00000000,
        low: 1783.35001000,
        vol: 144.10222775,
        last: 1869.00000000,
        buy: 1845.90001000,
        sell: 1867.99999000,
        date: Time.at(1450379846)
      })
    end
  end
end
