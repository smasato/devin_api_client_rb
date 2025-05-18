# frozen_string_literal: true

module DevinApi
  module Endpoints
    # Secrets endpoints for the Devin API
    module Secrets
      # List all secrets metadata
      # @see https://docs.devin.ai/api-reference/sessions/list-secrets
      #
      # @param [Hash] params Query parameters
      # @option params [Integer] :limit Maximum number of secrets to return (default: 100, max: 1000)
      # @option params [Integer] :offset Number of secrets to skip for pagination (default: 0)
      # @return [Hash] Response body with secrets metadata (does not return secret values)
      def list_secrets(params = {})
        get('/v1/secrets', params)
      end

      # Delete a secret
      # @see https://docs.devin.ai/api-reference/sessions/delete-secret
      #
      # @param [String] secret_id The ID of the secret to delete
      # @return [nil] Returns nil on success (204 No Content)
      def delete_secret(secret_id)
        delete("/v1/secrets/#{secret_id}")
      end
    end
  end
end
