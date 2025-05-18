# frozen_string_literal: true

module DevinApi
  module Endpoints
    # Enterprise endpoints for the Devin API
    module Enterprise
      # Get enterprise collection
      #
      # @param [Hash] options Query parameters
      # @return [DevinApi::Collection] Collection of enterprise resources
      def enterprise(options = {})
        Collection.new(self, DevinApi::Resources::Enterprise, options)
      end

      # List all audit logs
      # @see https://docs.devin.ai/api-reference/audit-logs/list-audit-logs
      #
      # @param [Hash] params Query parameters
      # @option params [Integer] :limit Maximum number of logs to return (default: 100, min: 1)
      # @option params [String] :before Filter logs before a specific timestamp
      # @option params [String] :after Filter logs after a specific timestamp
      # @return [Hash] Response body with audit logs
      def list_audit_logs(params = {})
        get('/v1/enterprise/audit-logs', params)
      end

      # Get enterprise consumption data
      # @see https://docs.devin.ai/api-reference/enterprise/get-enterprise-consumption-data
      #
      # @param [Hash] params Query parameters
      # @option params [String] :period Period for consumption data (e.g., 'current_month', 'previous_month')
      # @option params [String] :start_date Start date for custom period (ISO 8601 format)
      # @option params [String] :end_date End date for custom period (ISO 8601 format)
      # @return [Hash] Response body with consumption data
      def get_enterprise_consumption(params = {})
        get('/v1/enterprise/consumption', params)
      end
    end
  end
end
