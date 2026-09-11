# frozen_string_literal: true

module ZipToTz
  class Error < StandardError; end
  class InvalidZipCodeError < Error; end
  class NotFoundError < Error; end
end
