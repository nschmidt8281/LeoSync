//
//  InterimCameraViewController.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 12/2/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import UIKit
import Firebase

class InterimCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    let user = Auth.auth().currentUser!
    
    // MARK: Variables
    var storageRef = Storage.storage()
    var dataRef = Database.database().reference().child("photos")
    
    // MARK: Outlets
    @IBOutlet weak var imgPhoto: UIImageView!
    
    // MARK: Buttons
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgPhoto.image = selectedImage
        } else {
            print("Something went wrong")
        }
        
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func btnTakePicture_TouchUpInside(_ sender: Any) {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .camera
            imgPicker.allowsEditing = false
            // show the camera App
            self.present(imgPicker, animated: true, completion: nil)
    }

    @IBAction func btnSelectPhoto_TouchUpInside(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .photoLibrary
            imgPicker.allowsEditing = true // allow users to crop , etc.
            // show the photoLibrary
            self.present(imgPicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnSavePhoto_Touch(_ sender: Any) {
        
        if imgPhoto.image == nil {
            let ac = UIAlertController(title: "No photo to save!", message:"Please take or select a photo to save.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
        let imageData = UIImageJPEGRepresentation(imgPhoto.image!, 0.6)
        let compressedJPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
        
        let uid = String(describing: user.uid)
        let imageID = String(describing: Int(Date.timeIntervalSinceReferenceDate * 1000))
        
        let imagePath = "photos/\(uid)/\(imageID).jpg"
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        self.storageRef.reference().child(imagePath)
            .putData(imageData!, metadata: metadata) { [weak self] (metadata, error) in
                if let error = error {
                    print ("error uploading: \(error)")
                    return
                }
        }
        
        self.dataRef.child("\(uid)/\(imageID)").setValue(["imagePath" : imagePath])
        
        let ac = UIAlertController(title: "Photo Saved!", message:"The photo was saved successfully!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        
        imgPhoto.image = nil
        }
    }
    
    @IBAction func btnBack_Touch(_ sender: Any) {
        
        if imgPhoto.image != nil {
            let ac = UIAlertController(title: "Unsaved Image!", message:"You currently have an unsaved image, would you like to save it?", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { action in
                return
            }
            
            let leaveAction = UIAlertAction(title: "Delete", style: .default) { action in
                self.imgPhoto.image = nil
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserAccountHomePage")
                self.present(vc!, animated: true, completion: nil)
            }
            
            ac.addAction(saveAction)
            ac.addAction(leaveAction)
            
            present(ac, animated: true, completion: nil)

        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserAccountHomePage")
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    // MARK: Methods
    func configureStorage() {
        let storageUrl = FirebaseApp.app()?.options.storageBucket
        self.storageRef.reference(forURL: "gs://" + storageUrl!)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}