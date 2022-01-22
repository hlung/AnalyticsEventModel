// Example for how we will use this event in AnalyticsLogger.
class AnalyticsLogger {

  func log(_ event: Event) {
    logEvent(event.name.rawValue, parameters: event.dictionary)
  }

  // Placeholder for existing API
  func logEvent(_ eventName: String, parameters: [String: Any]?) {
  }

}
