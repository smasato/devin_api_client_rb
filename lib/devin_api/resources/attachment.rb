# frozen_string_literal: true

require 'devin_api/resources/base'

module DevinApi
  module Resources
    # Attachment resource for the Devin API
    class Attachment < Base
      def path
        '/v1/attachments'
      end

      def upload_file(file)
        payload = Faraday::UploadIO.new(
          file.path,
          file.content_type || 'application/octet-stream',
          File.basename(file.path)
        )

        client.connection.post(path, payload).body
      end
    end
  end
end
