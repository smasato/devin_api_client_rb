# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Endpoints::Session do
  subject { client }

  describe '#get_session' do
    before do
      stub_request(:get, 'https://api.example.com/v1/session/devin-xxx')
        .to_return(
          status: 200,
          body: '{
            "session_id":"devin-xxx",
            "status":"running",
            "title":"Review PR #123",
            "created_at":"2024-01-01T00:00:00Z",
            "updated_at":"2024-01-01T00:01:00Z",
            "snapshot_id":null,
            "playbook_id":null,
            "pull_request":{"url":"https://github.com/example/repo/pull/123"},
            "structured_output":"Task completed successfully",
            "status_enum":"RUNNING"
          }',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should get session details' do
      session = subject.get_session('devin-xxx')
      expect(session).to be_a(Hash)
      expect(session['session_id']).to eq('devin-xxx')
      expect(session['status']).to eq('running')
      expect(session['title']).to eq('Review PR #123')
    end
  end

  describe '#send_message' do
    before do
      stub_request(:post, 'https://api.example.com/v1/session/devin-xxx/message')
        .with(
          body: { message: 'Can you explain this code?' }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(
          status: 200,
          body: '{"message_id":"msg-123","session_id":"devin-xxx","status":"sent"}',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should send a message to a session' do
      response = subject.send_message('devin-xxx', message: 'Can you explain this code?')
      expect(response).to be_a(Hash)
      expect(response['message_id']).to eq('msg-123')
      expect(response['session_id']).to eq('devin-xxx')
      expect(response['status']).to eq('sent')
    end
  end

  describe '#update_session_tags' do
    before do
      stub_request(:put, 'https://api.example.com/v1/session/devin-xxx/tags')
        .with(
          body: { tags: %w[web api] }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(
          status: 200,
          body: '{"session_id":"devin-xxx","tags":["web","api"]}',
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'should update session tags' do
      response = subject.update_session_tags('devin-xxx', tags: %w[web api])
      expect(response).to be_a(Hash)
      expect(response['session_id']).to eq('devin-xxx')
      expect(response['tags']).to eq(%w[web api])
    end
  end
end
