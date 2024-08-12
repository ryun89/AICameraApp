import SwiftUI

// ホーム画面
struct ContentView: View {
    // 使い方を表示するかどうかのフラグを格納する変数
    @State private var showInstructions = false
    
    // 画面遷移するかどうかのフラグを格納する変数
    @State private var isNavigating = false
    
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
                    isNavigating = true // ボタンが押されたらフラグを変更する
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
                .fullScreenCover(isPresented: $isNavigating) {
                    // ボタンが押されると CaptureView へ遷移
                    CaptureView()
                        .edgesIgnoringSafeArea(.all)
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

// アプリの使い方を表示する画面
struct InstructionsView: View {
    // 選択されたタブの情報を保持する変数
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            Picker(selection: $selectedTab, label: Text("Language")) {
                Text("日本語").tag(0)
                Text("English").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedTab == 0 {
                Text("使い方\n\n1. 「Start Capture」ボタンを押してカメラを起動します。\n2. カメラの前で笑顔を作ってください。\n3. 笑顔が検出されると自動的に写真が撮影されます。\n4. 撮影後、5秒間のクールダウンタイムがあります。この間は撮影できません。\n5. 撮影した写真は、画面下のギャラリーで確認・共有できます。")
                    .padding()
            } else {
                Text("Instructions\n\n1. Press the 'Start Capture' button to start the camera.\n2. Smile in front of the camera.\n3. The camera will automatically take a photo when a smile is detected.\n4. After each photo, there is a 5-second cooldown period during which no photos can be taken.\n5. You can view and share the photos in the gallery at the bottom of the screen.")
                    .padding()
            }
            
            Spacer()
            
        }
    }
}


#Preview {
    ContentView()
}
