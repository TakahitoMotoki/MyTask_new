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

class SettigController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let SECTION_NUMBER =  [1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // !---   TableView Required Method Start   ---!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SECTION_NUMBER[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SECTION_NUMBER.count
    }
    
    // Decide the value of mycell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "mycell")
        cell.textLabel?.text = "Logout"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "", message: "Logoutしますか?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Logout", style: .default) { (action1) in
            NCMBUser.logOut()
        }
        let action2 = UIAlertAction(title: "　キャンセル", style: .default) { (acton2) in
            alert.dismiss(animated: true, completion: nil)
        }
    }
    // !---   TableView Required Method End   ---!
}
