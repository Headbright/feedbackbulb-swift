//
//  SelectImageLegacy.swift
//
//
//  Created by Konstantin Kostov on 13/06/2023.
//

import SwiftUI

/// ImagePicker implementation that can be used for iOS 15.
///
/// Code snippet based on https://designcode.io/swiftui-advanced-handbook-imagepicker
struct SelectImageLegacy: UIViewControllerRepresentable {
  @Environment(\.presentationMode) private var presentationMode
  var sourceType: UIImagePickerController.SourceType = .photoLibrary
  @Binding var selectedImage: UIImage?

  func makeUIViewController(context: UIViewControllerRepresentableContext<SelectImageLegacy>)
    -> UIImagePickerController
  {

    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = false
    imagePicker.sourceType = sourceType
    imagePicker.delegate = context.coordinator

    return imagePicker
  }

  func updateUIViewController(
    _ uiViewController: UIImagePickerController,
    context: UIViewControllerRepresentableContext<SelectImageLegacy>
  ) {

  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
  {

    var parent: SelectImageLegacy

    init(_ parent: SelectImageLegacy) {
      self.parent = parent
    }

    func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {

      parent.selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
      parent.presentationMode.wrappedValue.dismiss()
    }

  }
}
