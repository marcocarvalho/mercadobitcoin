require 'spec_helper'

RSpec.describe MercadoBitcoin::TradeApi, type: :service do
  let(:key) { '123a43faae38b687d189fe883ed7c577' }
  let(:code) { 'c011cb73f9709999effb1f89da8e9e679059abcdfcf1a0e6387d13ab909054cc' }
  subject { described_class.new(key: key, code: code) }

  it 'sign' do
    expect(subject.sign('blibibi')).to eq('86a3bda71204a63a148e5deffa531c7bd1e03ce7c9da3e3210f8b50be9307c7ce3ac639e8110699495ff66e1282cc4de979f104864bde206711741e208fe726b')
  end
end