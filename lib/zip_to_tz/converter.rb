# frozen_string_literal: true

require "yaml"

module ZipToTz
  # Looks up IANA timezone names or abbreviations for US zip codes.
  #
  # tz = ZipToTz::Converter.new
  # tz.full("33487")  # => "America/New_York"
  # tz.short("33487") # => "EDT"
  class Converter
    DATA_FILE = File.expand_path("data/timezones_to_zipcodes.yml", __dir__)
    ZIP_FORMAT = /\A\d{5}\z/

    # The upstream zip list only spans the timezones below, each pinned to a
    # single abbreviation (Arizona and Hawaii don't observe daylight saving,
    # so their zones keep a standard-time abbreviation year-round).
    ABBREVIATIONS = {
      "America/New_York" => "EDT",
      "America/Chicago" => "CDT",
      "America/Denver" => "MDT",
      "America/Los_Angeles" => "PDT",
      "America/Phoenix" => "MST",
      "Pacific/Honolulu" => "HST",
      "America/Anchorage" => "AKDT"
    }.freeze

    def full(zip)
      self.class.index.fetch(normalize(zip)) { raise NotFoundError, "Not found" }
    end

    def short(zip)
      timezone = full(zip)
      ABBREVIATIONS.fetch(timezone) { raise NotFoundError, "Not found" }
    end

    private

    def normalize(zip)
      value = zip.to_s.gsub(/\s/, "")
      raise InvalidZipCodeError, "Invalid format or zipCode length" unless value.match?(ZIP_FORMAT)

      value
    end

    class << self
      # Shared across all instances: the zip list is static, so there's no
      # reason for every Converter.new to re-parse and re-index the data.
      def index
        @index ||= build_index
      end

      private

      def build_index
        data = YAML.safe_load_file(DATA_FILE, permitted_classes: [Integer])
        index = {}
        data.each do |timezone, zips|
          zips.each { |zip| index[zip.to_s] = timezone }
        end
        index.freeze
      end
    end
  end
end
