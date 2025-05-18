# frozen_string_literal: true

require 'devin_api'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = '../fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = true
end

def client
  @client ||= DevinApi::Client.new do |config|
    config.url = 'https://api.devin.ai'
    config.access_token = 'test_token'
    config.logger = Logger.new(File::NULL)
  end
end

module TestHelper
  def json(body = {})
    JSON.dump(body)
  end

  def stub_json_request(verb, path_matcher, body = {}, options = {})
    body_str = body.is_a?(String) ? body : json(body)
    stub = stub_request(verb, path_matcher)
    stub = stub.with(body: body) if %i[post put].include?(verb) && !body.is_a?(String) && !body.empty?
    stub.to_return(
      {
        body: body_str,
        headers: { 'Content-Type' => 'application/json' }
      }.merge(options)
    )
  end
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.include(TestHelper)
end
