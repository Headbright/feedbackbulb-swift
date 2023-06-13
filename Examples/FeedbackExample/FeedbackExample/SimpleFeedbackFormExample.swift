//
//  SimpleFeedbackFormExample.swift
//  FeedbackExample
//
//  Created by Konstantin on 04/03/2023.
//

import FeedbackBulb_Toolbox
import SwiftUI

struct Example1: View {
  @Environment(\.dismiss) private var dismiss
  var body: some View {
    //TODO: - Replace with your API key
    SimpleFeedbackForm(appKey: "01b7f627-37c0-43f8-8815-2d730f55134b", config: .init(title: "Hello", subtitle: "How do you feel about our app?", textDescription: "", showEmojiPicker: true, emojiPickerLabel: ""), onFeedbackReported: {
      print("feedback submitted")
    })
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
  var body: some View {
    VStack {
      Button("Send Feedback...", action: { showFeedback.toggle() })
    }
    .padding()
    .sheet(isPresented: $showFeedback, content: {
      if #available(iOS 16.0, *) {
        NavigationStack {
          Example1()
        }
      } else {
        NavigationView {
          Example1()
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
