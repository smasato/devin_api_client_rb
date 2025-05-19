# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Endpoints::Attachment do
  subject { client }

  describe '#upload_file' do
    let(:file) { double('File', path: '/tmp/test.txt') }
    let(:upload_io) { double('Faraday::UploadIO') }

    before do
      allow(File).to receive(:basename).with('/tmp/test.txt').and_return('test.txt')
      allow(Faraday::UploadIO).to receive(:new)
        .with('/tmp/test.txt', 'application/octet-stream', 'test.txt')
        .and_return(upload_io)

      allow(subject.connection).to receive(:post)
        .with('/v1/attachments', { file: upload_io })
        .and_return(double('Response', body: 'https://example.com/file-123'))
    end

    it 'should upload a file' do
      response = subject.upload_file(file)
      expect(response).to eq('https://example.com/file-123')
    end
  end
end
