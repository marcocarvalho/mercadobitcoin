require 'spec_helper'

RSpec.describe MercadoBitcoin::Api::Data::Trade, type: :model do
  let(:time) { Time.at(Time.new.to_i) }

  let(:valid) do
    {
      price: '10.3',
      amount: 1,
      tid: '123123',
      type: 'sell',
      date: time.to_i
    }
  end

  subject { described_class.new(valid) }

  it 'to_hash' do
    expect(subject.to_hash).to eq({
      price: 10.3,
      amount: 1.0,
      tid: 123123,
      type: 'sell',
      date: time
    })
  end

  it 'to_json' do
    expect(subject.to_json).to eq({
      price: 10.3,
      amount: 1.0,
      tid: 123123,
      type: 'sell',
      date: time
    }.to_json)    
  end

  it '#price' do
    expect(subject.price).to eq(10.3)
  end

  it '#amount' do
    expect(subject.amount).to eq(1.0)
  end

  it '#tid' do
    expect(subject.tid).to eq(123123)
  end

  it '#type' do
    expect(subject.type).to eq('sell')
  end

  it '#date' do
    expect(subject.date).to eq(time)
  end

  it 'invalid tid' do
    s = described_class.new(tid: 'abc')
    expect(s.tid).to eq('abc')
    s = described_class.new(tid: '123')
    expect(s.tid).to eq(123)    
  end
end