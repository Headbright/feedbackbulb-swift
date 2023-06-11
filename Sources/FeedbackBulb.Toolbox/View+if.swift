//
//  File.swift
//
//
//  Created by Konstantin Kostov on 11/06/2023.
//

import SwiftUI

extension View {
  @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content)
    -> some View
  {
    if condition {
      transform(self)
    } else {
      self
    }
  }

  @ViewBuilder func `if`<Content: View>(
    _ condition: Bool, _ transform: (Self) -> Content, elseTransform: (Self) -> Content
  ) -> some View {
    if condition {
      transform(self)
    } else {
      elseTransform(self)
    }
  }
}
