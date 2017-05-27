require 'spec_helper'

RSpec.describe MercadoBitcoin::TradeApi, type: :service do
  let(:key) { '123a43faae38b687d189fe883ed7c577' }
  let(:code) { 'c011cb73f9709999effb1f89da8e9e679059abcdfcf1a0e6387d13ab909054cc' }
  subject { described_class.new(key: key, code: code) }

  it 'sign a string' do
    expect(subject.sign('blibibi')).to eq('86a3bda71204a63a148e5deffa531c7bd1e03ce7c9da3e3210f8b50be9307c7ce3ac639e8110699495ff66e1282cc4de979f104864bde206711741e208fe726b')
  end

  it 'sign a hash' do
    expect(subject.sign({a: 2, b: 'asdasda'})).to eq("5c350cfb3f7d67598f5d4550096814d85462ebfcac0a92f70a1dbeb9bb9ad964e2cb550f5f6d7cbcb4fd4516db1d8ae39afbc0b78293d74f774d0f97b056d0a6")
  end

  it '#get_account_info tapi_nonce error' do
    subject.last_tapi_nonce = 12344
    stub_request(:post, "https://www.mercadobitcoin.net/tapi/v3/")
      .with(body: {"tapi_method"=>"get_account_info", "tapi_nonce"=>"12345"})
      .to_return(status: 200, body: {"status_code"=>203,"error_message"=>"Valor do *tapi_nonce* invalido, valor deve ser maior do que o ultimo utilizado: 123456.","server_unix_timestamp"=>"1495897539"}.to_json)

    stub_request(:post, "https://www.mercadobitcoin.net/tapi/v3/")
      .with(body: {"tapi_method"=>"get_account_info", "tapi_nonce"=>"123457"})
      .to_return(status: 200, body: {"status_code"=>100,"response_data"=>{"dados" => "batutas"}}.to_json)

    expect(subject.get_account_info).to eq({"status_code"=>100, "response_data"=>{"dados"=>"batutas"}})
  end
end
