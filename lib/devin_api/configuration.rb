# frozen_string_literal: true

module DevinApi
  # Configuration class for the Devin API client
  class Configuration
    # @return [String] The base URL of the Devin API
    attr_accessor :url

    # @return [String] The access token for authentication
    attr_accessor :access_token

    # @return [Logger] The logger to use
    attr_accessor :logger

    # @return [Hash] Additional options to pass to Faraday
    attr_accessor :options

    def initialize
      @options = {}
    end
  end
end
