# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Error do
  describe DevinApi::Error::ClientError do
    it 'works without a response' do
      expect(DevinApi::Error::ClientError.new('test error').message).to eq('test error')
    end

    it 'includes status code in message with response' do
      response = { status: 400, body: {} }
      expect(DevinApi::Error::ClientError.new(response).message).to eq('Status: 400')
    end

    it 'includes error message from response body' do
      response = { status: 400, body: { 'error' => 'Bad request error' } }
      expect(DevinApi::Error::ClientError.new(response).message).to eq('Status: 400 - Bad request error')
    end
  end

  describe DevinApi::Error::BadRequest do
    it 'is a subclass of ClientError' do
      expect(DevinApi::Error::BadRequest.new).to be_a(DevinApi::Error::ClientError)
    end
  end

  describe DevinApi::Error::Unauthorized do
    it 'is a subclass of ClientError' do
      expect(DevinApi::Error::Unauthorized.new).to be_a(DevinApi::Error::ClientError)
    end
  end

  describe DevinApi::Error::NotFound do
    it 'is a subclass of ClientError' do
      expect(DevinApi::Error::NotFound.new).to be_a(DevinApi::Error::ClientError)
    end
  end

  describe DevinApi::Error::ServerError do
    it 'is a subclass of Error' do
      expect(DevinApi::Error::ServerError.new).to be_a(DevinApi::Error::Error)
    end
  end
end
