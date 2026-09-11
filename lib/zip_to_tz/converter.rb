# frozen_string_literal: true

require "yaml"

module ZipToTz
  # Looks up IANA timezone names or abbreviations for US zip codes.
  #
  # tz = ZipToTz::Converter.new
  # tz.full("33487")  # => "America/New_York"
  # tz.short("33487") # => "EDT"
  class Converter
    DATA_DIR = File.expand_path("data", __dir__)
    SHORT_FILE = "timezones_to_zipcodes.yml"
    FULL_FILE = "timezones_to_zipcodes_full.yml"
    ZIP_FORMAT = /\A\d{5}\z/

    def short(zip)
      lookup(zip, short_index)
    end

    def full(zip)
      lookup(zip, full_index)
    end

    private

    def lookup(zip, index)
      index.fetch(normalize(zip)) { raise NotFoundError, "Not found" }
    end

    def normalize(zip)
      value = zip.to_s.gsub(/\s/, "")
      raise InvalidZipCodeError, "Invalid format or zipCode length" unless value.match?(ZIP_FORMAT)

      value
    end

    def short_index
      @short_index ||= build_index(SHORT_FILE)
    end

    def full_index
      @full_index ||= build_index(FULL_FILE)
    end

    def build_index(filename)
      data = YAML.safe_load_file(File.join(DATA_DIR, filename), permitted_classes: [Integer])
      index = {}
      data.each do |timezone, zips|
        zips.each { |zip| index[zip.to_s] = timezone }
      end
      index
    end
  end
end
