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

  init(appKey: String, _ config: SimpleFeedbackConfig = SimpleFeedbackConfig()) {
    self.appKey = appKey
    self.config = config
  }

  func primaryAction() async throws {
    var client = FeedbackSDKClient(
      appKey: appKey, instanceURL: URL(string: "https://feedbackbulb.com")!)
    if config.debugRequests {
      client.debugOn()
    } else {
      client.debugOff()
    }

    let _ = try await client.reportValue(
      content: content, file: imageData, mimeType: "image/jpeg", email: email,
      attrs: getAttributes())
    #if os(iOS)
      await UINotificationFeedbackGenerator().notificationOccurred(.success)
    #endif
  }

  private func getAttributes() -> [String: String] {
    let osv = ProcessInfo.processInfo.operatingSystemVersion
    return [
      "app version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        as? String ?? "-",
      "os": "\(osv.majorVersion).\(osv.minorVersion).\(osv.patchVersion)",
    ]
  }

  @Published var content: String = ""
  @Published var email: String = ""
  @Published var imageData: Data? = nil

}
