# ZipToTz

A Ruby port of the Node.js [zipToTz](https://github.com/pmmonier/zipToTz) library. Looks up the
IANA timezone name or abbreviation for a US zip code, using an updated (2020) zip code list.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add zip_to_tz
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install zip_to_tz
```

## Usage

```ruby
require "zip_to_tz"

ZipToTz.full("33487")  # => "America/New_York"
ZipToTz.short("33487") # => "EDT"
```

Or use the `Converter` class directly:

```ruby
converter = ZipToTz::Converter.new
converter.full("33487")  # => "America/New_York"
converter.short("33487") # => "EDT"
```

### Input format

The zip code must be exactly 5 digits (whitespace is stripped first). ZIP+4 codes are not
truncated — `"33487-1234"` raises `InvalidZipCodeError` rather than being treated as `"33487"`.

### Supported timezones

US zip codes and territories are covered, spanning these zones:

| IANA name             | Abbreviation |
| ---------------------- | ------------ |
| `America/New_York`     | `EDT`        |
| `America/Chicago`      | `CDT`        |
| `America/Denver`       | `MDT`        |
| `America/Los_Angeles`  | `PDT`        |
| `America/Phoenix`      | `MST`        |
| `America/Juneau`       | `AKDT`       |
| `Pacific/Honolulu`     | `HST`        |
| `America/Puerto_Rico`  | `AST`        |
| `Pacific/Pago_Pago`    | `SST`        |
| `Pacific/Guam`         | `ChST`       |
| `Asia/Tokyo`           | `JST`        |
| `Pacific/Guadalcanal`  | `+11`        |
| `Pacific/Majuro`       | `+12`        |

Every zone above is also a value in Rails' `ActiveSupport::TimeZone::MAPPING`, since most
consumers of this gem resolve the result through Rails. That's why Alaska zips resolve to
`America/Juneau` rather than `America/Anchorage` (identical in practice today, but only Juneau
is Rails-mapped), and why Palau, Chuuk/Yap, and Pohnpei/Kosrae resolve to whichever Rails-mapped
zone shares their real UTC offset and DST behavior (`Asia/Tokyo`, `Pacific/Guam`, and
`Pacific/Guadalcanal` respectively) instead of their own distinct IANA zone.

`short` always returns the abbreviation above, even in months when the zone is actually on
standard time — e.g. `ZipToTz.short("33487")` returns `EDT` year-round, never `EST`. None of the
zones below `Pacific/Honolulu` observe daylight saving, so they keep a fixed abbreviation
year-round; `Pacific/Guadalcanal` has no named abbreviation in IANA's tzdata, so it uses its
numeric UTC offset instead. This is a known simplification inherited from upstream, not a
date-aware lookup.

### Errors

- `ZipToTz::InvalidZipCodeError` — raised if the input isn't exactly 5 digits.
- `ZipToTz::NotFoundError` — raised if the zip code has no timezone mapping.

Both inherit from `ZipToTz::Error`.

```ruby
begin
  ZipToTz.full("abc")
rescue ZipToTz::Error => e
  # handle error
end
```

### Data

`short` is derived from `full`, so both are always consistent for a given zip code — see
[AGENTS.md](AGENTS.md) for why and how.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to
run the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new
version, update the version number in `version.rb`, and then run `bundle exec rake release`.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Credit

Ported from the original JavaScript/TypeScript implementation by
[pmmonier](https://github.com/pmmonier/zipToTz).
