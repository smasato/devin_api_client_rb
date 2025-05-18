# frozen_string_literal: true

module DevinApi
  module Error
    # Base class for all errors
    class Error < StandardError
      attr_reader :response

      def initialize(response = nil)
        @response = response
        super(build_message)
      end

      private

      def build_message
        return response if response.is_a?(String)
        return nil unless response

        message = "Status: #{response[:status]}"

        message += " - #{response[:body]['error']}" if response[:body].is_a?(Hash) && response[:body]['error']

        message
      end
    end

    class ClientError < Error; end
    class ServerError < Error; end
    class BadRequest < ClientError; end
    class Unauthorized < ClientError; end
    class Forbidden < ClientError; end
    class NotFound < ClientError; end
    class RateLimited < ClientError; end
  end
end
