//
//  ExampleStarRatingComponent.swift
//  FeedbackExample
//
//  Created by Konstantin Kostov on 16/04/2024.
//

import FeedbackBulb_Toolbox
import SwiftUI

struct ExampleStarRatingComponent: View {
  @Environment(\.dismiss) private var dismiss
  @State private var currentRating: Int? = nil

  var body: some View {
    VStack {
      if let currentRating {
        HStack {
          Text("Current rating: \(currentRating)")
          Button("Reset", action: { self.currentRating = nil })
        }
        .padding()
      } else {
        Text("Tap on a star to rate")
          .padding()
      }
      FBBStarRatingView(rating: $currentRating)
    }
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("Dismiss", action: { dismiss() })
      }
    }
  }
}

#Preview {
  ExampleStarRatingComponent()
}
