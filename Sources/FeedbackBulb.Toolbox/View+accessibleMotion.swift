//
//  View+accessibleMotion.swift
//
//
//  Created by Konstantin on 04/03/2023.
//

import SwiftUI

extension View {
  public func accessibleMotion() -> some View {
    modifier(ReduceMotionnModifier())
  }
}

private struct ReduceMotionnModifier: ViewModifier {
  @Environment(\.accessibilityReduceMotion) private var reducedMotion

  func body(content: Content) -> some View {
    content.transaction { if reducedMotion { $0.animation = nil } }
  }
}
