//
//  SignUpViewController.swift
//  MyTask
//
//  Created by 元木嵩人 on 2018/01/18.
//  Copyright © 2018年 元木嵩人. All rights reserved.
//

import Foundation
import UIKit
import NCMB
import SCLAlertView

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var ruleSwitch: UISwitch!
    @IBOutlet weak var ruleSwitchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendEmail() {
        let alertView = SCLAlertView()
        
        if ruleSwitch.isOn {
            if email.text != "" {
                alertView.addButton("送信") {
                    NCMBUser.requestAuthenticationMail(self.email.text!, error: nil)
                    self.dismiss(animated: true, completion: nil)
                }
                alertView.showSuccess(email.text!, subTitle: "にメールを送信しますか?", closeButtonTitle: "閉じる")
            } else {
                alertView.showError("Emailを入力してください", subTitle: "", closeButtonTitle: "閉じる")
            }
        } else {
            alertView.showError("利用規約に同意してください", subTitle: "", closeButtonTitle: "閉じる")
        }
    }
    
    @IBAction func getUISwitchValue(_ sender: UISwitch) {
        ruleSwitchLabel.text = sender.isOn ? "に同意する：はい":"に同意する：いいえ"
    }
    
    @IBAction func showRule() {
        self.performSegue(withIdentifier: "popup", sender: nil)
    }
    
    @IBAction func goToLogin() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // This func is used to close Keyboard called by TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}
