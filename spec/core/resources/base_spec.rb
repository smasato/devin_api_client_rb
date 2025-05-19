# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Resources::Base do
  let(:client) do
    DevinApi::Client.new do |config|
      config.url = 'https://api.devin.com'
      config.access_token = 'test_token'
    end
  end

  let(:attributes) { { 'id' => 1, 'name' => 'Test Resource' } }
  subject { DevinApi::Resources::Base.new(client, attributes) }

  describe '.pagination_supported?' do
    it 'returns false by default' do
      expect(DevinApi::Resources::Base.pagination_supported?).to be(false)
    end
  end

  describe '#initialize' do
    it 'sets client instance' do
      expect(subject.client).to eq(client)
    end

    it 'sets attributes' do
      expect(subject.attributes).to eq(attributes)
    end
  end

  describe '#method_missing' do
    it 'returns attribute value when attribute exists' do
      expect(subject.name).to eq('Test Resource')
    end

    it 'returns nil when attribute does not exist' do
      expect(subject.description).to be_nil
    end
  end

  describe '#[]' do
    it 'returns attribute value when attribute exists' do
      expect(subject['name']).to eq('Test Resource')
    end

    it 'returns nil when attribute does not exist' do
      expect(subject['description']).to be_nil
    end
  end

  describe '#id' do
    it 'returns id attribute' do
      expect(subject.id).to eq(1)
    end
  end

  describe '#to_hash' do
    it 'returns attributes hash' do
      expect(subject.to_hash).to eq(attributes)
    end
  end
end
