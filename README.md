# AICameraApp

## 概要
AICameraAppは、カメラを使用して笑顔を検出し、その瞬間を自動的に撮影するiOSアプリです。このアプリは、CoreMLとVisionフレームワークを活用してリアルタイムで笑顔を認識します。

## 機能
- リアルタイムで笑顔を検出
- 笑顔を検出すると自動的に写真を撮影
- 前面および背面カメラの切り替え
- 笑顔の検出確度を表示
- 撮影後のクールダウンタイム（5秒間）

## 使用技術
- SwiftUI
- AVFoundation
- CoreML
- Vision
- Swift Concurrency

## インストール
このアプリをインストールするには、以下の手順に従ってください：

1. このリポジトリをクローンします：
    ```bash
    git clone https://github.com/yourusername/smile-capture-camera-app.git
    ```
2. Xcodeでプロジェクトを開きます：
    ```bash
    cd smile-capture-camera-app
    open SmileCaptureCameraApp.xcodeproj
    ```
3. 必要な依存関係をインストールします。
4. アプリをビルドし、実機またはシミュレータで実行します。

## 使用方法
1. アプリを起動します。
2. デバイスのカメラに顔を向けます。
3. 笑顔を検出すると、自動的に写真が撮影されます。
4. 撮影後、5秒間は再度笑顔を検出しても撮影されません。
5. 右上のボタンをタップして、前面および背面カメラを切り替えることができます。
