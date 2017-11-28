//
//  CameraViewController.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 11/22/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // MARK: Properties
    let captureDevice = AVCaptureDevice.default(for: .video)!
    let captureSession = AVCaptureSession()
    
    // MARK: Variables
    var stillImageOutput = AVCapturePhotoOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Outputs
    @IBOutlet weak var viewCameraView: UIView!
    
    // MARK: Buttons
    @IBAction func btnTakePicture_TouchUpInside(_ sender: UIButton) {
        let stillImageOutput = AVCapturePhotoOutput()
        
        guard self.captureSession.canAddOutput(stillImageOutput) else { return }
        
        captureSession.addOutput(stillImageOutput)

        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
        
        print("Image Taken")
    }
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        self.captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        viewCameraView.layer.addSublayer(previewLayer!)
        previewLayer?.frame = viewCameraView.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
