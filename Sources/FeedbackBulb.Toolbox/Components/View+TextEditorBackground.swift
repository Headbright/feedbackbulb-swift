//
//  View+TextEditorBackground.swift
//  FeedbackExample
//
//  Created by David Wood on 14/06/23.
//

import SwiftUI

extension View {
    
    private func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
    
    internal func textEditorBackground<V>(@ViewBuilder _ background: () -> V) -> some View where V: View {
        self
            .transparentScrolling()
            .background(background())
    }
}
