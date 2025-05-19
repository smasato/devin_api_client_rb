# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Client do
  subject { client }

  context '#initialize' do
    it 'should require a block' do
      expect { DevinApi::Client.new }.to raise_error(ArgumentError)
    end

    it 'should raise an exception when url is not provided' do
      expect do
        DevinApi::Client.new do |config|
          config.access_token = 'test_token'
        end
      end.to raise_error(ArgumentError, 'url must be provided')
    end

    it 'should raise an exception when access_token is not provided' do
      expect do
        DevinApi::Client.new do |config|
          config.url = 'https://api.example.com'
        end
      end.to raise_error(ArgumentError, 'access_token must be provided')
    end

    it 'should handle valid url and access_token' do
      expect do
        DevinApi::Client.new do |config|
          config.url = 'https://api.example.com'
          config.access_token = 'test_token'
        end
      end.not_to raise_error
    end
  end

  context '#connection' do
    it 'should initially be nil' do
      expect(subject.instance_variable_get(:@connection)).to be_nil
    end

    it 'connection should be initialized on first call to #connection' do
      expect(subject.connection).to be_instance_of(Faraday::Connection)
    end

    it 'should configure Authorization header with access token' do
      expect(subject.connection.headers['Authorization']).to eq('Bearer test_token')
    end
  end

  context 'endpoints' do
    before do
      stub_json_request(:get, 'https://api.example.com/v1/sessions')
        .to_return(status: 200, body: '{"sessions":[]}', headers: { 'Content-Type' => 'application/json' })

      stub_json_request(:get, 'https://api.example.com/v1/secrets')
        .to_return(status: 200, body: '{"secrets":[]}', headers: { 'Content-Type' => 'application/json' })

      stub_json_request(:get, 'https://api.example.com/v1/knowledges')
        .to_return(status: 200, body: '{"knowledges":[]}', headers: { 'Content-Type' => 'application/json' })
    end

    it 'should return an instance of DevinApi::Collection for sessions' do
      expect(subject.sessions).to be_instance_of(DevinApi::Collection)
    end

    it 'should return an instance of DevinApi::Collection for secrets' do
      expect(subject.secrets).to be_instance_of(DevinApi::Collection)
    end

    it 'should return an instance of DevinApi::Collection for knowledge' do
      expect(subject.knowledge).to be_instance_of(DevinApi::Collection)
    end

    it 'should raise error for non-existent endpoint' do
      expect { subject.non_existent }.to raise_error(NoMethodError)
    end
  end
end
