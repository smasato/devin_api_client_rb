# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Endpoints::Knowledge do
  subject { client }

  it 'should respond to knowledge method' do
    expect(subject).to respond_to(:knowledge)
  end

  it 'should return a DevinApi::Collection for knowledge' do
    expect(subject.knowledge).to be_a(DevinApi::Collection)
  end

  it 'should set the correct resource class for the collection' do
    expect(subject.knowledge.instance_variable_get(:@resource_class)).to eq(DevinApi::Resources::Knowledge)
  end

  describe '#list_knowledge' do
    before do
      stub_request(:get, 'https://api.example.com/v1/knowledge')
        .to_return(
          status: 200,
          body: '{
            "knowledge":[
              {
                "id":"note-xxx",
                "name":"Getting the weather",
                "body":"Navigate to weather.com",
                "trigger_description":"When the user asks about the weather",
                "parent_folder_id":"folder-xxx",
                "created_at":"2024-01-01T00:00:00Z"
              }
            ],
            "folders":[
              {
                "id":"folder-xxx",
                "name":"Fetching data",
                "description":"Knowledge related to what websites or APIs to use for fetching data",
                "created_at":"2024-01-01T00:00:00Z"
              }
            ]
          }',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should list knowledge and folders' do
      response = subject.list_knowledge
      expect(response).to be_a(Hash)
      expect(response['knowledge']).to be_an(Array)
      expect(response['knowledge'].first['id']).to eq('note-xxx')
      expect(response['knowledge'].first['name']).to eq('Getting the weather')
      expect(response['folders']).to be_an(Array)
      expect(response['folders'].first['id']).to eq('folder-xxx')
      expect(response['folders'].first['name']).to eq('Fetching data')
    end
  end

  describe '#create_knowledge' do
    before do
      stub_request(:post, 'https://api.example.com/v1/knowledge')
        .with(
          body: {
            body: 'Navigate to weather.com',
            name: 'Getting the weather',
            trigger_description: 'When the user asks about the weather',
            parent_folder_id: 'folder-xxx'
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(
          status: 200,
          body: '{
            "id":"note-xxx",
            "name":"Getting the weather",
            "body":"Navigate to weather.com",
            "trigger_description":"When the user asks about the weather",
            "parent_folder_id":"folder-xxx",
            "created_at":"2024-01-01T00:00:00Z"
          }',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should create knowledge' do
      knowledge = subject.create_knowledge(
        body: 'Navigate to weather.com',
        name: 'Getting the weather',
        trigger_description: 'When the user asks about the weather',
        parent_folder_id: 'folder-xxx'
      )
      expect(knowledge).to be_a(Hash)
      expect(knowledge['id']).to eq('note-xxx')
      expect(knowledge['name']).to eq('Getting the weather')
      expect(knowledge['body']).to eq('Navigate to weather.com')
      expect(knowledge['trigger_description']).to eq('When the user asks about the weather')
      expect(knowledge['parent_folder_id']).to eq('folder-xxx')
    end
  end

  describe '#update_knowledge' do
    before do
      stub_request(:put, 'https://api.example.com/v1/knowledge/note-xxx')
        .with(
          body: {
            body: 'Navigate to weather.com or use the weather API',
            name: 'Getting the weather',
            trigger_description: 'When the user asks about the weather or forecast'
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(
          status: 200,
          body: '{
            "id":"note-xxx",
            "name":"Getting the weather",
            "body":"Navigate to weather.com or use the weather API",
            "trigger_description":"When the user asks about the weather or forecast",
            "parent_folder_id":"folder-xxx",
            "created_at":"2024-01-01T00:00:00Z"
          }',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should update knowledge' do
      knowledge = subject.update_knowledge(
        'note-xxx',
        body: 'Navigate to weather.com or use the weather API',
        name: 'Getting the weather',
        trigger_description: 'When the user asks about the weather or forecast'
      )
      expect(knowledge).to be_a(Hash)
      expect(knowledge['id']).to eq('note-xxx')
      expect(knowledge['body']).to eq('Navigate to weather.com or use the weather API')
      expect(knowledge['trigger_description']).to eq('When the user asks about the weather or forecast')
    end
  end

  describe '#delete_knowledge' do
    before do
      stub_request(:delete, 'https://api.example.com/v1/knowledge/note-xxx')
        .to_return(
          status: 204,
          body: nil,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should delete knowledge' do
      response = subject.delete_knowledge('note-xxx')
      expect(response).to be_nil
    end
  end
end
