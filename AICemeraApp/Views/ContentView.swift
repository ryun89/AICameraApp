import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        VStack {
            CameraView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            Text(viewModel.confidenceLabel)
                .font(.largeTitle)
                .padding()
            Button(action: {
                viewModel.switchCamera()
            }) {
                Text("Switch Camera")
            }
            .padding()
        }
    }
}
