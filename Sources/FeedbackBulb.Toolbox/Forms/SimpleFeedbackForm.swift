//
//  SwiftUIView.swift
//
//
//  Created by Konstantin on 04/03/2023.
//

import PhotosUI
import SwiftUI

public struct SimpleFeedbackForm: View {
  @StateObject var viewModel: SimpleFeedbackFormViewModel
  @StateObject var imageModel = SelectImageModel()
  @Environment(\.presentationMode) private var presentationMode

  public var body: some View {
    ZStack {
      ScrollView(
        .vertical,
        showsIndicators: true
      ) {
        VStack(alignment: .leading, spacing: 28) {
          VStack(alignment: .leading) {
            title
            Text(viewModel.config.subtitle)
          }

          if viewModel.config.showEmail {
            VStack(alignment: .leading) {
              Text(viewModel.config.emailLabel)
              TextField(
                text: $viewModel.email, prompt: Text(viewModel.config.emailPlaceholder), label: {}
              )
              .textFieldStyle(.roundedBorder)
              .textInputAutocapitalization(.never)
            }
          }

          VStack(alignment: .leading) {
            Text(viewModel.config.textLabel)
              .bold()
            Text(viewModel.config.textDescription)
              .font(.subheadline)
            FeedbackTextEditor(
              label: viewModel.config.textAccessibilityLabel, text: $viewModel.content
            )
            .frame(minHeight: 160)
          }

          if viewModel.config.showAddImage {
            VStack(alignment: .leading) {
              Text(viewModel.config.addImageLabel)
              EditableSquareSelectImage(viewModel: imageModel)
            }
          }
        }
        .padding(.horizontal)
      }
      .alwaysBounceVertical(false)
      .onChange(
        of: imageModel.imageData,
        perform: { data in
          viewModel.imageData = data
        })

      VStack {
        Spacer()
        self.footer
          .modifier(FooterPadding())
      }
      .edgesIgnoringSafeArea(.bottom)
    }
    .background(Color(UIColor.systemGroupedBackground))
  }

  var title: some View {
    Text(
      viewModel.config.title
    )
    .font(.largeTitle.bold())
    .multilineTextAlignment(.center)
    .fixedSize(horizontal: false, vertical: true)
  }

  var footer: some View {
    VStack {
      Button(
        action: {
          Task {
            try? await self.viewModel.primaryAction()
          }
          self.presentationMode.wrappedValue.dismiss()
        }
      ) {
        Text(viewModel.config.submitButtonLabel)
      }
      .buttonStyle(
        SubmitButtonStyle()
      )
    }
  }
}

extension SimpleFeedbackForm {
  public init(appKey: String) {
    self.init(viewModel: SimpleFeedbackFormViewModel(appKey: appKey))
  }
  public init(appKey: String, config: SimpleFeedbackConfig) {
    self.init(viewModel: SimpleFeedbackFormViewModel(appKey: appKey, config))
  }
}

struct FooterPadding {
  #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
  #endif
}

extension FooterPadding: ViewModifier {
  func body(
    content: Content
  ) -> some View {
    if self.horizontalSizeClass == .regular {
      content.padding(
        .init(
          top: 0,
          leading: 150,
          bottom: 50,
          trailing: 150
        )
      )
    } else if self.verticalSizeClass == .compact {
      content.padding(
        .init(
          top: 0,
          leading: 40,
          bottom: 35,
          trailing: 40
        )
      )
    } else {
      content.padding(
        .init(
          top: 0,
          leading: 20,
          bottom: 80,
          trailing: 20
        )
      )
    }
  }
}

struct SimpleFeedbackForm_Previews: PreviewProvider {
  static var previews: some View {
    SimpleFeedbackForm(appKey: "")
  }
}
