require 'spec_helper'

RSpec.shared_examples 'a bitcoin' do
  it { expect(subject.bitcoin?).to eq(true) }
  it { expect(subject.litecoin?).to eq(false) }
  it { expect(subject.valid_coin?).to eq(true) }
  it { expect(subject.coin).to eq(:bitcoin) }
end

RSpec.shared_examples 'a litecoin' do
  it { expect(subject.bitcoin?).to eq(false) }
  it { expect(subject.litecoin?).to eq(true) }
  it { expect(subject.valid_coin?).to eq(true) }
  it { expect(subject.coin).to eq(:litecoin) }
end

RSpec.describe MercadoBitcoin::BaseApiCall, type: :service do
  let(:coin) { :bitcoin }
  let(:params) { {} }
  subject { described_class.new(coin, params) }

  context 'abstract methods' do
    it '#model' do
      expect { subject.model }.to raise_error(NotImplementedError)
    end

    it '#base_url' do
      expect { subject.base_url }.to raise_error(NotImplementedError)
    end
  end

  context '#coin' do
    context 'bitcoin' do
      let(:coin) { :bitcoin }
      it_behaves_like 'a bitcoin'

      context 'string version' do
        let(:coin) { 'bitcoin' }
        it_behaves_like 'a bitcoin'
      end

      context 'string version' do
        let(:coin) { 'BITCOIN' }
        it_behaves_like 'a bitcoin'
      end
    end

    context 'litecoin' do
      let(:coin) { :litecoin }
      it_behaves_like 'a litecoin'
      context 'string version' do
        let(:coin) { 'litecoin' }
        it_behaves_like 'a litecoin'
      end

      context 'string version' do
        let(:coin) { 'LITECOIN' }
        it_behaves_like 'a litecoin'
      end
    end

    context 'coin' do
      let(:coin) { :invalid }
      it { expect { subject }.to raise_error("bitcoin or litecoin expected #{coin} received") }
    end
  end

  context '#url' do
    it 'return base_url + action' do
      allow(subject).to receive(:base_url).and_return('http://somewhere.com')
      allow(subject).to receive(:action).and_return('some')
      expect(subject.url).to eq('http://somewhere.com/some')
    end

    it 'return base_url' do
      allow(subject).to receive(:base_url).and_return('http://somewhere.com')
      expect(subject.url).to eq('http://somewhere.com')
    end
  end

  it '#get' do
    url = 'http://url.to'
    allow(subject).to receive(:url).and_return(url)
    expect(subject).to receive_message_chain(:rest_client, :get).with(url).and_return(:response)
    expect(subject.get(url)).to eq(:response)
  end

  context '#parse' do
    it 'valid' do
      expect(subject.parse({ a:1 }.to_json)).to eq('a' => 1)
    end

    it 'invalid' do
      allow(subject).to receive(:url).and_return('some url')
      expect { subject.parse('') }.to raise_error(MercadoBitcoin::ParserError)
    end
  end
end