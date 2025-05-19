# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Resources::Session do
  let(:attributes) { { 'session_id' => 'devin-xxx', 'url' => 'https://app.example.com/sessions/xxx', 'is_new_session' => true } }
  subject { DevinApi::Resources::Session.new(client, attributes) }

  describe '.pagination_supported?' do
    it 'returns true' do
      expect(DevinApi::Resources::Session.pagination_supported?).to be(true)
    end
  end

  describe '#initialize' do
    it 'inherits from Base resource' do
      expect(subject).to be_a(DevinApi::Resources::Base)
    end

    it 'sets attributes' do
      expect(subject.session_id).to eq('devin-xxx')
      expect(subject.url).to eq('https://app.example.com/sessions/xxx')
      expect(subject.is_new_session).to eq(true)
    end
  end

  describe '#create' do
    let(:session_attributes) { { 'session_id' => 'devin-xxx', 'url' => 'https://app.example.com/sessions/xxx', 'is_new_session' => true } }
    before do
      stub_request(:post, 'https://api.example.com/v1/sessions')
        .to_return(
          status: 200,
          body: session_attributes.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'creates a new session' do
      session = DevinApi::Resources::Session.create(client)
      expect(session).to be_a(DevinApi::Resources::Session)
      expect(session.session_id).to eq('devin-xxx')
      expect(session.url).to eq('https://app.example.com/sessions/xxx')
      expect(session.is_new_session).to eq(true)
    end
  end
end
