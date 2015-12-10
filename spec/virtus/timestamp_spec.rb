require 'spec_helper'

class SomeObject
  include Virtus.model

  attribute :time, Timestamp
end

RSpec.shared_examples 'a timestamp attribute' do |result|
  it { expect(subject.time).to eq(result) }
end

RSpec.describe SomeObject, type: :class do
  subject { described_class.new(time: value) }

  context 'coerce fixnum' do
    let(:value) { 1449708736 }
    it_behaves_like 'a timestamp attribute', Time.parse('2015-12-10 00:52:16') 
  end

  context 'accept time' do
    let(:value) { Time.new(2015, 12, 15) }
    it_behaves_like 'a timestamp attribute', Time.new(2015, 12, 15) 
  end

  context 'invalid value' do
    let(:value) { 'string' }
    it 'raise exception' do
      expect { subject.time }.to raise_error('String cannot be coerced to Time')
    end
  end
end