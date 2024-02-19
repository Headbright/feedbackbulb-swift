//
//  SimpleFeedbackFormExample.swift
//  FeedbackExample
//
//  Created by Konstantin on 04/03/2023.
//

import FeedbackBulb_Toolbox
import SwiftUI

struct ExampleContainer: View {
  @Environment(\.dismiss) private var dismiss

  let config: SimpleFeedbackConfig

  var body: some View {
    //TODO: - Replace with your API key
    SimpleFeedbackForm(
      appKey: "01b7f627-37c0-43f8-8815-2d730f55134b", config: config,
      onFeedbackReported: {
        print("feedback submitted")
      }
    )
    .accentColor(.purple)
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("Dismiss", action: { dismiss() })
      }
    }
  }
}

struct SimpleFeedbackFormExample: View {
  @State var showFeedback: Bool = false
  @State var example: Example = .example1

  var body: some View {
    VStack(alignment: .leading) {
      Group {
        Button(
          "Example",
          action: {
            example = .example1
            showFeedback.toggle()
          })
        Button(
          "Example - Pinned Button",
          action: {
            example = .example2
            showFeedback.toggle()
          })
        Button(
          "Example - Text field",
          action: {
            example = .example3
            showFeedback.toggle()
          })
      }
      .padding()
      .font(.title2)

    }
    .sheet(
      isPresented: $showFeedback,
      content: {
        if #available(iOS 16.0, *) {
          NavigationStack {
            ExampleContainer(config: example.config())
          }
        } else {
          NavigationView {
            ExampleContainer(config: example.config())
          }
        }
      })
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    SimpleFeedbackFormExample()
  }
}

enum Example: String, Hashable {
  case example1
  case example2
  case example3
}

extension Example {
  func config() -> SimpleFeedbackConfig {
    switch self {
    case .example1:
      .init(
        title: "Hello", subtitle: "How do you feel about our app?", textDescription: "",
        showEmojiPicker: true, emojiPickerLabel: "")
    case .example2:
      .init(
        title: "Hello", subtitle: "How do you feel about our app?", textDescription: "",
        showEmojiPicker: true, emojiPickerLabel: "", pinSubmitButton: true)
    case .example3:
      .init(title: "Hello", subtitle: "How do you feel about our app?", textDescription: "")
    }
  }
}
