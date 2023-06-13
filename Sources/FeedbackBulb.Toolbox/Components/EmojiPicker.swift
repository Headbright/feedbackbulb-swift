//
//  File.swift
//
//
//  Created by Konstantin Kostov on 02/06/2023.
//

import SwiftUI

struct EmojiPicker: View {
  @Binding var mood: String

  let items: [String]
  let columns = [
    GridItem(.fixed(50.00), spacing: 16),
    GridItem(.fixed(50.00), spacing: 16),
    GridItem(.fixed(50.00), spacing: 16),
    GridItem(.fixed(50.00), spacing: 16),
    GridItem(.fixed(50.00), spacing: 16),
  ]

  var body: some View {
    LazyVGrid(columns: columns, spacing: 0) {
      ForEach(self.items, id: \.self) { emoji in
        Button(
          action: {
            self.mood = emoji
          },
          label: {
            EmojiPickerItem(item: emoji, selected: mood == emoji)
              .id("\(emoji)\(mood ?? "")")
          }
        )
        .buttonStyle(PlainButtonStyle())
        .frame(width: 72, height: 72)
      }
    }
    .accessibilityRepresentation(representation: {
      Picker("Select emoji", selection: self.$mood) {
        ForEach(self.items, id: \.self) { emoji in
          Text(emoji).tag(emoji)
        }

      }

    })
  }
}

struct EmojiPickerItem: View {
  let item: String
  let selected: Bool

  var body: some View {
    EmojiPickerItemSelection(selected: selected) {
      EmojiPickerItemContent(item: item)
    }
  }
}

struct EmojiPickerItemSelection<Content: View>: View {
  let content: Content
  let selected: Bool
  @State private var hovered: Bool = false

  init(selected: Bool, @ViewBuilder content: () -> Content) {
    self.selected = selected
    self.content = content()
  }

  var backgroundColor: Color {
    if selected {
      return Color.accentColor
    } else {
      if hovered {
        return Color.black.opacity(0.3)
      } else {
        return Color.clear
      }
    }
  }

  var body: some View {
    content
      .background(Circle().scale(1.4).fill(backgroundColor.opacity(0.8)))
      .onHover(perform: { hov in
        self.hovered = hov
      })
  }
}

struct EmojiPickerItemContent: View {
  let item: String
  var body: some View {
    Text(item)
      .font(.largeTitle)
      .accessibilityElement(children: .ignore)
      .accessibility(label: Text(item))
  }
}
