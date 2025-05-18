# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Endpoints::Secrets do
  subject { client }

  it 'should respond to secrets method' do
    expect(subject).to respond_to(:secrets)
  end

  it 'should return a DevinApi::Collection for secrets' do
    expect(subject.secrets).to be_a(DevinApi::Collection)
  end

  it 'should set the correct resource class for the collection' do
    expect(subject.secrets.instance_variable_get(:@resource_class)).to eq(DevinApi::Resources::Secret)
  end

  describe '#list_secrets' do
    before do
      stub_request(:get, 'https://api.devin.ai/v1/secrets')
        .to_return(
          status: 200,
          body: '{
            "secrets":[
              {
                "secret_id":"sec_xxx",
                "secret_type":"key-value",
                "secret_name":"API Access Token",
                "created_at":"2024-01-01T00:00:00Z"
              }
            ]
          }',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should list secrets metadata' do
      secrets = subject.list_secrets
      expect(secrets).to be_a(Hash)
      expect(secrets['secrets']).to be_an(Array)
      expect(secrets['secrets'].first['secret_id']).to eq('sec_xxx')
      expect(secrets['secrets'].first['secret_type']).to eq('key-value')
      expect(secrets['secrets'].first['secret_name']).to eq('API Access Token')
    end
  end

  describe '#delete_secret' do
    before do
      stub_request(:delete, 'https://api.devin.ai/v1/secrets/sec_xxx')
        .to_return(
          status: 204,
          body: nil,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should delete a secret' do
      response = subject.delete_secret('sec_xxx')
      expect(response).to be_nil
    end
  end
end
