//
//  ScannerView.swift
//  MyTaxi
//
//  Created by Girish Dadhich on 06/07/23.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation
import CodeScanner
struct ScannerView: UIViewControllerRepresentable {
    @Binding var isVisible: Bool
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let scannerViewController = ScannerViewController(isVisible: $isVisible)
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
        // No need for implementation here
    }
}


class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @Binding var isVisible: Bool
    
    init(isVisible: Binding<Bool>) {
        self._isVisible = isVisible
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("No video capture device available")
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            fatalError("Unable to obtain video input from the device")
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            fatalError("Unable to add video input to the capture session")
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            fatalError("Unable to add metadata output to the capture session")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
}
//        captureMy apologies for the confusion. The code provided above is incomplete and doesn't include the full implementation of the QR code scanning functionality.
//
//To implement QR code scanning in SwiftUI, you can use the `CodeScanner` package provided by Apple. Here's an updated version of the `RideView` code that incorporates QR code scanning using `CodeScanner`:




