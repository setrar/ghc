# Change Log

## [1.11.1.1]
- fix module Safe status

## [1.11.1]
- all modules Safe or Trustworthy
- fix NFData instances for DiffTime, NominalDiffTime, TimeOfDay
- add missing Ix, Enum, NFData instances to DayOfWeek, CalendarDiffDays, CalendarDiffTime, Month, Quarter, QuarterOfYear

## [1.11]
- new calendrical type synonyms and abstract constructors
- new Month type, with appropriate functions
- new QuarterOfYear and Quarter type, with appropriate functions
- new functions for working with week-based years
- new parseTimeMultipleM function for a list of (format, input) pairs
- add instance Ord DayOfWeek
- add instance Read DiffTime (and NominalDiffTime)
- change instance Read UTCTime to allow omitted timezone

## [1.10]
- remove deprecated functions parseTime, readTime, readsTime
- deprecate iso8601DateFormat
- parsing: fix %_Q %-Q %_q %-q
- parsing: fix parsing of BCE years
- formatting: fix %3ES %3Es
- change internal members of ParseTime to allow newtype-deriving
- new functions (aliases) pastMidnight & sinceMidnight

## [1.9.3]
- documentation fixes

## [1.9.2]
- add Data and Typeable instance for CalendarDiffDays and CalendarDiffTime
- "@since" annotations for everything after 1.9
- fix import issue with GHC 8.6

## [1.9.1]
- new functions secondsToNominalDiffTime & nominalDiffTimeToSeconds
- expose FormatTime and ParseTime in Data.Time.Format.Internal

## [1.9]
- new conversion functions timeToDaysAndTimeOfDay & daysAndTimeOfDayToTime
- new DayOfWeek type
- new CalendarDiffDays and CalendarDiffTime types
- new ISO8601 module for ISO 8601 formatting & parsing
- new addLocalTime, diffLocalTime
- hide members of FormatTime and ParseTime classes
- formatting & parsing for diff types (NominalDiffTime, DiffTime, CalendarDiffDays, CalendarDiffTime)
- formatting: %Ez and %EZ for ±HH:MM format
- parseTimeM: use MonadFail constraint when supported
- parsing: reject invalid (and empty) time-zones with %z and %Z
- parsing: reject invalid hour/minute/second specifiers

## [1.8.0.4]
- Fix "show minBound" bug
- haddock: example for parseTimeM

## [1.8.0.3]
- Add "Quick start" documentation

## [1.8.0.2]
- Fix behaviour of %Q in format

## [1.8.0.1]
- Get building on 32 bit machine

## [1.8]
- Added SystemTime
- Data.Time.Format: allow padding widths in specifiers for formatting (but not parsing)
- Test: use tasty, general clean-up
- Test: separate out UNIX-specific tests, so the others can be run on Windows
- Clean up haddock.

## [1.7.0.1]
- Fix bounds issue in .cabal file

## [1.7]
- Data.Time.Clock.TAI: change LeapSecondTable to LeapSecondMap with Maybe type; remove parseTAIUTCDATFile

## [1.6.0.1]
- Get building with earlier GHC versions
- Set lower bound of base correctly

## [1.6]

### Added
- FormatTime, ParseTime, Show and Read instances for UniversalTime
- diffTimeToPicoseconds
- this change log

### Changed
- Use clock_gettime where available
- Read and Show instances exported in the same module as their types
- Fixed bug in fromSundayStartWeekValid
- Parsing functions now reject invalid dates
- Various documentation fixes

## [1.5.0.1]
