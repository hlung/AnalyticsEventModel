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
- name
- page
- where

On the other hand, some parameter appears only once, or have the number of variations in the hundreds. These should NOT be declared as constants:
 - what
 - value
 
 Having constants for them make things hard to search (camel case vs snake case, long list) and hard to maintain (take long time to find where to insert new stuff).

### One source of truth

All parameters of an `Event` is backed by one dictionary.

```
public class Event {

  public var parameters: [Key: String] = [:]
  
  // ...
  
}
```

## Alternatives considered

### Property wrappers

There's a lot of duplicated code that read and write `parameters` dictionary. Initially it seems a good idea to use property wrapper to tuck away that code, like popular implementations for (UserDefaults backed properties)[https://www.swiftbysundell.com/articles/property-wrappers-in-swift/]. Each property be just a one liner like this:
```
public class Event {

  public var parameters: [Key: String] = [:]
  
  @Parameter(key: "page_id", backing: parameters) var pageId: String? // Compile error!
  
  // ...

}
``` 
Unfortunately, we can't pass instance variable into property wrapper input. So it's not possible to use property wrappers.

### Reflection

Inspired from (Looking Through the Mirror - iOS Conf SG 2022)[https://youtu.be/5jKLbNM7rZk?t=1159], it seems that by using Reflection, we can query a list of all properties of a type (Event in our case), and construct some output from it. But, as I designed, not all properties of an Event are of `String` type (there can be other String enums such as `Name` and `Page`), so the property wrapper has to support generics, which makes type casting impossible. I did tried adding using CustomReflectable to work around it, but it introduces a lot more code compared to simple approach of doing get/set on top of one source of truth dictionary. So I didn't go with that.
