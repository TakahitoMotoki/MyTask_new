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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // !---   TableView Required Method Start   ---!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Decide the value of mycell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "mycell")
        cell.textLabel?.text = "Logout"
        return cell
    }
    
    // This function is called when mycell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertView = SCLAlertView()
        alertView.addButton("ログアウト") {
            NCMBUser.logOut()
            self.dismiss(animated: true, completion: nil)
        }
        alertView.showSuccess("ログアウトしますか?", subTitle: "", closeButtonTitle: "キャンセル")
        
    }
    // !---   TableView Required Method End   ---!
}
