//
//  LoginViewController.swift
//  LeoSync
//
//  Created by Nicolas Schmidt on 11/22/17.
//  Copyright © 2017 408 Industries. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    let CheckBox = UIImage(named: "Checked_Box")
    let UncheckedBox = UIImage(named: "Unchecked_Box")
    
    
    // MARK: Variables
    var boxChecked: Bool = false
    
    
    // MARK: Outlets
    @IBOutlet weak var btnCheckmarkImage: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    // MARK: Buttons
    @IBAction func btnCheckmark_TouchUpInside(_ sender: UIButton) {
        
        // Toggle "Remember Me" checkbox
        if boxChecked == true {
            
            boxChecked = false
            btnCheckmarkImage.setImage(CheckBox, for: UIControlState.normal)
            
        } else {
            
            boxChecked = true
            btnCheckmarkImage.setImage(UncheckedBox, for: UIControlState.normal)
        }
    }
    
    @IBAction func btnLogin_TouchUpInside(_ sender: AnyObject?) {
        if let email = txtEmail.text, let password = txtPassword.text {
//        let email = "test@test.com", password = "test123"
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                // Sign in successful -> Go to homepage
                if user != nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "userAccountHomePage")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Login Failed", message: (error?.localizedDescription)!, preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result: UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    // MARK: Functions
    
    // Next and Go keyboard features
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txtEmail.isFirstResponder == true {
            txtEmail.resignFirstResponder()
            txtPassword.becomeFirstResponder()
        } else {
            self.btnLogin_TouchUpInside(nil)
            txtPassword.resignFirstResponder()
        }
        return false
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
