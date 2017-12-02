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
    var storageRef = Storage.storage().reference()
    
    // MARK: Variable
    var admin: Bool = false
    
    // MARK: Outputs
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblUserFirstName: UILabel!
    @IBOutlet weak var lblUserLastName: UILabel!
    @IBOutlet weak var lblUserAdmin: UILabel!
    
    // MARK: Methods
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidLoad() {
        let uid = String(describing: user.uid)
        
        dataRef.child("users/\(uid)").observe(.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            
            self.lblUserEmail.text = "User Email: " + (value?["email"] as? String)!
            self.lblUserFirstName.text = "First Name: " + (value?["firstName"] as? String)!
            self.lblUserLastName.text = "Last Name: " + (value?["lastName"] as? String)!
            self.admin = (value?["admin"] as? Bool)!
            
            if self.admin == true {
                self.lblUserAdmin.text = "Admin Rights: Yes"
            } else {
                self.lblUserAdmin.text = "Admin Rights: No"
            }
            
            self.navigationItem.title = value?["company"] as? String
        })
        
        let profileImgRef = storageRef.child("profilePhotos/\(uid)/profileImage.png")
        profileImgRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Error
            } else {
                let profileImage = UIImage(data: data!)
                self.imgUserPhoto.image = profileImage
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
