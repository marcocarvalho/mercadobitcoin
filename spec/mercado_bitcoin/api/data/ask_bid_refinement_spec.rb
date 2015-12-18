require 'spec_helper'

RSpec.describe MercadoBitcoin::Api::Data::AskBidRefinement, type: :refinement do
  using MercadoBitcoin::Api::Data::AskBidRefinement
  subject { [1, 2] }

  it '#to_model_hash' do
    expect(subject.to_model_hash).to eq({ price: 1, volume: 2 })
  end
end