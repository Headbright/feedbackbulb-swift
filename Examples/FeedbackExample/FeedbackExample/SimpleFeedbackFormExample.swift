//
//  SimpleFeedbackFormExample.swift
//  FeedbackExample
//
//  Created by Konstantin on 04/03/2023.
//

import FeedbackBulb_Toolbox
import SwiftUI

struct SimpleFeedbackFormExample: View {
  @State var showFeedback: Bool = false
  var body: some View {
    VStack {
      Button("Send Feedback...", action: { showFeedback.toggle() })
    }
    .padding()
    .sheet(isPresented: $showFeedback, content: { PresentingSheetView() })
  }
}

struct PresentingSheetView: View {
  @Environment(\.dismiss) private var dismiss
  var body: some View {
    NavigationStack {
      //TODO: - Replace with your API key
      SimpleFeedbackForm(appKey: "01b7f627-37c0-43f8-8815-2d730f55134b")
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Dismiss", action: { dismiss() })
          }
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    SimpleFeedbackFormExample()
  }
}
