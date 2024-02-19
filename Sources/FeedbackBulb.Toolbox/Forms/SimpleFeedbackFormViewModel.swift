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

    var attributes = FeedbackEnvironmentObserver().describeCurrentEnvironment()

    if config.showEmojiPicker, emoji != "" {
      attributes["emoji"] = emoji
    }

    try await client.submitFeedback(
      content: content, fileName: "image.jpg", file: imageData, mimeType: "image/jpeg",
      email: email,
      attrs: attributes)
    #if os(iOS)
      await UINotificationFeedbackGenerator().notificationOccurred(.success)
    #endif
    onFeedbackReported?()
  }

  @Published var content: String = ""
  @Published var email: String = ""
  @Published var imageData: Data? = nil
  @Published var emoji: String = ""
}
