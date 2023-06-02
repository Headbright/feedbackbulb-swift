//
//  SimpleFeedbackConfig.swift
//
//
//  Created by Konstantin on 08/04/2023.
//

import Foundation

public struct SimpleFeedbackConfig {
  public init(
    title: String = "Send feedback",
    subtitle: String = "We'd love to hear from you",
    textLabel: String = "Describe what's happening",
    textDescription: String = "Remember not to include personal information.",
    textAccessibilityLabel: String = "Enter feedback",
    submitButtonLabel: String = "Submit",
    showEmail: Bool = false,
    emailLabel: String = "Email",
    emailPlaceholder: String = "Type your email address",
    debugRequests: Bool = true,
    showAddImage: Bool = true,
    addImageLabel: String = "Include a screenshot",
    showEmojiPicker: Bool = false,
    emojiPickerLabel: String = "How do you feel about this app?",
    emojis: [String] = [
      "😁",
      "🤔",
      "🥵",
      "🙁",
      "🤘",
      "🚀",
      "🤯",
      "🎉",
      "🔥",
      "🙌",
    ]
  ) {
    self.title = title
    self.subtitle = subtitle
    self.textLabel = textLabel
    self.textDescription = textDescription
    self.textAccessibilityLabel = textAccessibilityLabel
    self.submitButtonLabel = submitButtonLabel
    self.showEmail = showEmail
    self.emailLabel = emailLabel
    self.emailPlaceholder = emailPlaceholder
    self.debugRequests = debugRequests
    self.showAddImage = showAddImage
    self.addImageLabel = addImageLabel
    self.showEmojiPicker = showEmojiPicker
    self.emojiPickerLabel = emojiPickerLabel
    self.emojis = emojis
  }

  var title: String
  var subtitle: String
  var textLabel: String
  var textDescription: String
  var textAccessibilityLabel: String
  var submitButtonLabel: String
  var showEmail: Bool
  var emailLabel: String
  var emailPlaceholder: String
  var debugRequests: Bool
  var showAddImage: Bool
  var addImageLabel: String
  var showEmojiPicker: Bool
  var emojiPickerLabel: String
  var emojis: [String]
}
