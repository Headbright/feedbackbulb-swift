//
//  File.swift
//
//
//  Created by Konstantin Kostov on 02/06/2023.
//

import SwiftUI

#if canImport(UIKit)
  let gestureRecognizerName = "ZOFXKeyboardDismissTapGesture"

  /// Adds a gesture recogniser to dismiss the keyboard when tapping outside input components
  extension UIApplication {
    func addTapGestureRecognizer() {
      guard let window = windows.first else { return }
      if window.gestureRecognizers?.contains(where: { $0.name == gestureRecognizerName }) ?? false {
        return
      }
      let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
      tapGesture.cancelsTouchesInView = false
      tapGesture.delegate = self
      tapGesture.name = gestureRecognizerName
      window.addGestureRecognizer(tapGesture)
    }
  }

  extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
      // allow other gestures to work without dismissing the keyboard
      return false
    }
  }
#endif
