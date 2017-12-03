//
//  UserNavigationViewController.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 12/3/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import UIKit
import Firebase

class UserNavigationViewController: UINavigationController {
    
    // MARK: Properties
    let user = Auth.auth().currentUser!
    let dataRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataRef.child("users/\(user.uid)").observe(.value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            self.navigationItem.title = value?["company"] as? String
            
        })
    }
}
