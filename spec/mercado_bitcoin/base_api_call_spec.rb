require 'spec_helper'

RSpec.describe MercadoBitcoin::BaseApiCall, type: :service do
  let(:coin) { :bitcoin }
  let(:params) { {} }
  subject { described_class.new(coin, params) }

  context 'abstract methods' do
    it '#model' do
      expect { subject.model }.to raise_error(NotImplementedError)
    end

    it '#action' do
      expect { subject.action }.to raise_error(NotImplementedError)
    end

    it '#base_url' do
      expect { subject.base_url }.to raise_error(NotImplementedError)
    end
  end
end