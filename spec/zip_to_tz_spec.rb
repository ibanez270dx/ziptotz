# frozen_string_literal: true

RSpec.describe ZipToTz do
  it "has a version number" do
    expect(ZipToTz::VERSION).not_to be nil
  end

  describe ".full" do
    it "returns the full IANA timezone name for a known zip code" do
      expect(described_class.full("33487")).to eq("America/New_York")
    end

    it "strips whitespace from the zip code" do
      expect(described_class.full(" 33487 ")).to eq("America/New_York")
    end

    it "raises InvalidZipCodeError for a non-numeric zip code" do
      expect { described_class.full("abcde") }.to raise_error(ZipToTz::InvalidZipCodeError)
    end

    it "raises InvalidZipCodeError for a zip code with the wrong length" do
      expect { described_class.full("123") }.to raise_error(ZipToTz::InvalidZipCodeError)
    end

    it "raises NotFoundError when there is no mapping" do
      expect { described_class.full("00000") }.to raise_error(ZipToTz::NotFoundError)
    end
  end

  describe ".short" do
    it "returns the timezone abbreviation for a known zip code" do
      expect(described_class.short("33487")).to eq("EDT")
    end

    it "raises InvalidZipCodeError for a non-numeric zip code" do
      expect { described_class.short("abcde") }.to raise_error(ZipToTz::InvalidZipCodeError)
    end

    it "raises NotFoundError when there is no mapping" do
      expect { described_class.short("00000") }.to raise_error(ZipToTz::NotFoundError)
    end
  end
end
