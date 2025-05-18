# frozen_string_literal: true

require 'devin_api/resources/base'

module DevinApi
  module Resources
    # Secret resource for the Devin API
    class Secret < Base
      def path
        "/v1/secrets/#{id}"
      end

      def delete
        client.delete(path)
      end
    end
  end
end
