//
//  FeedbackExampleApp.swift
//  FeedbackExample
//
//  Created by Konstantin on 04/03/2023.
//

import SwiftUI

@main
struct FeedbackExampleApp: App {
  var body: some Scene {
    WindowGroup {
      if #available(iOS 16.0, *) {
        NavigationStack {
          SelectExampleView()
        }
      } else {
        NavigationView {
          SelectExampleView()
        }
      }
    }
  }
}
