require 'spec_helper'

RSpec.describe 'refinement' do
  using MercadoBitcoin::QueryStringRefinement

  it 'to_query_string' do
    expect({a:1,b:2}.to_query_string).to eq('a=1&b=2')
  end
end