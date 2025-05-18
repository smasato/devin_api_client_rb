# frozen_string_literal: true

module DevinApi
  module Endpoints
    # Attachment endpoints for the Devin API
    module Attachment
      # Upload a file for Devin to work with during sessions
      # @see https://docs.devin.ai/api-reference/attachments/upload-files-for-devin-to-work-with
      #
      # @param [File] file File object to upload
      # @return [Hash] Response body
      def upload_file(file)
        payload = Faraday::UploadIO.new(
          file.path,
          file.content_type || 'application/octet-stream',
          File.basename(file.path)
        )

        connection.post('/v1/attachments', payload).body
      end
    end
  end
end
