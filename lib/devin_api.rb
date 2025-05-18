# frozen_string_literal: true

module DevinApi; end

require 'faraday'
require 'faraday/multipart'
require 'inflection'

require 'devin_api/version'
require 'devin_api/core_ext/inflection'
require 'devin_api/error'
require 'devin_api/middleware/response/raise_error'
require 'devin_api/client'
require 'devin_api/endpoints'
