# frozen_string_literal: true

require_relative 'lib/devin_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'devin_api'
  spec.version       = DevinApi::VERSION
  spec.authors       = ['Masato Sugiyama']
  spec.email         = ['public@smasato.net']

  spec.summary       = 'Unofficial Ruby client for the Devin API'
  spec.description   = 'Unofficial Ruby client library for the Devin API'
  spec.homepage      = 'https://github.com/smasato/devin_api_client_rb'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/smasato/devin_api_client_rb'
  spec.metadata['changelog_uri'] = 'https://github.com/smasato/devin_api_client_rb/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.glob('lib/**/*') + %w[README.md LICENSE CHANGELOG.md]
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.7'
  spec.add_dependency 'faraday-multipart', '~> 1.0'
  spec.add_dependency 'hashie', '~> 5.0'
  spec.add_dependency 'inflection', '~> 1.0'
end
