//
//  ExampleContainer.swift
//  FeedbackExample
//
//  Created by Konstantin Kostov on 16/04/2024.
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

#Preview {
  ExampleContainer(
    config: .init(title: "Hello", subtitle: "How do you feel about our app?", textDescription: ""))
}
