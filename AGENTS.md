# AGENTS.md

## What this is

`zip_to_tz` is a Ruby gem, a port of the Node.js [zipToTz](https://github.com/pmmonier/zipToTz)
library. It maps a US zip code to a timezone — either the full IANA name (`America/New_York`) or
a short abbreviation (`EDT`).

## Structure

- `lib/zip_to_tz.rb` — module entry point. `ZipToTz.full`/`ZipToTz.short` are convenience methods
  backed by one memoized `Converter` instance.
- `lib/zip_to_tz/converter.rb` — `ZipToTz::Converter`, the actual lookup logic.
- `lib/zip_to_tz/errors.rb` — `ZipToTz::Error` and its two subclasses, `InvalidZipCodeError` and
  `NotFoundError`.
- `lib/zip_to_tz/data/timezones_to_zipcodes.yml` — the only data file. Maps each IANA timezone
  name to its list of zip codes (~83k entries total). `Converter` inverts this into a
  zip → timezone hash on first use, cached at the class level (`Converter.index`), shared by all
  instances.
- `spec/` — RSpec tests, mirrors `lib/` layout (`spec/zip_to_tz_spec.rb` for the module-level API,
  `spec/zip_to_tz/converter_spec.rb` for the `Converter` class).

## How `short` works

There is no separate short-name data file. `Converter::ABBREVIATIONS` is a small hard-coded table
(one entry per timezone actually present in the dataset) mapping full IANA name → abbreviation.
`#short` calls `#full` and looks up the result in that table, so the two methods can never
disagree. (Upstream ships two independently-maintained YAML files for this and they had drifted
out of sync for one zip code — that's why this port collapses them into one source of truth.)

The abbreviations are static per-zone, not date-aware — e.g. `America/New_York` is always `EDT`
here, never `EST`, matching upstream's behavior. This is a known simplification, not a bug to fix
unless asked.

## Dev workflow

```bash
bundle install          # install dependencies
bundle exec rspec       # run the test suite
gem build zip_to_tz.gemspec   # build the .gem
gem install ./zip_to_tz-<version>.gem   # install it locally
```

Run `bundle exec rspec` after any change to `lib/` or the data file before considering the work
done — the converter spec includes a full-dataset consistency check (`short` vs `full` for every
one of the ~83k zip codes), which is cheap to run and catches data regressions immediately.

## Data file gotchas

The YAML data mixes quoted (`'00100'`) and unquoted (`00108`) zip-code scalars, carried over from
upstream. This matters because YAML 1.1 parsers can misread a leading-zero numeric-looking scalar
as an octal integer. It happens to be safe as-is: every unquoted entry in the current file fails
Ruby's octal pattern (it contains an 8 or 9), so Psych always resolves it back to a string. If the
data file is ever regenerated or replaced, re-verify this — a quick way is to round-trip every zip
in the file through `Converter#full` and assert the key format survives (`\A\d{5}\z`).

## Error semantics (must stay compatible with upstream's intent)

- Non-5-digit or non-numeric input → `ZipToTz::InvalidZipCodeError` ("Invalid format or zipCode
  length" in upstream).
- Valid-format zip with no mapping → `ZipToTz::NotFoundError` ("Not found" in upstream).

Both inherit from `ZipToTz::Error`.
