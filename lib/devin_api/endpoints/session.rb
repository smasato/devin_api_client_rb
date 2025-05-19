# frozen_string_literal: true

module DevinApi
  module Endpoints
    # Session endpoint for the Devin API
    module Session
      # Retrieve details about an existing session
      # @see https://docs.devin.ai/api-reference/sessions/retrieve-details-about-an-existing-session
      #
      # @param [String] session_id The ID of the session
      # @return [Hash] Response body
      def get_session(session_id)
        get("/v1/session/#{session_id}")
      end

      # Send a message to an existing session
      # @see https://docs.devin.ai/api-reference/sessions/send-a-message-to-an-existing-devin-session
      #
      # @param [String] session_id The ID of the session
      # @param [Hash] params Body parameters
      # @option params [String] :message The message to send (required)
      # @return [Hash] Response body
      def send_message(session_id, params = {})
        post("/v1/session/#{session_id}/message", params)
      end

      # Update session tags
      # @see https://docs.devin.ai/api-reference/sessions/update-session-tags
      #
      # @param [String] session_id The ID of the session
      # @param [Hash] params Body parameters
      # @option params [Array<String>] :tags Tags to associate with the session (required)
      # @return [Hash] Response body
      def update_session_tags(session_id, params = {})
        put("/v1/session/#{session_id}/tags", params)
      end
    end
  end
end
