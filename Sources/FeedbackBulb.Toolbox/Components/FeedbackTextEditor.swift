//
//  SwiftUIView.swift
//
//
//  Created by Konstantin on 08/04/2023.
//

import Introspect
import SwiftUI

struct FeedbackTextEditor: View {
  let label: String
  @Binding var text: String

  var body: some View {
    ZStack(alignment: .topLeading) {
      Text(text)
        .padding(.vertical, 8)
        .foregroundColor(Color.clear)
        .background(Color.clear)
        .accessibility(hidden: true)
        .fixedSize(horizontal: false, vertical: true)
        .id(text)

      TextEditor(text: $text)
        .introspectTextView(customize: { tv in
          #if canImport(UIKit)
            tv.isScrollEnabled = false
          #endif
        })
        .accessibility(label: Text(label))
    }
    .cornerRadius(8)
  }
}
