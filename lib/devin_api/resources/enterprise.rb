# frozen_string_literal: true

require 'devin_api/resources/base'

module DevinApi
  module Resources
    # Enterprise resource for the Devin API
    class Enterprise < Base
      def path
        '/v1/enterprise'
      end

      def audit_logs(params = {})
        client.get("#{path}/audit-logs", params)
      end

      def consumption(params = {})
        client.get("#{path}/consumption", params)
      end
    end
  end
end
