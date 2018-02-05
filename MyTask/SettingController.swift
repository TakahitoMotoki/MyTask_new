//
//  SettingController.swift
//  MyTask
//
//  Created by 元木嵩人 on 2018/01/19.
//  Copyright © 2018年 元木嵩人. All rights reserved.
//

import Foundation
import UIKit
import NCMB
import SCLAlertView

class SettigController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let sectionTitle = ["Inputs", "ライセンス", "アカウント"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // !---   TableView Required Method Start   ---!
    // Decide the number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    // Returns Section's title
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return 1
        }
        return 1
    }
    
    // Decide the value of mycell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "mycell")
        if indexPath[0] == 0 {
            cell.textLabel?.text = "履歴"
        } else if indexPath[0] == 1 {
            cell.textLabel?.text = "ライセンス"
        } else {
            cell.textLabel?.text = "ログアウト"
        }
        return cell
    }
    
    // This function is called when mycell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath[0] == 0 {
            print("")
        } else if indexPath[0] == 1 {
            print("")
        } else {
            let alertView = SCLAlertView()
            alertView.addButton("ログアウト") {
                NCMBUser.logOut()
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "goToLogin", sender: nil)
            }
            alertView.showSuccess("ログアウトしますか?", subTitle: "", closeButtonTitle: "キャンセル")
        }
    }
    // !---   TableView Required Method End   ---!
}
