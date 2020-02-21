//
//  QRScannerViewController.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 12/30/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import UIKit
import AVFoundation

internal class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    internal static let identifier: String = "QRScannerViewController"
    
    @IBOutlet weak var alternativeLoginButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var detectionMessageLabel: UILabel!
    @IBOutlet weak var networkActivityIndicator: UIActivityIndicatorView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private var scannedInvalidCodes: Set<String> = Set()

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupQRCameraScanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSpecifiedShadow(detectionMessageLabel)
        detectionMessageLabel.clipsToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    private func setupButtons() {
        addSpecifiedShadow(alternativeLoginButton)
        setupFontOf(alternativeLoginButton)
        
        addSpecifiedShadow(cancelButton)
        setupFontOf(cancelButton)
    }
    
    private func setupQRCameraScanner() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            try setupCaptureSession(captureDevice)
            view.bringSubviewToFront(cancelButton)
            view.bringSubviewToFront(alternativeLoginButton)
            view.bringSubviewToFront(networkActivityIndicator)
            captureSession?.startRunning()
            setupQRFrame()
        } catch {
            print(error)
            return
        }
    }
    
    private func setupCaptureSession(_ captureDevice: AVCaptureDevice) throws {
        
        let input = try AVCaptureDeviceInput(device: captureDevice)
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        if let session = captureSession {
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            
            guard let previewLayer = self.videoPreviewLayer else {
                return
            }
            
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer.frame = view.layer.bounds
            view.layer.addSublayer(previewLayer)
        }
    }
    
    private func setupQRFrame() {
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
            view.bringSubviewToFront(detectionMessageLabel)
        }
    }
    
    private func setupFontOf(_ button: UIButton) {
        button.setTitleColor(BACKGROUND_COLOR, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard
            !metadataObjects.isEmpty,
            let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
            metadataObj.type == AVMetadataObject.ObjectType.qr,
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj),
            let barCodeStringValue = metadataObj.stringValue
        else {
            qrCodeFrameView?.frame = CGRect.zero
            detectionMessageLabel.text = "No QR Code Detected"
            detectionMessageLabel.isHidden = false
            return
        }
        
        qrCodeFrameView?.frame = barCodeObject.bounds
        processQR(barCodeStringValue)
    }
    
    private func processQR(_ publicUUID: String) {
        
        detectionMessageLabel.isHidden = true
        networkActivityIndicator.startAnimating()
        
        guard !self.scannedInvalidCodes.contains(publicUUID) else {
            detectionMessageLabel.text = "Invalid QR Code"
            qrCodeFrameView?.frame = CGRect.zero
            detectionMessageLabel.isHidden = false
            networkActivityIndicator.stopAnimating()
            return
        }
        
        validateQRCode(publicUUID: publicUUID) { (authCode) in
            self.networkActivityIndicator.stopAnimating()
            
            guard let authCode = authCode else {
                self.detectionMessageLabel.text = "Invalid QR Code"
                self.detectionMessageLabel.isHidden = false
                self.scannedInvalidCodes.insert(publicUUID)
                self.captureSession?.startRunning()
                return
            }
            
            UserDefaultsHolder.setUser(HackerUUID(publicUUID: publicUUID, authCode: authCode))
            self.captureSession?.stopRunning()
            self.cancelButtonClicked(self.cancelButton as Any)
        }
    }
    
    private func validateQRCode( publicUUID: String, _ completion: @escaping (String?) -> Void) {
        
        guard !self.scannedInvalidCodes.contains(publicUUID) else {
            completion(nil)
            return
        }
        
        self.captureSession?.stopRunning()
        HackerRequestSingletonFunction.loginHacker(publicUUID: publicUUID) { (authCode) in
            completion(authCode)
            return
        }
        
        return
    }
    
    @IBAction func alternativeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
