//
//  PhotoViewerView.swift
//  AICemeraApp
//
//  Created by 八久響 on 2024/06/26.
//

import SwiftUI

struct PhotoViewerView: View {
    @Environment(\.presentationMode) var presentationMode
    var image: UIImage
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                sharePhoto()
            }) {
                Text("Share")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    func sharePhoto() {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
}

