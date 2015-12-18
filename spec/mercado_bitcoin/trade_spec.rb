require 'spec_helper'

RSpec.describe MercadoBitcoin::Trade, type: :service do
  let(:params) { {} }
  let(:coin) { :bitcoin }

  let(:valid_json) { '[{"date":1450299887,"price":1820.00000000,"amount":0.05225824,"tid":186889, "type":"buy"},{"date":1450299925,"price":1820.00000000,"amount":0.12661931,"tid":186890, "type":"sell"}]' }

  subject { described_class.new(coin, params) }

  it '#fetch' do
    allow(subject).to receive(:get).with('https://www.mercadobitcoin.net/api/trades').and_return(valid_json)
    ret = subject.fetch
    expect(ret.count).to eq(2)
    expect(ret[0].to_hash).to eq({
      date: Time.at(1450299887),
      price: 1820.0,
      amount: 0.05225824,
      tid: 186889,
      type: 'buy'
    })

    expect(ret[1].to_hash).to eq({
      date: Time.at(1450299925),
      price: 1820.0,
      amount: 0.12661931,
      tid: 186890,
      type: 'sell'
    })
  end

  context 'litecoin' do
    let(:coin) { :litecoin }

    it '#fetch' do
      allow(subject).to receive(:get).with('https://www.mercadobitcoin.net/api/trades_litecoin').and_return(valid_json)
      ret = subject.fetch
      expect(ret.count).to eq(2)
    end
  end
end