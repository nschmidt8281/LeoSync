//
//  CameraViewController.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 12/6/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, AVCaptureFileOutputRecordingDelegate, AVCapturePhotoCaptureDelegate {
    
    // MARK: Properties
    
    // MARK: Variables
    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var videoInput: AVCaptureDeviceInput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var stillImageOutput = AVCapturePhotoOutput()
    var didTakePhoto = Bool()

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Outputs
    @IBOutlet var tempImage: UIView!
    @IBOutlet weak var viewCameraView: UIView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var cameraImage: UIImageView!
    
    
    // MARK: Buttons
    @IBAction func btnTakePicture_TouchUpInside(_ sender: UIButton) {
        let stillImageOutput = self.stillImageOutput
        let outPath = "\(NSTemporaryDirectory())output.jpeg"
        let outURL = URL(fileURLWithPath: outPath)
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: outPath) {
            do {
                try fileManager.removeItem(at: outURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    // MARK: Methods
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        let cameraDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified).devices
        for device in cameraDevice {
            let device = device
            if device.position == AVCaptureDevice.Position.back {
                captureDevice = device
                break
            }
        }
        setupInputAndOutput()
        setupPreviewLayer()
    }
    
    func setupInputAndOutput() {
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession.addInput(videoInput!)
            
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func setupPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = viewCameraView.frame
        
        viewCameraView.layer.addSublayer(previewLayer)
        
        stillImageOutput.isHighResolutionCaptureEnabled = true
        
        captureSession.startRunning()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        // Check if there is any error in capturing
        guard error == nil else {
            print("Fail to capture photo: \(String(describing: error))")
            return
        }
        
        // Check if the pixel buffer could be converted to image data
        guard let imageData = photo.fileDataRepresentation() else {
            print("Fail to convert pixel buffer")
            return
        }
        
        // Check if UIImage could be initialized with image data
        guard let capturedImage = UIImage.init(data: imageData , scale: 1.0) else {
            print("Fail to convert image data to UIImage")
            return
        }
        
        // Get original image width/height
        let imgWidth = capturedImage.size.width
        let imgHeight = capturedImage.size.height
        // Get origin of cropped image
        let imgOrigin = CGPoint(x: (imgWidth - imgHeight)/2, y: (imgHeight - imgHeight)/2)
        // Get size of cropped iamge
        let imgSize = CGSize(width: imgHeight, height: imgHeight)
        
        // Check if image could be cropped successfully
        guard let imageRef = capturedImage.cgImage?.cropping(to: CGRect(origin: imgOrigin, size: imgSize)) else {
            print("Fail to crop image")
            return
        }
        
        // Convert cropped image ref to UIImage
        let imageToSave = UIImage(cgImage: imageRef, scale: 1.0, orientation: .down)
        
        // Stop video capturing session (Freeze preview)
        let imageDataToSave = UIImageJPEGRepresentation(imageToSave, 0.2)
        
        captureSession.stopRunning()
        
        cameraImage.image = imageToSave
    }
    
    /*
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if error != nil {
            print(error as! String)
        } else {
            let imageUIImage = imageFromSampleBuffer(sampleBuffer: photoSampleBuffer!)
            let imageData = UIImageJPEGRepresentation(imageUIImage, 0.2)
            
            self.tempImageView.image = imageUIImage
            self.tempImageView.isHidden = false
        }
    }
     */
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print(outputFileURL.absoluteString)
    }
    
    func didPressTakeAnother() {
        if didTakePhoto == true {
            tempImage.isHidden = true
            didTakePhoto = false
        } else {
            didTakePhoto = true
            captureSession.startRunning()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
