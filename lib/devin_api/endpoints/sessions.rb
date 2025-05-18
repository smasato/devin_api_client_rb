# frozen_string_literal: true

module DevinApi
  module Endpoints
    # Sessions endpoints for the Devin API
    module Sessions
      # List all sessions
      # @see https://docs.devin.ai/api-reference/sessions/list-sessions
      #
      # @param [Hash] params Query parameters
      # @option params [Integer] :limit Maximum number of sessions to return (default: 100, max: 1000)
      # @option params [Integer] :offset Number of sessions to skip for pagination (default: 0)
      # @option params [Array<String>] :tags Filter sessions by tags
      # @return [Hash] Response body
      def list_sessions(params = {})
        get('/v1/sessions', params)
      end

      # Create a new session
      # @see https://docs.devin.ai/api-reference/sessions/create-a-new-devin-session
      #
      # @param [Hash] params Body parameters
      # @option params [String] :prompt The task description for Devin (required)
      # @option params [String, nil] :snapshot_id ID of a machine snapshot to use
      # @option params [Boolean, nil] :unlisted Whether the session should be unlisted
      # @option params [Boolean, nil] :idempotent Enable idempotent session creation
      # @option params [Integer, nil] :max_acu_limit Maximum ACU limit for the session
      # @option params [Array<String>, nil] :secret_ids Array of secret IDs to use. If nil, use all secrets. If empty array, use no secrets.
      # @option params [Array<String>, nil] :knowledge_ids Array of knowledge IDs to use. If nil, use all knowledge. If empty array, use no knowledge.
      # @option params [Array<String>, nil] :tags Array of tags to add to the session.
      # @option params [String, nil] :title Custom title for the session. If nil, a title will be generated automatically.
      # @return [Hash] Response body
      def create_session(params = {})
        post('/v1/sessions', params)
      end
    end
  end
end
