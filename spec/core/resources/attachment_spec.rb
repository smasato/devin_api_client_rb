# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Resources::Attachment do
  let(:attributes) { { 'id' => 'file-123', 'filename' => 'test.txt' } }
  subject { DevinApi::Resources::Attachment.new(client, attributes) }

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
    let(:file) { double('File', path: '/tmp/test.txt', content_type: 'text/plain') }

    before do
      allow(File).to receive(:basename).with('/tmp/test.txt').and_return('test.txt')
      allow(Faraday::UploadIO).to receive(:new).with('/tmp/test.txt', 'text/plain', 'test.txt')
                                               .and_return('file_content')

      allow(client.connection).to receive(:post).with('/v1/attachments', 'file_content').and_return(
        double('Response', body: { 'id' => 'file-123', 'filename' => 'test.txt' })
      )
    end

    it 'should upload a file' do
      response = subject.upload_file(file)
      expect(response).to be_a(Hash)
      expect(response['id']).to eq('file-123')
      expect(response['filename']).to eq('test.txt')
    end
  end
end
