# AnalyticsEvent

A new analytics event model, with better APIs while still compatible with current Vikilitics library.

## Goals

- Swifty API - Easy to use at call site.
- Autocompletion - Suggest for all possible values for each key.
- Compact - Event initialization and all parameters setting can be done in one line.
- Composable - Allow adding parameters after init, e.g. in if statements.


## Design

 What should have predefined values?
 - key
 - name
 - page
 - where

 What should NOT have predefined values? (Too many options, each only used once)
 - what

