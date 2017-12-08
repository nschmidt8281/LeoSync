//
//  UserToolsViewController.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 11/22/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import UIKit
import Firebase

class UserToolsViewController: UIViewController {
    
    // MARK: Properties
    let dataRef = Database.database().reference()
    let user = Auth.auth().currentUser!
    
    // MARK: Variables
    
    // MARK: Outputs
    
    // MARK: Buttons
    @IBAction func btnCamera_TouchUpInside(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "cameraNavigationController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func btnVideoCamera_TouchUpInside(_ sender: Any) {
    }
    
    @IBAction func btnMicrophone_TouchUpInside(_ sender: Any) {
    }
    
    @IBAction func btnFiles_TouchUpInside(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "mediaNavigationController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func btnSignOut_Touch(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignIn")
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataRef.child("users/\(user.uid)").observe(.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            self.navigationItem.title = value?["company"] as? String
        })
    }
}

