import SwiftUI

// 撮影画面のView
struct CaptureView: View {
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
                    .padding() // ボタンの周囲に余白を追加
                    .background(Color.white.opacity(0.5)) // 背景に半透明の白を追加して見やすくする
                    .cornerRadius(15) // 角を丸くする
                    .padding(.top, 50) // ボタンを画面上部から少し下げることでステータスバーと重ならないようにする
                    .padding(.leading, 20) // ボタンを左端から少し内側に配置する
                    
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
                    
                    // 笑顔の分類確信度のラベル
                    Text(cameraViewModel.confidenceLabel)
                        .font(.largeTitle)
                        .padding()
                }
            }
        }
    }
}
