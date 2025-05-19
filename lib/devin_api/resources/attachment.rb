# frozen_string_literal: true

require 'devin_api/resources/base'

module DevinApi
  module Resources
    # Attachment resource for the Devin API
    class Attachment < Base
      def path
        '/v1/attachments'
      end

      # Upload a file for Devin to work with during sessions
      # @see https://docs.devin.ai/api-reference/attachments/upload-files-for-devin-to-work-with
      #
      # @param [File] file File object to upload
      # @return [String] URL where the uploaded file can be accessed
      def upload_file(file)
        payload = { file: Faraday::UploadIO.new(file.path, 'application/octet-stream', File.basename(file.path)) }

        client.connection.post(path, payload).body
      end
    end
  end
end
