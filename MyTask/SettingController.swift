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
    @IBOutlet weak var settingTable: UITableView!
    let sectionTitle = ["  ライセンス", "  アカウント"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTable.separatorColor = UIColor.clear
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // !---   TableView Required Method Start   ---!
    // Decide the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    // Upper margin of section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    // Bottom margin of section
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    // Returns Section's title
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = sectionTitle[section]
        label.backgroundColor = UIColor(red: 38.0 / 255.0, green: 46.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
        label.textColor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 7.0 / 8.0, alpha: 1.0)
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return 1
        }
    }
    
    // Decide the value of mycell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTable.dequeueReusableCell(withIdentifier: "mycell") as! UITableViewCell
        if indexPath[0] == 0 {
            cell.textLabel?.text = "ライセンス"
        } else if indexPath[0] == 1 {
            cell.textLabel?.text = "ログアウト"
        }
        cell.textLabel?.textColor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 7.0 / 8.0, alpha: 1.0)
        return cell
    }
    
    // This function is called when mycell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath[0] == 0 {
            self.performSegue(withIdentifier: "goToLicense", sender: nil)
        } else if indexPath[0] == 1 {
            let alertView = SCLAlertView()
            alertView.addButton("ログアウト") {
                NCMBUser.logOut()
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "goToLogin", sender: nil)
            }
            alertView.showSuccess("ログアウトしますか?", subTitle: "", closeButtonTitle: "キャンセル")
        }
        settingTable.reloadData()
    }
    // !---   TableView Required Method End   ---!
}
