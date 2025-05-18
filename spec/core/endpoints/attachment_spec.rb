# frozen_string_literal: true

require 'core/spec_helper'

RSpec.describe DevinApi::Endpoints::Attachment do
  subject { client }

  describe '#upload_file' do
    let(:file) { double('File', path: '/tmp/test.txt', content_type: 'text/plain') }

    before do
      allow(File).to receive(:basename).with('/tmp/test.txt').and_return('test.txt')
      allow(Faraday::UploadIO).to receive(:new).with('/tmp/test.txt', 'text/plain', 'test.txt')
                                               .and_return('file_content')

      allow(subject.connection).to receive(:post).with('/v1/attachments', 'file_content').and_return(
        double('Response', body: { 'file_id' => 'file-123', 'filename' => 'test.txt' })
      )
    end

    it 'should upload a file' do
      response = subject.upload_file(file)
      expect(response).to be_a(Hash)
      expect(response['file_id']).to eq('file-123')
      expect(response['filename']).to eq('test.txt')
    end
  end
end
