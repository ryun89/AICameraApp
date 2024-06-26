import SwiftUI

struct PhotoViewerView: View {
    @Environment(\.presentationMode) var presentationMode
    var image: UIImage
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        let shareImage = Image(uiImage: image)
        
        VStack {
            shareImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(.all)
            ShareLink(item: shareImage, preview: SharePreview("Shared Photo", image: shareImage)) {
                Text("Share")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .onDisappear {
            // 撮影を再開できるようにするためにフラグにtrueを設定
            viewModel.canTakePhoto = true
            
        }
    }
}
