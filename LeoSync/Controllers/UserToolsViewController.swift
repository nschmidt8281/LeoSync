//
//  UserToolsViewController.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 11/22/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import UIKit

class UserToolsViewController: UIViewController {
    
    // MARK: Properties
    
    // MARK: Variables
    
    // MARK: Outputs
    
    // MARK: Buttons
    @IBAction func btnCamera_TouchUpInside(_ sender: Any) {
    }
    
    @IBAction func btnVideoCamera_TouchUpInside(_ sender: Any) {
    }
    
    @IBAction func btnMicrophone_TouchUpInside(_ sender: Any) {
    }
    
    @IBAction func btnFiles_TouchUpInside(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "LeoSync"
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
