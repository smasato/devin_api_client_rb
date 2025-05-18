# frozen_string_literal: true

require 'inflection'

module DevinApi
  module CoreExt
    # String extensions for inflection
    module StringExtensions
      def singularize
        Inflection.singular(self)
      end
    end
  end
end

String.include DevinApi::CoreExt::StringExtensions
