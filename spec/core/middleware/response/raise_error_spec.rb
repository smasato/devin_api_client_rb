# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Middleware::Response::RaiseError do
  context 'with a failed connection' do
    context 'connection failed' do
      before(:each) do
        stub_request(:any, /.*/).to_raise(Faraday::ConnectionFailed)
      end

      it 'should raise ClientError' do
        expect { client.connection.get('/test') }.to raise_error(DevinApi::Error::ClientError)
      end
    end

    context 'connection timeout' do
      before(:each) do
        stub_request(:any, /.*/).to_timeout
      end

      it 'should raise ClientError' do
        expect { client.connection.get('/test') }.to raise_error(DevinApi::Error::ClientError)
      end
    end
  end

  context 'status errors' do
    let(:body) { '' }

    before(:each) do
      stub_request(:any, /.*/).to_return(
        status: status,
        body: body,
        headers: { content_type: 'application/json' }
      )
    end

    context 'with status = 404' do
      let(:status) { 404 }

      it 'should raise NotFound when status is 404' do
        expect { client.connection.get('/test') }.to raise_error(DevinApi::Error::NotFound)
      end
    end

    context 'with status = 401' do
      let(:status) { 401 }

      it 'should raise Unauthorized when status is 401' do
        expect { client.connection.get('/test') }.to raise_error(DevinApi::Error::Unauthorized)
      end
    end

    context 'with status = 403' do
      let(:status) { 403 }

      it 'should raise Forbidden when status is 403' do
        expect { client.connection.get('/test') }.to raise_error(DevinApi::Error::Forbidden)
      end
    end

    context 'with status = 400' do
      let(:status) { 400 }

      it 'should raise BadRequest when status is 400' do
        expect { client.connection.get('/test') }.to raise_error(DevinApi::Error::BadRequest)
      end
    end

    context 'with status = 429' do
      let(:status) { 429 }

      it 'should raise RateLimited when status is 429' do
        expect { client.connection.get('/test') }.to raise_error(DevinApi::Error::RateLimited)
      end
    end

    context 'with status = 500' do
      let(:status) { 500 }

      it 'should raise ServerError when status is 500' do
        expect { client.connection.get('/test') }.to raise_error(DevinApi::Error::ServerError)
      end
    end

    context 'with status = 200' do
      let(:status) { 200 }

      it 'should not raise error' do
        expect { client.connection.get('/test') }.not_to raise_error
      end
    end
  end
end
