# frozen_string_literal: true

require_relative "zip_to_tz/version"
require_relative "zip_to_tz/errors"
require_relative "zip_to_tz/converter"

module ZipToTz
  class << self
    # ZipToTz.short("33487") # => "EDT"
    def short(zip)
      default_converter.short(zip)
    end

    # ZipToTz.full("33487") # => "America/New_York"
    def full(zip)
      default_converter.full(zip)
    end

    private

    def default_converter
      @default_converter ||= Converter.new
    end
  end
end
