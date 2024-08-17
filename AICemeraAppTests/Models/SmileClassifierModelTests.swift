import XCTest
import CoreML
import Vision
@testable import AICemeraApp

// SmileClassifierModelTestsのテストクラス
class SmileClassifierModelTests: XCTestCase {
    
    // モデルの初期化が正常に行われることを確認する
    func testModelInitialization() {
        let model = SmileClassifierModel()
        XCTAssertNotNil(model, "モデルの初期化に失敗しました。")
    }
    
    // リクエストが正常に作成され、結果が返ってくることを確認する
    func testCreateRequest() {
        let model = SmileClassifierModel()
        let expectation = self.expectation(description: "VNCoreMLRequestが正常に作成され、分類が行われることを期待します。")
        
        // モックデータ（テスト用の画像）を使用してリクエストをテストする
        let request = model.createRequest { results in
            XCTAssertNotNil(results, "分類結果が返されませんでした。")
            XCTAssertTrue(results?.count ?? 0 > 0, "分類結果が存在しません。")
            expectation.fulfill()
        }
        
        // サンプルの画像データを処理するハンドラを作成
        guard let sampleImage = UIImage(systemName: "swift"), let ciImage = CIImage(image: sampleImage) else {
            XCTFail("テスト用の画像を読み込むことができませんでした。")
            return
        }
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            XCTFail("リクエストの実行中にエラーが発生しました: \(error)")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
