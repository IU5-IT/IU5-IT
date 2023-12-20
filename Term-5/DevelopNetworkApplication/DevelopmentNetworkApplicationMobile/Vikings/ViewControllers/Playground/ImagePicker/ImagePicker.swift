//
//  ImagePicker.swift
//  Vikings
//
//  Created by Dmitriy Permyakov on 26/10/2023.
//

import SwiftUI

struct ImagePickerForPriview: View {

    @State private var showImagePicker = false
    @State private var image: UIImage = UIImage(systemName: "camera")!

    var body: some View {
        VStack {

            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200)
                .foregroundStyle(.white)

            Button {
                showImagePicker.toggle()

            } label: {
                Text("Show image picker")
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker() { image in
                    self.image = image
                    uploadImage(image: image)
                }
            }
        }
    }

    func uploadImage(image: UIImage) {
        guard let url = URL(string: "http://localhost:7070/api/v3/cities/upload-image") else {
            print("URL is invalid")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"city_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("12".data(using: .utf8)!)
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)

        if let imageData = image.jpegData(compressionQuality: 0.1) {
            body.append(imageData)
        } else {
            print("Failed to get image data")
            return
        }

        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body as Data

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let data = data {
                let response = String(data: data, encoding: .utf8) ?? ""
                print("Response: \(response)")
            }
        }.resume()
    }
}

#Preview {
    ImagePickerForPriview()
}

// MARK: - ImagePicker view controller

struct ImagePicker: UIViewControllerRepresentable {

    var completion: (UIImage) -> Void

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ImagePicker.Coordinator: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
//            parent.image = selectedImage
            parent.completion(selectedImage)
        }
        picker.dismiss(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate

extension ImagePicker.Coordinator: UINavigationControllerDelegate {

}
