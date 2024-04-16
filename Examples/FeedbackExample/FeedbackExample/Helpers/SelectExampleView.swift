//
//  SelectExampleView.swift
//  FeedbackExample
//
//  Created by Konstantin on 04/03/2023.
//

import FeedbackBulb_Toolbox
import SwiftUI

struct SelectExampleView: View {
  @State var showFeedback: Bool = false
  @State var example: Example? = nil

  var body: some View {
    VStack {
      Picker("Example", selection: $example) {
        Text("Select example").tag(Optional<Int?>.none)
        // example form configurations
        Text("1. Feedback Form").tag(Optional(Example.example1))
        Text("2. Feedback Form (Pinned Button)").tag(Optional(Example.example2))
        Text("3. Feedback Form (Text Field)").tag(Optional(Example.example3))
        // example reusable components
        Text("4. Component - star rating").tag(Optional(Example.exampleComponentStarRating))
      }
    }
    .onChange(
      of: example,
      perform: { value in
        if value != nil {
          showFeedback = true
        } else {
          showFeedback = false
        }
      }
    )
    .sheet(
      isPresented: $showFeedback,
      content: {
        if #available(iOS 16.0, *) {
          NavigationStack {
            switch example {
            case .exampleComponentStarRating:
              ExampleStarRatingComponent()
            default:
              ExampleContainer(config: example!.config())
            }
          }
        } else {
          NavigationView {
            switch example {
            case .exampleComponentStarRating:
              ExampleStarRatingComponent()
            default:
              ExampleContainer(config: example!.config())
            }
          }
        }

      })
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    SelectExampleView()
  }
}

enum Example: String, Hashable {
  case example1
  case example2
  case example3
  case exampleComponentStarRating
}

extension Example {
  func config() -> SimpleFeedbackConfig {
    switch self {
    case .example1:
      .init(
        title: "Hello", subtitle: "How do you feel about our app?", textDescription: "",
        showEmojiPicker: true, emojiPickerLabel: "")
    case .example2:
      .init(
        title: "Hello", subtitle: "How do you feel about our app?", textDescription: "",
        showEmojiPicker: true, emojiPickerLabel: "", pinSubmitButton: true)
    case .example3:
      .init(title: "Hello", subtitle: "How do you feel about our app?", textDescription: "")
    case .exampleComponentStarRating:
      .init(title: "Hello", subtitle: "How do you feel about our app?", textDescription: "")
    }
  }
}
