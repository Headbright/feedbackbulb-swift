//
//  FBBStarRatingView.swift
//
//
//  Created by Konstantin Kostov on 16/04/2024.
//

import SwiftUI

/// A 5 star rating component. The component accepts a binding to a value of type `Int` which will be set to a value from 1 to 5 depending the number of selected starts. A value of `nil`, `0` or `-1` will be visualized as no selected stars.
///
/// Use `.foregroundStyle(_)` to customize the colour of the component
public struct FBBStarRatingView: View {
  @Binding public var rating: Int?

  public init(rating: Binding<Int?>) {
    self._rating = rating
  }

  var roundedRating: Int {
    return rating ?? -1
  }

  private var accessibleValue: Text {
    if let rating {
      Text(String(rating))
    } else {
      Text("Not set")
    }
  }

  public var body: some View {
    HStack {
      Group {
        Image(systemName: roundedRating > 0 ? "star.fill" : "star").onTapGesture { rating = 1 }
        Image(systemName: roundedRating > 1 ? "star.fill" : "star").onTapGesture { rating = 2 }
        Image(systemName: roundedRating > 2 ? "star.fill" : "star").onTapGesture { rating = 3 }
        Image(systemName: roundedRating > 3 ? "star.fill" : "star").onTapGesture { rating = 4 }
        Image(systemName: roundedRating > 4 ? "star.fill" : "star").onTapGesture { rating = 5 }
      }
      .imageScale(.large)
    }
    .font(.system(size: 25))
    .accessibilityElement()
    .accessibilityValue(accessibleValue)
    .accessibilityAdjustableAction { direction in
      switch direction {
      case .increment:
        guard roundedRating < 5 else { break }
        rating = roundedRating + 1
      case .decrement:
        guard roundedRating > 1 else { break }
        rating = roundedRating - 1
      @unknown default:
        break
      }
    }
  }
}

#Preview {
  FBBStarRatingView(rating: .constant(2))
}
