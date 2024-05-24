import SwiftUI
import AVFoundation
import CoreML
import Vision

struct CameraView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let cameraLayer = AVCaptureVideoPreviewLayer(session: viewModel.captureSession!)
        cameraLayer.frame = viewController.view.bounds
        cameraLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(cameraLayer)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {

}
