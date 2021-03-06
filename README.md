# AnalyticsEventModel

A better design of "Event model" for analytics libraries.

## Problem

Specifying parameters for analytics events using pure dictionary is troublesome. It lacks auto completion, and people in the team tends to create helper functions for each event in each page everywhere, making code harder to maintain. There should be a better model that handle event construction better.  

## Goals

- Swifty API - Fast to write, with auto completion where possible.
- Compact - Event initialization can be done in one line.
- Composable - Allow adding parameters after init. Some parameter has to be set conditionally.
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

All parameters of an `Event` is backed by one `parameters` dictionary.

```swift
public class Event {

  public var parameters: [Key: String] = [:]
  
  // ...
  
}
```

The `name` is kept outside parameters because it is required by all events.

### Using property wrapper

Using just simple property getter/setter to wrap around parameters dictionary works fine. But I want to further make code more clear. 
Normally, if you pass an instance variable into a property wrapper, it will give you error:

```
Cannot use instance member 'xxx' within property initializer; 
property initializers run before 'self' is available
``` 

However, [EnclosingTypeReferencingWrapper](https://www.swiftbysundell.com/articles/accessing-a-swift-property-wrappers-enclosing-instance/#getting-started) allows us to access instance variable from property wrapper. We need to access the backing `parameters` dictionary inside Event to get and set values. This allows code to go from this:

```swift
public var what: String? {
  get { parameters[.what] }
  set { parameters[.what] = newValue }
}

public var page: Page? {
  get { Page(rawValue: parameters[.page] ?? "") }
  set { parameters[.page] = newValue?.rawValue }
}
```

to this:

```swift  
@Parameter(.what) public var what: String?
@Parameter(.page) public var page: Page?
```
