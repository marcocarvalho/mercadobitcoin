require 'spec_helper'

RSpec.describe MercadoBitcoin::Api::Data::OrderBook, type: :model do
  let(:options) { { } }

  subject { described_class.new(options) }

  it 'empty' do
    expect(subject.asks).to eq([])
    expect(subject.bids).to eq([])
  end
end