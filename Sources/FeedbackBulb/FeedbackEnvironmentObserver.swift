//
//  FeedbackEnvironmentObserver.swift
//
//
//  Created by Konstantin Kostov on 19/02/2024.
//

import Foundation

/// Helper class which offers methods to extract information about the current environment like OS and app version, device model and others.
public final class FeedbackEnvironmentObserver {

  /// Creates a new instance of `FeedbackEnvironmentObserver` which can be used to read default feedback attributes from the user's environment
  public init() {}

  /// Returns a list of attributes describing the current environment of the app.
  public func describeCurrentEnvironment() -> [String: String] {
    let osv = ProcessInfo.processInfo.operatingSystemVersion
    let attrs = [
      "app version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        as? String ?? "-",
      "app build": Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")
        as? String ?? "-",
      "os": "\(osv.majorVersion).\(osv.minorVersion).\(osv.patchVersion)",
      "system": Self.operatingSystem,
      "model": Self.modelName,
      "fbb.v": "1",
    ]
    return attrs
  }

  /// The modelname as reported by systemInfo.machine
  /// implementation inspired by: https://github.com/TelemetryDeck/SwiftClient
  private static var modelName: String {
    #if os(iOS)
      if #available(iOS 14.0, *) {
        if ProcessInfo.processInfo.isiOSAppOnMac {
          var size = 0
          sysctlbyname("hw.model", nil, &size, nil, 0)
          var machine = [CChar](repeating: 0, count: size)
          sysctlbyname("hw.model", &machine, &size, nil, 0)
          return String(cString: machine)
        }
      }
    #endif
    #if os(macOS)
      if #available(macOS 11, *) {
        let service = IOServiceGetMatchingService(
          kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        var modelIdentifier: String?
        if let modelData = IORegistryEntryCreateCFProperty(
          service, "model" as CFString, kCFAllocatorDefault, 0
        ).takeRetainedValue() as? Data {
          if let modelIdentifierCString = String(data: modelData, encoding: .utf8)?.cString(
            using: .utf8)
          {
            modelIdentifier = String(cString: modelIdentifierCString)
          }
        }
        IOObjectRelease(service)
        if let modelIdentifier = modelIdentifier {
          return modelIdentifier
        }
      }
    #endif
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
  }

  /// from  https://github.com/TelemetryDeck/SwiftClient
  private static var operatingSystem: String {
    #if os(macOS)
      return "macOS"
    #elseif os(iOS)
      return "iOS"
    #elseif os(watchOS)
      return "watchOS"
    #elseif os(tvOS)
      return "tvOS"
    #elseif os(visionOS)
      return "visionOS"
    #else
      return "Unknown Operating System"
    #endif
  }
}
