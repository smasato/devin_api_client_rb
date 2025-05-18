# frozen_string_literal: true

module DevinApi
  # Collection class for handling resource lists and pagination
  class Collection
    include Enumerable

    attr_reader :resource_class, :client, :options, :resources

    def initialize(client, resource_class, options = {})
      @client = client
      @resource_class = resource_class
      @options = options

      # Process array options
      @options.each do |key, value|
        @options[key] = value.join(',') if value.is_a?(Array)
      end
    end

    def each(&)
      fetch if @resources.nil?
      @resources.each(&)
    end

    def fetch
      response = client.get(path, @options)
      resource_key = "#{resource_class.resource_name.downcase}s"

      @resources = if response[resource_key]
                     response[resource_key].map do |attrs|
                       resource_class.new(client, attrs)
                     end
                   else
                     []
                   end

      @resources
    end

    def find(options = {})
      if options[:id]
        response = client.get("#{path}/#{options[:id]}")
        resource_class.new(client, response)
      else
        self
      end
    end

    def next_page
      new_options = @options.dup
      new_options[:offset] = calculate_next_offset
      self.class.new(@client, @resource_class, new_options)
    end

    def path
      resource_class.resource_path
    end

    def create(attributes = {})
      response = client.post(path, attributes)
      resource_class.new(client, response)
    end

    private

    def offset
      @options[:offset] || 0
    end

    def calculate_next_offset
      offset + (@options[:limit] || @resources.size)
    end
  end
end
