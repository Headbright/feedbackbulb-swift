//
//  SimpleFeedbackFormViewModel.swift
//
//
//  Created by Konstantin on 04/03/2023.
//

import FeedbackBulb
import SwiftUI

final class SimpleFeedbackFormViewModel: ObservableObject {
  let appKey: String
  let config: SimpleFeedbackConfig

  var onFeedbackReported: (() -> Void)?

  init(
    appKey: String, _ config: SimpleFeedbackConfig = SimpleFeedbackConfig(),
    onFeedbackReported: (() -> Void)? = nil
  ) {
    self.appKey = appKey
    self.config = config
    self.onFeedbackReported = onFeedbackReported
  }

  func primaryAction() async throws {
    var client = FeedbackSDKClient(
      appKey: appKey)
    if config.debugRequests {
      client.debugOn()
    } else {
      client.debugOff()
    }

    try await client.submitFeedback(
      content: content, fileName: "image.jpg", file: imageData, mimeType: "image/jpeg",
      email: email,
      attrs: getAttributes())
    #if os(iOS)
      await UINotificationFeedbackGenerator().notificationOccurred(.success)
    #endif
    onFeedbackReported?()
  }

  private func getAttributes() -> [String: String] {
    let osv = ProcessInfo.processInfo.operatingSystemVersion
    var attrs = [
      "app version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        as? String ?? "-",
      "app build": Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")
        as? String ?? "-",
      "os": "\(osv.majorVersion).\(osv.minorVersion).\(osv.patchVersion)",
      "system": Self.operatingSystem,
      "model": Self.modelName,
    ]

    if config.showEmojiPicker, emoji != "" {
      attrs["emoji"] = emoji
    }

    return attrs
  }

  @Published var content: String = ""
  @Published var email: String = ""
  @Published var imageData: Data? = nil
  @Published var emoji: String = ""

  /// The modelname as reported by systemInfo.machine
  /// source: https://github.com/TelemetryDeck/SwiftClient
  static var modelName: String {
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
  static var operatingSystem: String {
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
