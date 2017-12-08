//
//  UserAccountViewController.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 11/22/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import UIKit
import Firebase

class UserAccountViewController: UIViewController {
    
    // MARK: Properties
    let user = Auth.auth().currentUser!
    let dataRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    
    // MARK: Variable
    var userInfo: User?
    var userProfileImage: UIImage?
    
    // MARK: Outputs
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblUserFirstName: UILabel!
    @IBOutlet weak var lblUserLastName: UILabel!
    @IBOutlet weak var lblUserAdmin: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: Buttons
    @IBAction func btnSignOut_Touch(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignIn")
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    // MARK: Methods
    override func viewWillAppear(_ animated: Bool) {
        let uid = String(describing: user.uid)
        
        dataRef.child("users/\(uid)").observe(.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            
            let company = (value?["company"] as? String)!
            let email = (value?["email"] as? String)!
            let firstName = (value?["firstName"] as? String)!
            let lastName = (value?["lastName"] as? String)!
            let admin = (value?["admin"] as? Bool)!
            
            self.userInfo = User(uid: uid,
                                 email: email,
                                 firstName: firstName,
                                 lastName: lastName,
                                 company: company,
                                 admin: admin)
        })
        
        let profileImgRef = storageRef.child("profilePhotos/\(uid)/profileImage.png")
        profileImgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                let errorDesc = error?.localizedDescription
                if errorDesc == "Object profilePhotos/\(uid)/profileImage.png does not exist." {
                    let profileImageData = UIImagePNGRepresentation(UIImage(named: "profileImage")!) as Data?
                    let imagePath = "profilePhotos/\(uid)/profileImage.png"
                    
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/png"
                    
                    self.storageRef.child(imagePath)
                        .putData(profileImageData!, metadata: metadata) { (metadata, error) in
                            if let error = error {
                                print ("Uploading Error: \(error)")
                                return
                            }
                    }
                    self.userProfileImage = UIImage(named: "profileImage")
                } else {
                    return
                }
            } else {
                self.userProfileImage = UIImage(data: data!)
                self.displayContent()
            }
        }
    }
    
    override func viewDidLoad() {
        self.spinner.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayContent() {
        self.spinner.stopAnimating()
        
        self.navigationItem.title = self.userInfo?.company
        
        self.lblUserEmail.text = "Account Email: " + (userInfo?.email)!
        self.lblUserFirstName.text = "First Name: " + (userInfo?.firstName)!
        self.lblUserLastName.text = "Last Name: " + (userInfo?.lastName)!
        
        if self.userInfo?.admin == true {
            self.lblUserAdmin.text = "Admin Rights: Yes"
        } else {
            self.lblUserAdmin.text = "Admin Rights: No"
        }
        
        self.imgUserPhoto.image = self.userProfileImage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
