# frozen_string_literal: true

require 'devin_api/resources/base'

module DevinApi
  module Resources
    # Knowledge resource for the Devin API
    class Knowledge < Base
      def path
        "/v1/knowledge/#{id}"
      end

      def update(attributes = {})
        client.put(path, attributes)
      end

      def delete
        client.delete(path)
      end
    end
  end
end
