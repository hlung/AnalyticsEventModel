# Analytics

A better design of "Event model" for analytics libraries.

## Goals

- Swifty API - Super fast to write, with clarity and brevity, and with auto completion where needed.
- Compact - Event initialization and all parameters setting can be done in one line.
- Composable - Allow adding arbitrary parameters after init.
- Constrainable - Allow constraining some event to have a specific set of parameters.

## Design detail

### Not everything needs to have a dedicated constant

We are tempted to create constants for all parameter keys and values. They make sense if they do get reused and have not so many variations, such as:
- key
- page
- where

On the other hand, some parameter appears only once, or have the number of variations in the hundreds. These should NOT be declared as constants:
 - what
 - value
 
 Having constants for them make things hard to search (camel case vs snake case, long list) and hard to maintain (take long time to find where to insert new stuff).

### One source of truth for parameters

All parameters of an `Event` is backed by one dictionary.

```
public class Event {

  public var parameters: [Key: String] = [:]
  
  // ...
  
}
```
