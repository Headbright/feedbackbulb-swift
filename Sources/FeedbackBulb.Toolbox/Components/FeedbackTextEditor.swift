//
//  SwiftUIView.swift
//
//
//  Created by Konstantin on 08/04/2023.
//

import FeedbackBulb
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

      if #available(iOS 16.0, *) {
        TextEditor(text: $text)
          .scrollDisabled(true)
          .accessibility(label: Text(label))
      } else {
        TextEditor(text: $text)
          .accessibility(label: Text(label))
      }

    }
    .cornerRadius(8)
  }
}
