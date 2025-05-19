# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Resources::Secret do
  let(:attributes) { { 'id' => 'sec-123', 'name' => 'API_KEY', 'value' => 'secret-value' } }
  subject { DevinApi::Resources::Secret.new(client, attributes) }

  describe '.pagination_supported?' do
    it 'returns false' do
      expect(DevinApi::Resources::Secret.pagination_supported?).to be(false)
    end
  end

  describe '#initialize' do
    it 'inherits from Base resource' do
      expect(subject).to be_a(DevinApi::Resources::Base)
    end

    it 'sets attributes' do
      expect(subject.id).to eq('sec-123')
      expect(subject.name).to eq('API_KEY')
      expect(subject.value).to eq('secret-value')
    end
  end

  describe '#create' do
    before do
      stub_request(:post, 'https://api.example.com/v1/secrets')
        .with(
          headers: { 'Authorization' => 'Bearer test_token' },
          body: { 'name' => 'NEW_KEY', 'value' => 'new-value' }
        )
        .to_return(
          status: 201,
          body: '{"id":"sec-456","name":"NEW_KEY","value":"new-value"}',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'creates a new secret' do
      secret = DevinApi::Resources::Secret.create(client, name: 'NEW_KEY', value: 'new-value')
      expect(secret).to be_a(DevinApi::Resources::Secret)
      expect(secret.id).to eq('sec-456')
      expect(secret.name).to eq('NEW_KEY')
      expect(secret.value).to eq('new-value')
    end
  end

  describe '#delete' do
    before do
      stub_request(:delete, 'https://api.example.com/v1/secrets/sec-123')
        .with(headers: { 'Authorization' => 'Bearer test_token' })
        .to_return(
          status: 200,
          body: '{"id":"sec-123","status":"deleted"}',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'deletes a secret' do
      response = subject.delete
      expect(response).to be_a(Hash)
      expect(response['id']).to eq('sec-123')
      expect(response['status']).to eq('deleted')
    end
  end
end
