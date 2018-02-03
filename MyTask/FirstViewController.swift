//
//  FirstViewController.swift
//  MyTask
//
//  Created by 元木嵩人 on 2018/01/11.
//  Copyright © 2018年 元木嵩人. All rights reserved.
//

/* Todo
 sort した時のdeleteにバグがある。
 sortのindexPathを渡してしまうと、だめ
*/

import Foundation
import UIKit
import NCMB
import SCLAlertView
import SwiftyButton
import CoreData
import FontAwesomeKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var level_container: UILabel!
    @IBOutlet weak var experience_bar: UIProgressView!
    @IBOutlet weak var sort_label: UILabel!
    @IBOutlet weak var sort_image: UIImageView!
    @IBOutlet weak var sort_button: PressableButton!
    @IBOutlet weak var tasks_table: UITableView!
    @IBOutlet weak var create_button: PressableButton!
    var tasks: Array<Input>!
    var tasks_date: Array<Input>!
    var tasks_normal: Array<Input>!
    var sort_pointer = 0
    var cell_pointer = 0
    var cell_number: Int!
    var level: Int = 0
    var current_user: NCMBUser = NCMBUser.current()
    let SORT_NUMBER = 7
    let SORT_GENRE = ["全て", "仕事・バイト・インターン", "課題・宿題", "雑用", "自習", "その他", "したいこと", "期限順"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sort = FAKFontAwesome.globeIcon(withSize: 24.0)
        sort?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
        let sort_font = sort?.image(with: CGSize(width: 24.0, height: 24.0))
        sort_image.image = sort_font
        
        level_container.text = "Level. \(calcLevel()["level"]!)"
        level = calcLevel()["level"]!
        experience_bar.progress = Float(Int(calcLevel()["diff"]!) / Int(ceil(exp(Double(calcLevel()["level"]!)))))
        
        sort_button.colors = .init(button: .gray, shadow: .darkGray)
        sort_button.shadowHeight = 2
        sort_button.cornerRadius = 5
        
        create_button.colors = .init(button: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0), shadow: UIColor(red: 0.0, green: 0.8, blue: 0.5, alpha: 1.0))
        create_button.shadowHeight = 0
        create_button.cornerRadius = 30
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        sortTasksByDate()
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
            if sort_pointer == 0 || sort_pointer == SORT_NUMBER {
                return cell_number
            } else {
                return sortCount()
            }
        }
    }
    
    // Decide the value of mycell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tmp_cell = tasks_table.dequeueReusableCell(withIdentifier: "mycell") as! InputCell
        
        if cell_number != nil {
            if sort_pointer > 0 && sort_pointer < SORT_NUMBER {
                while cell_pointer < tasks.count {
                    if sort_pointer == tasks[cell_pointer].type_id {
                        let cell = makeCell(index: cell_pointer)
                        print(cell_pointer)
                        cell_pointer = cell_pointer + 1
                        return cell
                    }
                    cell_pointer = cell_pointer + 1
                }
            } else {
                if sort_pointer == SORT_NUMBER {
                    tasks = tasks_date
                }
                let cell = makeCell(index: indexPath.row)
                return cell
            }
        }
        return tmp_cell
    }
    
    func makeCell(index: Int) -> InputCell {
        let cell = tasks_table.dequeueReusableCell(withIdentifier: "mycell") as! InputCell

        // Input title into cell
        cell.titleLabel.text = tasks[index].title!
        let weight = tasks[index].weight
        cell.weightLabel.text = "経験値: \(weight)"
        cell.weightImage.layer.cornerRadius = 12
        cell.weightImage.clipsToBounds = true
        if tasks[index].days < 10000000 {
            cell.dateLabel.text = "期限: \(tasks[index].date!)"
        } else {
            cell.dateLabel.text = ""
        }
        var type = FAKFontAwesome.diamondIcon(withSize: 24.0)
        if tasks[index].type_id == 1 {
            type = FAKFontAwesome.briefcaseIcon(withSize: 24.0)
        } else if tasks[index].type_id == 2 {
            type = FAKFontAwesome.thumbTackIcon(withSize: 24.0)
        } else if tasks[index].type_id == 3 {
            type = FAKFontAwesome.paperclipIcon(withSize: 24.0)
        } else if tasks[index].type_id == 4 {
            type = FAKFontAwesome.pencilIcon(withSize: 24.0)
        } else if tasks[index].type_id == 5{
            type = FAKFontAwesome.tabletIcon(withSize: 24.0)
        } else {
            type = FAKFontAwesome.heartIcon(withSize: 24.0)
        }
        if tasks[index].type_id == 6 {
            type?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.red)
        } else {
            type?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
        }
        let type_font = type?.image(with: CGSize(width: 24.0, height: 24.0))
        cell.typeImage.image = type_font
        
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
    
    // This function is called when mycell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertView = SCLAlertView()
        alertView.addButton("完了") {
            self.done(indexPath: indexPath.row)
        }
        alertView.addButton("削除") {
            self.delete(indexPath: indexPath.row)
        }
        alertView.showSuccess(tasks[indexPath.row].title!, subTitle: "が選択されました", closeButtonTitle: "閉じる")
        tasks_table.reloadData()
    }
    // !---   TableView Required Method End   ---!
    
    // Sort the tasks by genre
    @IBAction func sort_by_genre() {
        sort_pointer = sort_pointer + 1
        if (sort_pointer > SORT_NUMBER) {
            sort_pointer = 0
        }
        sort_label.text = SORT_GENRE[sort_pointer]
        
        var sort = FAKFontAwesome.diamondIcon(withSize: 24.0)
        if sort_pointer == 0 {
            sort = FAKFontAwesome.globeIcon(withSize: 24.0)
        } else if sort_pointer == 1 {
            sort = FAKFontAwesome.briefcaseIcon(withSize: 24.0)
        } else if sort_pointer == 2 {
            sort = FAKFontAwesome.thumbTackIcon(withSize: 24.0)
        } else if sort_pointer == 3 {
            sort = FAKFontAwesome.paperclipIcon(withSize: 24.0)
        } else if sort_pointer == 4 {
            sort = FAKFontAwesome.pencilIcon(withSize: 24.0)
        } else if sort_pointer == 5 {
            sort = FAKFontAwesome.tabletIcon(withSize: 24.0)
        } else if sort_pointer == 6 {
            sort = FAKFontAwesome.heartIcon(withSize: 24.0)
        } else {
            sort = FAKFontAwesome.calendarIcon(withSize: 24.0)
        }
        if sort_pointer == 6 {
            sort?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.red)
        } else {
            sort?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
        }
        let sort_font = sort?.image(with: CGSize(width: 24.0, height: 24.0))
        sort_image.image = sort_font
        cell_pointer = 0
        print("+=+=+=+")
        print(cell_pointer)
        print("+=+=+=+")
        
        queryExecution()
        sortTasksByDate()
        print(tasks)
        tasks_table.reloadData()
    }
    
    func queryExecution() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            // CoreDataからデータをfetchしてtasksに格納
            let fetchRequest: NSFetchRequest<Input> = Input.fetchRequest()
            tasks = try context.fetch(fetchRequest)
            tasks_normal = try context.fetch(fetchRequest)
        } catch {
            print("Core Data Failed")
        }
        cell_number = tasks.count
        tasks_table.reloadData()
    }
    
    func queryExecution2() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            // CoreDataからデータをfetchしてtasksに格納
            let fetchRequest: NSFetchRequest<Input> = Input.fetchRequest()
            tasks = try context.fetch(fetchRequest)
            tasks_normal = try context.fetch(fetchRequest)
        } catch {
            print("Core Data Failed")
        }
    }
    
    func sortTasksByDate() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            // CoreDataからデータをfetchしてtasksに格納
            let fetchRequest: NSFetchRequest<Input> = Input.fetchRequest()
            let sortDescripter = NSSortDescriptor(key: "days", ascending: true)
            fetchRequest.sortDescriptors = [sortDescripter]
            tasks_date = try context.fetch(fetchRequest)
        } catch {
            print("Core Data Failed")
        }
    }
        
    // CRUD(Update): This func change isDone from true -> false and Update the data
    func done(indexPath: Int) {
        let index = modifyIndexPath(indexPath: indexPath)
        let today_string: String = makeTodayString()
        let object = NCMBObject(className: "Tasks")
        object?.setObject(tasks[index].title, forKey: "title")
        object?.setObject(tasks[index].weight, forKey: "weight")
        object?.setObject(tasks[index].type_id, forKey: "type_id")
        object?.setObject(false, forKey: "isDone")
        object?.setObject(NCMBUser.current().objectId, forKey: "user_id")
        object?.setObject(today_string, forKey: "doneDate")
        object?.saveInBackground({ (error) in
            if error != nil {
                // Failed
            } else {
                // Success
            }
        })
        let exp = self.current_user.object(forKey: "exp") as! Int
        let task_weight = tasks[index].weight
        let tmp = Double(task_weight) * (100.0 + Double(self.level)) / 100.0
        self.current_user.setObject(exp + Int(tmp), forKey: "exp")
        self.current_user.saveInBackground({ (error) in
            if error != nil {
                // Failed
            } else {
                // Success
                self.sortTasksByDate()
                self.queryExecution()
                self.tasks_table.reloadData()
            }
        })
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let deleteObject = tasks[index] as Input
        viewContext.delete(deleteObject)
        do{
            try viewContext.save()
        }catch{
            print(error)
        }
        
        level_container.text = "Level. \(calcLevel()["level"]!)"
        level = calcLevel()["level"]!
        //experience_bar.progress = Float(Int(calcLevel()["diff"]!) / Int(ceil(exp(Double(calcLevel()["level"]!)))))
    }

    // CRUD(Delete): This func delete a task from DB forever
    func delete(indexPath: Int) {
        let index = modifyIndexPath(indexPath: indexPath)
        print(index)
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let deleteObject = tasks[index] as Input
        viewContext.delete(deleteObject)
        do{
            try viewContext.save()
        }catch{
            print(error)
        }
        sortTasksByDate()
        queryExecution()
    }
    
    private func modifyIndexPath(indexPath: Int) -> Int {
        if sort_pointer == 0 || sort_pointer == SORT_NUMBER {
            return indexPath
        } else {
            var count = -1
            var tmp = 0
            while tmp < tasks.count {
                if tasks[tmp].type_id == sort_pointer {
                    count = count + 1
                    if count == indexPath {
                        return tmp
                    }
                }
                tmp = tmp + 1
            }
        }
        return 0
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
        for index in 0..<tasks.count {
            if tasks[index].type_id == sort_pointer {
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
