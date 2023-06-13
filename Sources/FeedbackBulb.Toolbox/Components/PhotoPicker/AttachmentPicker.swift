//
//  File.swift
//
//
//  Created by Konstantin Kostov on 13/06/2023.
//

import SwiftUI

#if canImport(UIKit)
  struct AttachmentPicker: View {

    var onAttachmentSelected: (Data?) -> Void

    var body: some View {
      if #available(iOS 16.0, *) {
        AttachmentPhotoPicker(onAttachmentSelected: onAttachmentSelected)
      } else {
        AttachmentPhotoPickerLegacy(onAttachmentSelected: onAttachmentSelected)
      }
    }
  }

  @available(iOS 16.0, *)
  struct AttachmentPhotoPicker: View {
    @StateObject var viewModel = SelectImageModel()

    var onAttachmentSelected: (Data?) -> Void

    var body: some View {
      EditableSquareSelectImage(viewModel: viewModel)
        .onChange(
          of: viewModel.imageData,
          perform: { data in
            onAttachmentSelected(data)
          })
    }
  }

  //MARK: - iOS 15 Support

  struct AttachmentPhotoPickerLegacy: View {
    @StateObject var viewModel = AttachmentPhotoPickerLegacyViewModel()

    var onAttachmentSelected: (Data?) -> Void

    var body: some View {
      Button(
        action: {
          viewModel.showingSheet.toggle()
        },
        label: {

          Group {
            if let uiImage = viewModel.image {
              Image(uiImage: uiImage).resizable()
            } else {
              Image(systemName: "photo.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
            }
          }
          .scaledToFill()
          .frame(width: 80, height: 80)
          .clipShape(RoundedRectangle(cornerRadius: 8))
          .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 0.5))
          .overlay(alignment: .bottomTrailing) {
            Image(systemName: "pencil.circle.fill")
              .controlSize(.large)
              .symbolRenderingMode(.multicolor)
              .font(.system(size: 30))
              .foregroundColor(.accentColor)
          }

        }
      )
      .buttonStyle(.borderless)
      .sheet(isPresented: $viewModel.showingSheet) {
        SelectImageLegacy(sourceType: .photoLibrary, selectedImage: self.$viewModel.image)
      }
      .onChange(
        of: viewModel.image,
        perform: { uiImage in
          if let data = uiImage?.jpegData(compressionQuality: 1.0) {
            onAttachmentSelected(data)
          } else {
            onAttachmentSelected(nil)
          }
        })
    }
  }

  final class AttachmentPhotoPickerLegacyViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var showingSheet = false
  }
#endif
