import SwiftUI
import AVFoundation
import CoreML
import Vision

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let cameraViewController = CameraViewController()
        NotificationCenter.default.addObserver(cameraViewController, selector: #selector(CameraViewController.switchCamera), name: .switchCamera, object: nil)
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var currentCamera: AVCaptureDevice.Position = .front
    private var videoDevice: AVCaptureDevice?
    private let photoOutput = AVCapturePhotoOutput()
    private var smileDetected = false
    private var canTakePhoto = true
    private var confidenceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupConfidenceLabel()
    }
    
    // カメラのセットアップ
    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        captureSession.beginConfiguration()
        
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                captureSession.removeInput(input)
            }
        }
        
        let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCamera) ?? AVCaptureDevice.default(for: .video)
        self.videoDevice = videoCaptureDevice
        guard let videoDevice = videoCaptureDevice, let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        captureSession.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = view.layer.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
    }
    
    // 内カメラ・外カメラの切り替え
    @objc func switchCamera() {
        reverseCameraPosition()
    }
    
    // カメラの切り替え
    func reverseCameraPosition() {
        // 新しいカメラポジションを設定
        let newCameraPosition: AVCaptureDevice.Position = self.currentCamera == .front ? .back : .front
        self.currentCamera = newCameraPosition
        
        // アニメーションの開始
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
            self.previewLayer?.opacity = 0
        }, completion: { _ in
            self.captureSession?.beginConfiguration()
            
            // 既存の入力をすべて削除
            if let inputs = self.captureSession?.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    self.captureSession?.removeInput(input)
                }
            }
            
            let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: self.currentCamera) ?? AVCaptureDevice.default(for: .video)
            self.videoDevice = videoCaptureDevice
            guard let videoDevice = videoCaptureDevice, let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
            
            if self.captureSession?.canAddInput(videoInput) == true {
                self.captureSession?.addInput(videoInput)
            }
            
            self.captureSession?.commitConfiguration()
            
            let newVideoLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
            newVideoLayer.frame = self.view.bounds
            newVideoLayer.videoGravity = .resizeAspectFill
            
            // 新しいプレビューを設定してアニメーションを完了
            UIView.transition(with: self.view, duration: 0.5, options: [.transitionFlipFromRight], animations: {
                self.view.layer.replaceSublayer(self.previewLayer!, with: newVideoLayer)
                self.previewLayer = newVideoLayer
            }, completion: { _ in
                self.captureSession?.startRunning()
            })
        })
    }
    
    // 確度ラベルのセットアップ
    func setupConfidenceLabel() {
        confidenceLabel = UILabel()
        confidenceLabel.translatesAutoresizingMaskIntoConstraints = false
        confidenceLabel.textColor = .white
        confidenceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        confidenceLabel.text = "smile: 0%"
        view.addSubview(confidenceLabel)
        
        // 確度ラベルを右下に配置
        NSLayoutConstraint.activate([
            confidenceLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confidenceLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        detectSmile(in: sampleBuffer)
    }
    
    // 笑顔かどうかを分類し、笑顔の場合撮影
    func detectSmile(in sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNCoreMLRequest(model: try! VNCoreMLModel(for: SmileClassifier().model)) { request, error in
            if let results = request.results as? [VNClassificationObservation] {
                for result in results {
                    // クラスと確度ラベルを更新
                    DispatchQueue.main.async {
                        let labelText = "\(result.identifier): \(String(format: "%.2f", result.confidence * 100))%"
                        self.confidenceLabel.text = labelText
                    }
                    if result.identifier == "smile" && result.confidence > 0.95 && self.canTakePhoto {
                        self.canTakePhoto = false
                        self.capturePhoto()
                    }
                }
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
    
    // 写真を撮影
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // 写真がキャプチャされ、その処理が完了した後に呼び出される
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            self.smileDetected = false
            self.canTakePhoto = true
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            self.smileDetected = false
            self.canTakePhoto = true
            return
        }
        
        let image = UIImage(data: imageData)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        self.smileDetected = false
        
        // 5秒間の遅延を設定
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.canTakePhoto = true
        }
    }
}
