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
end