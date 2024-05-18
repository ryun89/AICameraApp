import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var cameraAccessGranted = false
    @State private var cameraAccessDenied = false
    
    var body: some View {
        ZStack {
            if cameraAccessGranted {
                CameraView()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        // カメラ切り替えボタン
                        Button(action: {
                            NotificationCenter.default.post(name: .switchCamera, object: nil)
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .resizable()
                                .frame(width: 40, height: 30)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // 撮影ボタンのアクション
                    }) {
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 50)
                }
            } else if cameraAccessDenied {
                Text("カメラの使用権限が必要です。\n設定から権限を許可してください。")
                    .padding()
            } else {
                Text("カメラの使用権限をリクエスト中...")
                    .padding()
            }
        }
        .onAppear {
            requestCameraAccess()
        }
    }
    
    // カメラの使用許可を確認
    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.cameraAccessGranted = true
                } else {
                    self.cameraAccessDenied = true
                }
            }
        }
    }
}

extension Notification.Name {
    static let switchCamera = Notification.Name("switchCamera")
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
