# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Resources::Knowledge do
  let(:client) do
    DevinApi::Client.new do |config|
      config.url = 'https://api.devin.ai'
      config.access_token = 'test_token'
    end
  end

  let(:attributes) { { 'id' => 'k-123', 'title' => 'Test Document', 'content' => 'Test content' } }
  subject { DevinApi::Resources::Knowledge.new(client, attributes) }

  describe '#initialize' do
    it 'inherits from Base resource' do
      expect(subject).to be_a(DevinApi::Resources::Base)
    end

    it 'sets attributes' do
      expect(subject.id).to eq('k-123')
      expect(subject.title).to eq('Test Document')
      expect(subject.content).to eq('Test content')
    end
  end

  describe '#create' do
    before do
      allow(client).to receive(:post).and_return(
        { 'id' => 'k-456', 'title' => 'New Document', 'content' => 'New content' }
      )
    end

    it 'creates a new knowledge item' do
      knowledge = DevinApi::Resources::Knowledge.create(client, title: 'New Document', content: 'New content')
      expect(knowledge).to be_a(DevinApi::Resources::Knowledge)
      expect(knowledge.id).to eq('k-456')
      expect(knowledge.title).to eq('New Document')
      expect(knowledge.content).to eq('New content')
    end
  end

  describe '#update' do
    before do
      allow(client).to receive(:put).with('/v1/knowledge/k-123', { title: 'Updated Document' }).and_return(
        { 'id' => 'k-123', 'title' => 'Updated Document', 'content' => 'Test content' }
      )
    end

    it 'updates a knowledge item' do
      response = subject.update(title: 'Updated Document')
      expect(response).to be_a(Hash)
      expect(response['id']).to eq('k-123')
      expect(response['title']).to eq('Updated Document')
      expect(response['content']).to eq('Test content')
    end
  end

  describe '#delete' do
    before do
      allow(client).to receive(:delete).with('/v1/knowledge/k-123').and_return(
        { 'id' => 'k-123', 'status' => 'deleted' }
      )
    end

    it 'deletes a knowledge item' do
      response = subject.delete
      expect(response).to be_a(Hash)
      expect(response['id']).to eq('k-123')
      expect(response['status']).to eq('deleted')
    end
  end
end
