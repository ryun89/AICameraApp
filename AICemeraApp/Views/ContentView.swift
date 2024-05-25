import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        ZStack {
            CameraView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        viewModel.switchCamera()
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
                    Spacer()
                    Text(viewModel.confidenceLabel)
                        .font(.largeTitle)
                        .padding()
                }
            }
        }
    }
}
