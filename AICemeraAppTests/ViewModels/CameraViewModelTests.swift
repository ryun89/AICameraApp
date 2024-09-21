import SwiftUI
import XCTest
import Vision
import UIKit
import AVFoundation
import Foundation
@testable import AICemeraApp

class CameraViewModelTests: XCTestCase {
    
    // カメラのセットアップが正常に行われるかについてのテスト
    func testSetUpCamera() {
        // データの準備
        var viewModel = CameraViewModel()
        
        // 実行
        viewModel.setupCamera()
        
        // テスト
        XCTAssertNotNil(viewModel.captureSession, "CaptureSessionが初期化されていません。")
        XCTAssertTrue(viewModel.captureSession?.isRunning == true, "CaptureSessionが正しく動作していません。")
    }
    
    // カメラの切り替えができるかを確認するテスト 現在のカメラの位置を取得する方法がわからん
    func testSwichCamera() {
        // データの準備
        var viewModel = CameraViewModel()
        viewModel.setupCamera()
        let initialCameraPosition = AVCaptureDevice.Position.front
        
        // 実行
        viewModel.switchCamera()
        
        // テスト
//        XCTAssertNotEqual(initialCameraPosition, viewModel.currentCamera, "カメラの切り替えが正常に行われていません。")
    }
}
