# frozen_string_literal: true

require 'devin_api/resources/base'

module DevinApi
  module Resources
    # Session resource for the Devin API
    class Session < Base
      def self.pagination_supported?
        true
      end

      def path
        "/v1/session/#{session_id}"
      end

      def send_message(message)
        client.post("#{path}/message", { message: message })
      end

      def update_tags(tags)
        client.put("#{path}/tags", { tags: tags })
      end
    end
  end
end
