//
//  SwiftUIView.swift
//
//
//  Created by Konstantin on 04/03/2023.
//

import PhotosUI
import SwiftUI

#if canImport(UIKit)

  public struct SimpleFeedbackForm: View {
    @StateObject var viewModel: SimpleFeedbackFormViewModel
    @StateObject var imageModel = SelectImageModel()
    @Environment(\.presentationMode) private var presentationMode

    public var body: some View {
      ZStack(alignment: .bottom) {
        ScrollView(
          .vertical,
          showsIndicators: true
        ) {
          VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading) {
              title
              if !viewModel.config.subtitle.isEmpty {
                Text(viewModel.config.subtitle)
                  .bold()
              }
            }

            if viewModel.config.showEmojiPicker {
              VStack(alignment: .leading) {
                if !viewModel.config.emojiPickerLabel.isEmpty {
                  Text(viewModel.config.emojiPickerLabel)
                    .bold()
                }
                EmojiPicker(mood: $viewModel.emoji, items: viewModel.config.emojis)
              }
            }

            if viewModel.config.showEmail {
              VStack(alignment: .leading) {
                if !viewModel.config.emailLabel.isEmpty {
                  Text(viewModel.config.emailLabel)
                    .bold()
                }
                TextField(
                  text: $viewModel.email, prompt: Text(viewModel.config.emailPlaceholder), label: {}
                )
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
              }
            }

            VStack(alignment: .leading) {
              if !viewModel.config.textLabel.isEmpty {
                Text(viewModel.config.textLabel)
                  .bold()
              }

              Text(viewModel.config.textDescription)
                .font(.subheadline)
              FeedbackTextEditor(
                label: viewModel.config.textAccessibilityLabel, text: $viewModel.content
              )
              .frame(minHeight: 160)
            }

            if viewModel.config.showAddImage {
              VStack(alignment: .leading) {
                if !viewModel.config.addImageLabel.isEmpty {
                  Text(viewModel.config.addImageLabel)
                    .bold()
                }

                EditableSquareSelectImage(viewModel: imageModel)
              }
            }
          }
          .padding(.horizontal)
          .padding(.bottom, 120)
        }
        .alwaysBounceVertical(false)
        .onChange(
          of: imageModel.imageData,
          perform: { data in
            viewModel.imageData = data
          })

        self.footer
      }
      .background(Color(UIColor.systemGroupedBackground))
      .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
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
      HStack(alignment: .bottom) {
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
        .padding()
        .background(
          Rectangle()
            .fill(Color(UIColor.systemBackground))
            .ignoresSafeArea(.all, edges: .bottom)
        )
        .shadow(color: Color.black.opacity(0.16), radius: 6, x: 0, y: 3)
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
#endif
