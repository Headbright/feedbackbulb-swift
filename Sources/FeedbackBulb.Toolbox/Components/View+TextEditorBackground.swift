//
//  View+TextEditorBackground.swift
//  FeedbackExample
//
//  Created by David Wood on 14/06/23.
//

import SwiftUI

struct TextEditorModifiers: ViewModifier {
  @ViewBuilder
  func body(content: Content) -> some View {
    content
    .scrollableSupportingDarkMode()
    #if canImport(UIKit)
      .background(content: { Color(UIColor.secondarySystemGroupedBackground) })
    #endif
  }
}

extension View {
  @ViewBuilder
  func scrollableSupportingDarkMode() -> some View {
    if #available(iOS 16.0, *) {
      self.scrollDisabled(true)
      self.scrollContentBackground(.hidden)
    } else {
      self.onAppear {
        #if canImport(UIKit)
          UITextView.appearance().backgroundColor = .clear
        #endif
      }
    }
  }
}
