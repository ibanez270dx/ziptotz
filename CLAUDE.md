@AGENTS.md

## Claude-specific instructions

- Don't add error handling, validation, or abstractions beyond what's described in AGENTS.md —
  this is a small, deliberately minimal port. Three similar lines beat a premature helper.
- Default to no comments in code; the one exception already made (`Converter::ABBREVIATIONS`) is
  there because the reasoning (why these specific 7 zones, why static per-zone) isn't obvious
  from the code alone.
- Never regenerate or hand-edit `lib/zip_to_tz/data/timezones_to_zipcodes.yml` without re-running
  the round-trip check described in AGENTS.md's "Data file gotchas" section — a bad edit here
  fails silently (wrong timezone returned) rather than raising.
- Before reporting any change to `lib/` or the data file as complete, run `bundle exec rspec` and
  confirm all examples pass, including the full-dataset consistency spec.
