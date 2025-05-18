# frozen_string_literal: true

require 'devin_api/endpoints/sessions'
require 'devin_api/endpoints/session'
require 'devin_api/endpoints/secrets'
require 'devin_api/endpoints/knowledge'
require 'devin_api/endpoints/enterprise'
require 'devin_api/endpoints/attachment'

module DevinApi
  # Endpoints module for the Devin API
  module Endpoints
    # Include all endpoint modules
    def self.included(base)
      base.include(Sessions)
      base.include(Session)
      base.include(Secrets)
      base.include(Knowledge)
      base.include(Enterprise)
      base.include(Attachment)
    end
  end
end
