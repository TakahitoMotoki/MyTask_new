//
//  ForgetPasswordViewController.swift
//  MyTask
//
//  Created by 元木嵩人 on 2018/01/18.
//  Copyright © 2018年 元木嵩人. All rights reserved.
//

import Foundation
import UIKit
import NCMB
import SCLAlertView

class ForgetPasswordViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendEmail() {
        let alertView = SCLAlertView()
        
        if email.text != "" {
            alertView.addButton("送信") {
                NCMBUser.requestPasswordReset(forEmail: self.email.text!, error: nil)
                self.dismiss(animated: true, completion: nil)
            }
            alertView.showSuccess(email.text!, subTitle: "にメールを送信しますか?", closeButtonTitle: "閉じる")
        } else {
            alertView.showError("Emailを入力してください", subTitle: "", closeButtonTitle: "閉じる")
        }
    }
    
    @IBAction func goToLogin() {
        self.dismiss(animated: true, completion: nil)
    }
}
