//
//  SubmitButtonStyle.swift
//
//
//  Created by Konstantin on 04/03/2023.
//

import SwiftUI

struct SubmitButtonStyle: ButtonStyle {

  /// Creates a view that represents the body of a button.
  /// - Parameter configuration: The properties of the button.
  func makeBody(
    configuration: Configuration
  ) -> some View {
    Group {
      #if os(iOS)
        HStack {
          Spacer()
          configuration
            .label
            .font(.headline.weight(.semibold))
            .padding(.vertical)
          Spacer()
        }
      #else
        configuration
          .label
          .padding(.horizontal, 60)
          .padding(.vertical, 8)
      #endif
    }
    .foregroundColor(Color.white)
    .background(Color.accentColor)
    .cornerRadius(14)
    .opacity(configuration.isPressed ? 0.5 : 1)
  }

}
