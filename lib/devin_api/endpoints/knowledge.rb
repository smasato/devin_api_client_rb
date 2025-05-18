# frozen_string_literal: true

module DevinApi
  module Endpoints
    # Knowledge endpoints for the Devin API
    module Knowledge
      # List knowledge
      # @see https://docs.devin.ai/api-reference/knowledge/list-knowledge
      #
      # @param [Hash] params Query parameters
      # @option params [Integer] :limit Maximum number of knowledge items to return (default: 100, max: 1000)
      # @option params [Integer] :offset Number of knowledge items to skip for pagination (default: 0)
      # @return [Hash] Response body with knowledge and folders
      def list_knowledge(params = {})
        get('/v1/knowledge', params)
      end

      # Create knowledge
      # @see https://docs.devin.ai/api-reference/knowledge/create-knowledge
      #
      # @param [Hash] params Body parameters
      # @option params [String] :body Content of the knowledge (required)
      # @option params [String] :name Name of the knowledge (required)
      # @option params [String] :trigger_description Description of when this knowledge should be used (required)
      # @option params [String] :parent_folder_id ID of the folder that this knowledge is located in
      # @return [Hash] Response body with the created knowledge
      def create_knowledge(params = {})
        post('/v1/knowledge', params)
      end

      # Update knowledge
      # @see https://docs.devin.ai/api-reference/knowledge/update-knowledge
      #
      # @param [String] knowledge_id The ID of the knowledge to update
      # @param [Hash] params Body parameters
      # @option params [String] :body Content of the knowledge
      # @option params [String] :name Name of the knowledge
      # @option params [String] :trigger_description Description of when this knowledge should be used
      # @option params [String] :parent_folder_id ID of the folder that this knowledge is located in
      # @return [Hash] Response body with the updated knowledge
      def update_knowledge(knowledge_id, params = {})
        put("/v1/knowledge/#{knowledge_id}", params)
      end

      # Delete knowledge
      # @see https://docs.devin.ai/api-reference/knowledge/delete-knowledge
      #
      # @param [String] knowledge_id The ID of the knowledge to delete
      # @return [nil] Returns nil on success (204 No Content)
      def delete_knowledge(knowledge_id)
        delete("/v1/knowledge/#{knowledge_id}")
      end
    end
  end
end
