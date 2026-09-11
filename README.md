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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to
run the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new
version, update the version number in `version.rb`, and then run `bundle exec rake release`.

## Credit

Ported from the original JavaScript/TypeScript implementation by
[pmmonier](https://github.com/pmmonier/zipToTz).
