import SwiftUI

struct HomeView: View {
    @State private var showInstructions = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // アプリ名
            Text("SmileCaptureCamera")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            // アプリのロゴ
            Image("LaunchImage")
                .resizable()
                .scaledToFit()
                .frame(width: 200.0, height: 200.0)
                .padding(.top, 20.0)
            
            Spacer()
            
            // 撮影開始ボタン
            Button(action: {
                // カメラ画面へ遷移する処理
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Start Capture")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.orange)
                .cornerRadius(10)
                .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // 使い方のアイコン
            HStack {
                Spacer()
                
                Button(action: {
                    showInstructions.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                }
                .padding()
                .sheet(isPresented: $showInstructions) {
                    InstructionsView()
                }
            }
        }
    }
}

struct InstructionsView: View {
    var body: some View {
        VStack {
            Text("使い方")
                .font(.title)
                .padding()
            
            Text("1. 「撮影開始」ボタンを押してカメラを起動します。\n2. カメラの前で笑顔を作ってください。\n3. 笑顔が検出されると自動的に写真が撮影されます。\n4. 撮影した写真は、画面下のギャラリーで確認・共有できます。")
                .padding()
            
            Spacer()
        }
    }
}


#Preview {
    HomeView()
}
