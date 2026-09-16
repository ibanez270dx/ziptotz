# frozen_string_literal: true

RSpec.describe ZipToTz::Converter do
  subject(:converter) { described_class.new }

  describe "#full" do
    it "returns the full IANA timezone name for a known zip code" do
      expect(converter.full("33487")).to eq("America/New_York")
    end

    it "strips whitespace from the zip code" do
      expect(converter.full(" 33487 ")).to eq("America/New_York")
    end

    it "raises InvalidZipCodeError for a non-numeric zip code" do
      expect { converter.full("abcde") }.to raise_error(ZipToTz::InvalidZipCodeError)
    end

    it "raises InvalidZipCodeError for a zip code with the wrong length" do
      expect { converter.full("123") }.to raise_error(ZipToTz::InvalidZipCodeError)
    end

    it "raises NotFoundError when there is no mapping" do
      expect { converter.full("00000") }.to raise_error(ZipToTz::NotFoundError)
    end
  end

  describe "#short" do
    it "returns the timezone abbreviation for a known zip code" do
      expect(converter.short("33487")).to eq("EDT")
    end

    it "raises InvalidZipCodeError for a non-numeric zip code" do
      expect { converter.short("abcde") }.to raise_error(ZipToTz::InvalidZipCodeError)
    end

    it "raises NotFoundError when there is no mapping" do
      expect { converter.short("00000") }.to raise_error(ZipToTz::NotFoundError)
    end

    it "agrees with #full for a zip code that used to be inconsistent between " \
       "upstream's two data files (97838)" do
      expect(converter.full("97838")).to eq("America/Los_Angeles")
      expect(converter.short("97838")).to eq("PDT")
    end
  end

  describe "territory and nation zips" do
    {
      "00601" => ["America/Puerto_Rico", "AST"],   # Puerto Rico
      "96799" => ["Pacific/Pago_Pago", "SST"],      # American Samoa
      "96910" => ["Pacific/Guam", "ChST"],          # Guam
      "96942" => ["Pacific/Guam", "ChST"],          # Chuuk, proxied through Guam's zone
      "96939" => ["Asia/Tokyo", "JST"],             # Palau, proxied through Tokyo's zone
      "96941" => ["Pacific/Guadalcanal", "+11"],    # Pohnpei, proxied through Guadalcanal's zone
      "96944" => ["Pacific/Guadalcanal", "+11"],    # Kosrae, proxied through Guadalcanal's zone
      "96960" => ["Pacific/Majuro", "+12"],         # Marshall Islands
      "99801" => ["America/Juneau", "AKDT"]         # Alaska, renamed from America/Anchorage
    }.each do |zip, (full, short)|
      it "maps #{zip} to #{full} / #{short}" do
        expect(converter.full(zip)).to eq(full)
        expect(converter.short(zip)).to eq(short)
      end
    end
  end

  it "shares one index across instances instead of re-parsing per instance" do
    expect(described_class.new.full("33487")).to eq(described_class.new.full("33487"))
    expect(described_class.index).to be(described_class.index)
  end

  it "keeps #short and #full consistent for every zip code in the dataset" do
    described_class.index.each_key do |zip|
      expect(converter.short(zip)).to eq(ZipToTz::Converter::ABBREVIATIONS.fetch(converter.full(zip)))
    end
  end
end
