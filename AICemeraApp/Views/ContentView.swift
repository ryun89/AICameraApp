import SwiftUI

struct ContentView: View {
    @StateObject private var cameraViewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            CameraView(viewModel: cameraViewModel)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        cameraViewModel.switchCamera()
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
                HStack{
                    VStack {
                        CapturedPhotosView(viewModel: cameraViewModel)
                    }
                    .sheet(isPresented: $cameraViewModel.isShowingPhotoViewer) {
                        if let selectedPhoto = cameraViewModel.selectedPhoto {
                            PhotoViewerView(image: selectedPhoto, viewModel: cameraViewModel)
                        }
                    }
                    Spacer()
                    Text(cameraViewModel.confidenceLabel)
                        .font(.largeTitle)
                        .padding()
                }
            }
        }
    }
}
