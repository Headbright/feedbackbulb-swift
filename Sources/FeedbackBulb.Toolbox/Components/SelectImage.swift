//
//  SelectImage.swift
//
//
//  Created by Konstantin on 10/04/2023.
//  Based on https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app

import CoreTransferable
import PhotosUI
import SwiftUI

struct SelectImage: View {
  let imageState: SelectImageModel.ImageState

  var body: some View {
    switch imageState {
    case .success(let image):
      image.resizable()
    case .loading:
      ProgressView()
    case .empty:
      Image(systemName: "photo.fill")
        .font(.system(size: 40))
        .foregroundColor(.white)
    case .failure:
      Image(systemName: "exclamationmark.triangle.fill")
        .font(.system(size: 40))
        .foregroundColor(.white)
    }
  }
}

struct SquareSelectImage: View {
  let imageState: SelectImageModel.ImageState

  var body: some View {
    SelectImage(imageState: imageState)
      .scaledToFill()
      .frame(width: 60, height: 60)
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 0.5))
  }
}

struct EditableSquareSelectImage: View {
  @ObservedObject var viewModel: SelectImageModel

  var body: some View {
    SquareSelectImage(imageState: viewModel.imageState)
      .overlay(alignment: .bottomTrailing) {
        PhotosPicker(
          selection: $viewModel.imageSelection,
          matching: .images,
          photoLibrary: .shared()
        ) {
          Image(systemName: "pencil.circle.fill")
            .controlSize(.large)
            .symbolRenderingMode(.multicolor)
            .font(.system(size: 30))
            .foregroundColor(.accentColor)
        }
        .buttonStyle(.borderless)
      }
  }
}

@MainActor
class SelectImageModel: ObservableObject {
  enum ImageState {
    case empty
    case loading(Progress)
    case success(Image)
    case failure(Error)
  }

  enum TransferError: Error {
    case importFailed
  }

  struct FeedbackImage: Transferable {
    let image: Image
    let data: Data

    static var transferRepresentation: some TransferRepresentation {
      DataRepresentation(importedContentType: .image) { data in
        guard let uiImage = UIImage(data: data) else {
          throw TransferError.importFailed
        }
        guard let imageData = uiImage.jpegData(compressionQuality: 1.0) else {
          throw TransferError.importFailed
        }
        let image = Image(uiImage: uiImage)
        return FeedbackImage(image: image, data: imageData)
      }
    }
  }

  @Published private(set) var imageState: ImageState = .empty

  @Published private(set) var imageData: Data? = nil

  @Published var imageSelection: PhotosPickerItem? = nil {
    didSet {
      if let imageSelection {
        let progress = loadTransferable(from: imageSelection)
        imageState = .loading(progress)
      } else {
        imageState = .empty
      }
    }
  }

  private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
    return imageSelection.loadTransferable(type: FeedbackImage.self) { result in
      DispatchQueue.main.async {
        self.imageData = nil
        guard imageSelection == self.imageSelection else {
          print("Failed to get the selected item.")
          return
        }
        switch result {
        case .success(let profileImage?):
          self.imageState = .success(profileImage.image)
          self.imageData = profileImage.data
        case .success(nil):
          self.imageState = .empty
        case .failure(let error):
          self.imageState = .failure(error)
        }
      }
    }
  }
}
