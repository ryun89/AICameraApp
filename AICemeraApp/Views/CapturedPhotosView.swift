import SwiftUI

struct CapturedPhotosView: View {
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.capturedPhotos, id: \.self) { photo in
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .onTapGesture {
                            viewModel.canTakePhoto = false
                            viewModel.selectedPhoto = photo
                            viewModel.isShowingPhotoViewer.toggle()
                        }
                }
            }
        }
    }
}

