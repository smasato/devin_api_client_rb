# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Resources::Attachment do
  let(:attributes) { { 'id' => 'file-123', 'filename' => 'test.txt' } }
  subject { DevinApi::Resources::Attachment.new(client, attributes) }

  describe '.pagination_supported?' do
    it 'returns false' do
      expect(DevinApi::Resources::Attachment.pagination_supported?).to be(false)
    end
  end

  describe '#initialize' do
    it 'inherits from Base resource' do
      expect(subject).to be_a(DevinApi::Resources::Base)
    end

    it 'sets attributes' do
      expect(subject.id).to eq('file-123')
      expect(subject.filename).to eq('test.txt')
    end
  end

  describe '#upload_file' do
    let(:file) { double('File', path: '/tmp/test.txt') }
    let(:upload_io) { double('Faraday::UploadIO') }

    before do
      allow(File).to receive(:basename).with('/tmp/test.txt').and_return('test.txt')
      allow(Faraday::UploadIO).to receive(:new)
        .with('/tmp/test.txt', 'application/octet-stream', 'test.txt')
        .and_return(upload_io)

      allow(client.connection).to receive(:post)
        .with('/v1/attachments', { file: upload_io })
        .and_return(double('Response', body: 'https://example.com/file-123'))
    end

    it 'should upload a file' do
      response = subject.upload_file(file)
      expect(response).to eq('https://example.com/file-123')
    end
  end
end
