# frozen_string_literal: true

module DevinApi
  module Middleware
    module Response
      # Middleware for raising errors based on HTTP status
      class RaiseError < Faraday::Middleware
        def call(env)
          @app.call(env).on_complete do |response|
            handle_error_response(response)
          end
        rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
          raise DevinApi::Error::ClientError, "Connection error: #{e.message}"
        end

        private

        def handle_error_response(response)
          status = response[:status]
          case status
          when 400 then raise DevinApi::Error::BadRequest, response
          when 401 then raise DevinApi::Error::Unauthorized, response
          when 403 then raise DevinApi::Error::Forbidden, response
          when 404 then raise DevinApi::Error::NotFound, response
          when 429 then raise DevinApi::Error::RateLimited, response
          when 400..499 then raise DevinApi::Error::ClientError, response
          when 500..599 then raise DevinApi::Error::ServerError, response
          end
        end
      end
    end
  end
end
