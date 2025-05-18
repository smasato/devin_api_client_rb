# frozen_string_literal: true

module DevinApi
  module Resources
    # Base class for all API resources
    class Base
      attr_reader :client, :attributes

      def initialize(client, attributes = {})
        @client = client
        @attributes = attributes
      end

      def [](key)
        @attributes[key.to_s] || @attributes[key.to_sym]
      end

      def []=(key, value)
        @attributes[key.to_sym] = value
      end

      def id
        self[:id]
      end

      def path
        "#{self.class.resource_path}/#{id}"
      end

      def to_hash
        @attributes.dup
      end

      def method_missing(method, *_args)
        if @attributes.key?(method.to_s)
          @attributes[method.to_s]
        elsif @attributes.key?(method.to_sym)
          @attributes[method.to_sym]
        end
      end

      def respond_to_missing?(method, include_private = false)
        @attributes.key?(method.to_s) || @attributes.key?(method.to_sym) || super
      end

      class << self
        def resource_name
          @resource_name ||= name.split('::').last.downcase
        end

        def resource_path
          "/v1/#{resource_name.gsub('_', '-')}s"
        end

        def create(client, attributes = {})
          response = client.post(resource_path, attributes)
          new(client, response)
        end
      end
    end
  end
end
