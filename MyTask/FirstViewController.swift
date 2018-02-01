//
//  FirstViewController.swift
//  MyTask
//
//  Created by 元木嵩人 on 2018/01/11.
//  Copyright © 2018年 元木嵩人. All rights reserved.
//

/* Todo
*/

import Foundation
import UIKit
import NCMB
import SCLAlertView
import SwiftyButton

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var level_container: UILabel!
    @IBOutlet weak var experience_bar: UIProgressView!
    @IBOutlet weak var sort_label: UILabel!
    @IBOutlet weak var sort_button: PressableButton!
    @IBOutlet weak var tasks_table: UITableView!
    @IBOutlet weak var create_button: PressableButton!
    var tasks: [NCMBObject]!
    var sort_pointer = 0
    var cell_pointer = 0
    var cell_number: Int!
    var level: Int = 0
    var current_user: NCMBUser = NCMBUser.current()
    let SORT_NUMBER = 6
    let SORT_GENRE = ["全て", "本", "課題", "雑用", "自習", "その他"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        level_container.text = "Level. \(calcLevel()["level"]!)"
        level = calcLevel()["level"]!
        experience_bar.progress = Float(Int(calcLevel()["diff"]!) / Int(ceil(exp(Double(calcLevel()["level"]!)))))
        
        sort_button.colors = .init(button: .gray, shadow: .darkGray)
        sort_button.shadowHeight = 2
        sort_button.cornerRadius = 5
        
        create_button.colors = .init(button: .green, shadow: UIColor(red: 0.0, green: 0.8, blue: 0.5, alpha: 1.0))
        create_button.shadowHeight = 0
        create_button.cornerRadius = 30
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        queryExecution()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // !---   TableView Required Method Start   ---!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cell_number == nil {
            return 0
        } else {
            if sort_pointer == 0 {
                return cell_number
            } else {
                return sortCount()
            }
        }
    }
    
    // Decide the value of mycell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tasks_table.dequeueReusableCell(withIdentifier: "mycell") as! InputCell
        
        if cell_number != nil {
            if sort_pointer != 0 {
                for index in cell_pointer...tasks.count {
                    if sort_pointer == tasks[index].object(forKey: "type_id") as! Int {
                        cell_pointer = index + 1
                        // Input title into cell
                        cell.titleLabel.text = tasks[index].object(forKey: "title") as? String
                        let weight = tasks[index].object(forKey: "weight") as! Int
                        cell.weightLabel.text = "weight: \(weight)"
                        cell.weightImage.layer.cornerRadius = 12
                        cell.weightImage.clipsToBounds = true
                        
                        // Decide background color of cell
                        if weight >= 80 {
                            cell.weightImage.image = UIImage(named: "Red")
                        } else if weight >= 60 {
                            cell.weightImage.image = UIImage(named: "Orange")
                        } else if weight >= 40 {
                            cell.weightImage.image = UIImage(named: "Yellow")
                        } else if weight >= 20 {
                            cell.weightImage.image = UIImage(named: "Blue")
                        } else {
                            cell.weightImage.image = UIImage(named: "Green")
                        }
                        return cell
                    }
                }
            } else {
            
                // Input title into cell
                cell.titleLabel.text = tasks[indexPath.row].object(forKey: "title") as? String
                let weight = tasks[indexPath.row].object(forKey: "weight") as! Int
                cell.weightLabel.text = "weight: \(weight)"
                cell.weightImage.layer.cornerRadius = 12
                cell.weightImage.clipsToBounds = true
                
                // Decide background color of cell
                if weight >= 80 {
                    cell.weightImage.image = UIImage(named: "Red")
                } else if weight >= 60 {
                    cell.weightImage.image = UIImage(named: "Orange")
                } else if weight >= 40 {
                    cell.weightImage.image = UIImage(named: "Yellow")
                } else if weight >= 20 {
                    cell.weightImage.image = UIImage(named: "Blue")
                } else {
                    cell.weightImage.image = UIImage(named: "Green")
                }
            }
        }
        return cell
    }
    
    // This function is called when mycell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertView = SCLAlertView()
        alertView.addButton("完了") {
            self.done(indexPath: indexPath.row)
        }
        alertView.addButton("削除") {
            self.delete(indexPath: indexPath.row)
        }
        alertView.showSuccess(tasks[Int(indexPath.row)].object(forKey: "title") as! String, subTitle: "が選択されました", closeButtonTitle: "閉じる")
        tasks_table.reloadData()
    }
    // !---   TableView Required Method End   ---!
    
    // !---   Not Completed Start   ---!
    // Sort the tasks by genre
    @IBAction func sort_by_genre() {
        sort_pointer = sort_pointer + 1
        if (sort_pointer >= SORT_NUMBER) {
            sort_pointer = 0
        }
        sort_label.text = SORT_GENRE[sort_pointer]
        cell_pointer = 0
        tasks_table.reloadData()
    }
    // !---   Not Completed End   ---!
    
    func setTasks(results: [NCMBObject]!) {
        tasks = results
        cell_number = tasks.count
        tasks_table.reloadData()
    }
    
    func queryExecution() {
        let query = NCMBQuery(className: "Tasks")
        query?.whereKey("isDone", equalTo: true)
        query?.whereKey("user_id", equalTo: NCMBUser.current().objectId)
        query?.findObjectsInBackground({ (results, error) in
            if (error != nil) {
                // 検索が失敗した時の処理
                
            } else {
                // 検索が成功した時の処理
                self.setTasks(results: results as! [NCMBObject])
            }
        })
    }
    
    // CRUD(Update): This func change isDone from true -> false and Update the data
    func done(indexPath: Int) {
        let today_string: String = makeTodayString()
        let query = NCMBQuery(className: "Tasks")
        query?.whereKey("objectId", equalTo: tasks[indexPath].objectId)
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                // Failed
            } else {
                //　Success
                let results = result as! [NCMBObject]
                let task = results.first
                let exp = self.current_user.object(forKey: "exp") as! Int
                let task_weight = task?.object(forKey: "weight") as! Int
                task?.setObject(today_string, forKey: "doneDate")
                task?.setObject(false, forKey: "isDone")
                task?.saveInBackground({ (error) in
                    if error != nil {
                        // Failed
                    } else {
                        // Success
                        self.queryExecution()
                        self.tasks_table.reloadData()
                    }
                })
                let tmp = Double(task_weight) * (100.0 + Double(self.level)) / 100.0
                self.current_user.setObject(exp + Int(tmp), forKey: "exp")
                self.current_user.saveInBackground({ (error) in
                    if error != nil {
                        // Failed
                    } else {
                        // Success
                        self.queryExecution()
                        self.tasks_table.reloadData()
                    }
                })
            }
        })
        level_container.text = "Level. \(calcLevel()["level"]!)"
        level = calcLevel()["level"]!
        experience_bar.progress = Float(Int(calcLevel()["diff"]!) / Int(ceil(exp(Double(calcLevel()["level"]!)))))
    }

    // CRUD(Delete): This func delete a task from DB forever
    func delete(indexPath: Int) {
        let query = NCMBQuery(className: "Tasks")
        query?.whereKey("objectId", equalTo: tasks[indexPath].objectId)
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                // Failed
            } else {
                // Success
                let results = result as! [NCMBObject]
                let task = results.first
                task?.deleteInBackground({ (error) in
                    if error != nil {
                        // Failed
                    } else {
                        // Success
                        self.queryExecution()
                        self.tasks_table.reloadData()
                    }
                })
            }
        })
    }
    
    // This func makes formatted String from Date
    func makeTodayString() -> String {
        let now = Date()
        let calendar = Calendar.current
        let year: String = String(calendar.component(.year, from: now))
        var month: String = String(calendar.component(.month, from: now))
        var day: String = String(calendar.component(.day, from: now))
        
        if Int(month)! < 10 {
            month = "0" + month
        }
        
        if Int(day)! < 10 {
            day = "0" + day
        }
        
        return year + "-" + month + "-" + day
    }
    
    private func sortCount() -> Int {
        var count = 0
        for index in 0...tasks.count - 1 {
            if tasks[index].object(forKey: "type_id") as! Int == sort_pointer {
                count = count + 1
            }
        }
        return count
    }
    
    private func calcLevel() -> [String: Int] {
        let exp_user = current_user.object(forKey: "exp") as! Int
        var exp_total = 0
        var level = 0
        var diff = 0
        while exp_user > exp_total {
            exp_total = exp_total + Int(exp(Double(Double(level) / 100.0)) * 100)
            level = level + 1
        }
        diff = exp_total - exp_user
        return ["level": level, "diff": diff]
    }
}
