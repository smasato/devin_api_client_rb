# frozen_string_literal: true

require 'faraday'
require 'faraday/multipart'
require 'json'

require 'devin_api/version'
require 'devin_api/configuration'
require 'devin_api/endpoints'
require 'devin_api/collection'
require 'devin_api/resources/session'
require 'devin_api/resources/secret'
require 'devin_api/resources/knowledge'
require 'devin_api/resources/enterprise'
require 'devin_api/resources/attachment'

module DevinApi
  # The top-level class that handles configuration and connection to the Devin API.
  class Client
    include DevinApi::Endpoints
    # @return [Configuration] Config instance
    attr_reader :config

    # Creates a new {Client} instance and yields {#config}.
    #
    # Requires a block to be given.
    def initialize
      raise ArgumentError, 'block not given' unless block_given?

      @config = DevinApi::Configuration.new
      yield config

      check_url
      set_access_token
    end

    # Creates a connection if there is none, otherwise returns the existing connection.
    #
    # @return [Faraday::Connection] Faraday connection for the client
    def connection
      @connection ||= build_connection
    end

    # Executes a GET request
    # @param [String] path The path to request
    # @param [Hash] params Query parameters
    # @return [Hash] Response body
    def get(path, params = {})
      response = connection.get(path, params)
      parse_response(response)
    end

    # Executes a POST request
    # @param [String] path The path to request
    # @param [Hash] params Body parameters
    # @return [Hash] Response body
    def post(path, params = {})
      response = connection.post(path) do |req|
        req.body = params.to_json
      end
      parse_response(response)
    end

    # Executes a PUT request
    # @param [String] path The path to request
    # @param [Hash] params Body parameters
    # @return [Hash] Response body
    def put(path, params = {})
      response = connection.put(path) do |req|
        req.body = params.to_json
      end
      parse_response(response)
    end

    # Executes a DELETE request
    # @param [String] path The path to request
    # @param [Hash] params Query parameters
    # @return [Hash] Response body
    def delete(path, params = {})
      response = connection.delete(path, params)
      parse_response(response)
    end

    protected

    # Called by {#connection} to build a connection.
    #
    # Uses middleware according to configuration options.
    def build_connection
      Faraday.new(url: config.url) do |conn|
        # Response middlewares
        conn.use DevinApi::Middleware::Response::RaiseError
        conn.response :json, content_type: /\bjson$/

        # Request middlewares
        conn.request :json
        conn.request :multipart

        # Authentication
        conn.headers['Authorization'] = "Bearer #{config.access_token}"
        conn.headers['User-Agent'] = "DevinApi Ruby Client/#{DevinApi::VERSION}"

        conn.adapter Faraday.default_adapter
      end
    end

    private

    def parse_response(response)
      return nil if response.status == 204
      return {} if response.body.nil? || response.body.empty?

      if response.body.is_a?(String) && response.body.start_with?('{', '[')
        begin
          JSON.parse(response.body)
        rescue JSON::ParserError
          response.body
        end
      else
        response.body
      end
    end

    def check_url
      raise ArgumentError, 'url must be provided' unless config.url

      return if config.url.start_with?('https://')

      raise ArgumentError, 'devin_api is ssl only; url must begin with https://'
    end

    def set_access_token
      return if config.access_token

      raise ArgumentError, 'access_token must be provided'
    end

    def method_missing(method, *args, &)
      method_name = method.to_s

      if resource_exists?(method_name.singularize)
        resource_class = resource_class_for(method_name.singularize)

        # Special case for 'knowledge' which is both singular and plural
        return Collection.new(self, resource_class, args.first || {}) if method_name == 'knowledge'

        if method_name.singularize == method_name
          id = args.first
          resource_class.new(self, get("#{resource_class.resource_path}/#{id}"))
        else
          Collection.new(self, resource_class, args.first || {})
        end
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      resource_exists?(method.to_s.singularize) || super
    end

    def resource_class_for(resource_name)
      class_name = resource_name.capitalize
      DevinApi::Resources.const_get(class_name) if DevinApi::Resources.const_defined?(class_name)
    end

    def resource_exists?(resource_name)
      class_name = resource_name.capitalize
      DevinApi::Resources.const_defined?(class_name)
    end
  end
end
