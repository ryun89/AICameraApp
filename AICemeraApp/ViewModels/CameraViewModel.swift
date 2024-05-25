import SwiftUI
import Vision
import UIKit
import AVFoundation
import Foundation

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    @Published var canTakePhoto = true
    @Published var confidenceLabel: String = "smile: 0%"
    
    var captureSession: AVCaptureSession?
    private var currentCamera: AVCaptureDevice.Position = .front
    private let photoOutput = AVCapturePhotoOutput()
    private var smileClassificaterModel = SmileClassifierModel()
    
    override init() {
        super.init()
        setupCamera()
    }
    
    // カメラのセットアップ
    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        captureSession.beginConfiguration()
        
        let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCamera) ?? AVCaptureDevice.default(for: .video)
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
        captureSession.startRunning()
    }
    
    // カメラの切り替え
    func switchCamera() {
        captureSession?.beginConfiguration()
        let currentInputs = captureSession?.inputs
        for input in currentInputs ?? [] {
            captureSession?.removeInput(input)
        }
        // 新しいカメラポジションを設定
        let newCameraPosition: AVCaptureDevice.Position = reverseCameraPosition(currentCamera: currentCamera)
        self.currentCamera = newCameraPosition
        let newVideoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: self.currentCamera) ?? AVCaptureDevice.default(for: .video)
        guard let newVideoDevice = newVideoCaptureDevice, let newVideoInput = try? AVCaptureDeviceInput(device: newVideoDevice) else { return }
        
        if captureSession?.canAddInput(newVideoInput) == true {
            captureSession?.addInput(newVideoInput)
        }
            
        self.captureSession?.commitConfiguration()
        }
    
    // カメラの位置を反転します
    func reverseCameraPosition(currentCamera: AVCaptureDevice.Position) -> AVCaptureDevice.Position {
        if currentCamera == .front {
            return .back
        }
        else {
            return .front
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        detectSmile(in: sampleBuffer)
    }
    
    // 笑顔かどうかを分類し、笑顔の場合撮影
    func detectSmile(in sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = smileClassificaterModel.createRequest { [weak self] results in
            guard let self = self else { return }
            if let results = results {
                for result in results {
                    // クラスと確度ラベルを更新
                    Task { @MainActor in
                        let labelText = "\(result.identifier): \(String(format: "%.2f", result.confidence * 100))%"
                        self.confidenceLabel = labelText
                    }
                    if result.identifier == "smile" && result.confidence >= 0.99 && self.canTakePhoto {
                        Task {
                            await self.handleSmileDetect()
                        }
                    }
                }
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
    
    // 笑顔認識を操作する
    @MainActor
    func handleSmileDetect() async {
        self.canTakePhoto = false // 撮影を一時無効化
        self.capturePhoto() // 写真を保存する
        
        // 5秒のクールダウン
        try? await Task.sleep(nanoseconds: 5 * 1_000_000_000)
        self.canTakePhoto = true  // 5秒後に再度写真撮影を有効化
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
            self.canTakePhoto = true
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            self.canTakePhoto = true
            return
        }
        
        let image = UIImage(data: imageData)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    }
