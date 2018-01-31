//
//  LoginViewController.swift
//  MyTask
//
//  Created by 元木嵩人 on 2018/01/18.
//  Copyright © 2018年 元木嵩人. All rights reserved.
//

import Foundation
import UIKit
import NCMB

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwd: UITextField!
    @IBOutlet weak var error: UILabel!
    
    // !---   Not Completed Start   ---!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting of delegate
        passwd.delegate = self
        
        // Hide input string
        passwd.isSecureTextEntry = true
    }
    // !---   Not Completed End   ---!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // !---   Not Completed Start   ---!
    @IBAction func login() {
        NCMBUser.logInWithMailAddress(inBackground: email.text, password: passwd.text) { (user, error) in
            if error != nil {
                // Failure of Login
                self.error.text = "EmailとPasswordのどちらか、もしくはその両方が間違っています"
                self.error.textColor = UIColor.red
                print(self.email.text)
                print(self.passwd.text)
                print(error)
            } else {
                // Success of Login
                print(error)
                self.performSegue(withIdentifier: "toFirst", sender: nil)
            }
        }
        
    }
    // !---   Not Completed End   ---!

    // !---   Not Completed Start   ---!
    @IBAction func goToSignUp() {
        self.performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    // !---   Not Completed End   ---!
    
    // !---   Not Completed Start   ---!
    @IBAction func forgetPassword() {
        
    }
    // !---   Not Completed End   ---!
}