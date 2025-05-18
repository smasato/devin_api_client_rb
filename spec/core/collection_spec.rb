# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Collection do
  subject { DevinApi::Collection.new(client, DevinApi::Resources::Session) }

  context 'initialization' do
    it 'should set the resource class' do
      expect(subject.instance_variable_get(:@resource_class)).to eq(DevinApi::Resources::Session)
    end

    it 'should initially be empty' do
      expect(subject.instance_variable_defined?(:@resources)).to be(false)
    end
  end

  context 'with array option passed in' do
    subject { DevinApi::Collection.new(client, DevinApi::Resources::Session, ids: [1, 2, 3, 4]) }

    it 'should join array with commas' do
      expect(subject.instance_variable_get(:@options)[:ids]).to eq('1,2,3,4')
    end
  end

  context 'fetching resources' do
    before do
      stub_request(:get, 'https://api.devin.ai/v1/sessions')
        .to_return(
          status: 200,
          body: '{"sessions":[{"id":"s-123","session_id":"s-123","status":"active"},
                 {"id":"s-456","session_id":"s-456","status":"inactive"}]}',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should fetch resources from API' do
      resources = subject.fetch
      expect(resources.length).to eq(2)
      expect(resources.first).to be_a(DevinApi::Resources::Session)
      expect(resources.first.id).to eq('s-123')
      expect(resources.first.status).to eq('active')
      expect(resources.last.id).to eq('s-456')
      expect(resources.last.status).to eq('inactive')
    end
  end

  context 'creating resources' do
    before do
      stub_request(:post, 'https://api.devin.ai/v1/sessions')
        .with(
          headers: { 'Authorization' => 'Bearer test_token', 'Content-Type' => 'application/json' },
          body: { 'name' => 'New Session' }.to_json
        )
        .to_return(
          status: 201,
          body: '{"id":"s-789","session_id":"s-789","name":"New Session","status":"active"}',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should create a resource via API' do
      resource = subject.create(name: 'New Session')
      expect(resource).to be_a(DevinApi::Resources::Session)
      expect(resource.id).to eq('s-789')
      expect(resource.name).to eq('New Session')
      expect(resource.status).to eq('active')
    end
  end

  context 'finding a resource' do
    before do
      stub_request(:get, 'https://api.devin.ai/v1/sessions/s-123')
        .to_return(
          status: 200,
          body: '{"id":"s-123","session_id":"s-123","status":"active"}',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should find a resource by ID' do
      resource = subject.find(id: 's-123')
      expect(resource).to be_a(DevinApi::Resources::Session)
      expect(resource.id).to eq('s-123')
      expect(resource.status).to eq('active')
    end
  end
end
