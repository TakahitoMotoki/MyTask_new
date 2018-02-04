//
//  TasksCreateController.swift
//  MyTask
//
//  Created by 元木嵩人 on 2018/01/15.
//  Copyright © 2018年 元木嵩人. All rights reserved.
//

/* Todo
*/

import Foundation
import UIKit
import NCMB
import FontAwesomeKit
import SwiftyButton
import CoreData

class TasksCreateController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var title_textfield: UITextField!
    @IBOutlet weak var weight_textfield: UILabel!
    @IBOutlet weak var weight_bar: UISlider!
    @IBOutlet weak var type_picker: UIPickerView!
    @IBOutlet weak var title_font: UIImageView!
    @IBOutlet weak var weight_font: UIImageView!
    @IBOutlet weak var help_button: UIButton!
    @IBOutlet weak var tag_font: UIImageView!
    @IBOutlet weak var date_font: UIImageView!
    @IBOutlet weak var validate_date: UILabel!
    @IBOutlet weak var validate_date_button: UISwitch!
    @IBOutlet weak var date_picker: UIDatePicker!
    @IBOutlet weak var create_button: PressableButton!
    @IBOutlet weak var cancel_button: PressableButton!
    var type_list = ["仕事・バイト・インターン", "課題・宿題", "雑用", "自習", "その他", "したいこと"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weight_textfield.text = "50"
        
        create_button.colors = .init(button: UIColor(red: 0, green: 0, blue: 0.6, alpha: 0.52), shadow: UIColor(red: 0, green: 0, blue: 1.0, alpha: 1.0))
        create_button.shadowHeight = 2
        create_button.cornerRadius = 5
        cancel_button.colors = .init(button: UIColor(red: 0.6, green: 0, blue: 0, alpha: 0.52), shadow: UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0))
        cancel_button.shadowHeight = 2
        cancel_button.cornerRadius = 5
        
        // help_button
        let help = FAKFontAwesome.questionCircleIcon(withSize: 24.0)
        help?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
        let help_image = help?.image(with: CGSize(width: 24.0, height: 24.0))
        help_button.setBackgroundImage(help_image, for: .normal)
        
        // Font Image
        let title = FAKFontAwesome.diamondIcon(withSize: 30)
        title?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
        let title_image = title?.image(with: CGSize(width: 30.0, height: 30.0))
        let tag = FAKFontAwesome.hashtagIcon(withSize: 30)
        tag?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
        let tag_image = tag?.image(with: CGSize(width: 30.0, height: 30.0))
        let date = FAKFontAwesome.calendarIcon(withSize: 30.0)
        date?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
        let date_image = date?.image(with: CGSize(width: 30.0, height: 30.0))
        
        title_font.image = title_image
        tag_font.image = tag_image
        date_font.image = date_image
        
        // TextFieldのDelegate設定
        title_textfield.delegate = self

        // DatePickerの設定
        date_picker.setValue(false, forKey: "highlightsToday")
        date_picker.minimumDate = NSDate() as Date

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // !---   UIPicker Required Method Start   ---!
    // Returns number of component
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns number of data in component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return type_list.count
    }
    
    // Returns data
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return type_list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.text = type_list[row]
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.textColor = UIColor.white
        return pickerLabel
    }
    
    // Called when data is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    // !---   UIPicker Required Method End   ---!
    
    // Set Slider value to weight_textfield
    @IBAction func sliderAction(_ sender: Any) {
        weight_textfield.text = "\(Int(weight_bar.value))"
    }
    
    @IBAction func showHelp() {
        self.performSegue(withIdentifier: "goToHelp", sender: nil)
    }
    
    @IBAction func getUISwitchValue(_ sender: UISwitch) {
        validate_date.text = sender.isOn ? "する":"しない"
        if sender.isOn {
            date_picker.setValue(UIColor.white, forKey: "textColor")
        } else {
            date_picker.setValue(UIColor.black, forKey: "textColor")
        }
    }
    
    @IBAction func create() {
        // context(データベースを扱うのに必要)を定義。
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // taskにTask(データベースのエンティティです)型オブジェクトを代入します。
        let input = Input(context: context)
        
        // 先ほど定義したInput型データのプロパティに入力、選択したデータを代入します。
        input.title = title_textfield.text
        input.user_id = NCMBUser.current().objectId
        input.type_id = Int16(convertType(type_str: self.pickerView(type_picker, titleForRow: type_picker.selectedRow(inComponent: 0), forComponent: 0)!))
        input.weight = Int16(weight_bar.value)
        input.input_id = NSUUID().uuidString
        if validate_date_button.isOn {
            input.date = makeDateStringFromDatePicker()
            input.days = Int32(countDaysFromArray(array: convertDateStringToArray(date: makeDateStringFromDatePicker())))
            print(Int32(countDaysFromArray(array: convertDateStringToArray(date: makeDateStringFromDatePicker()))))
        } else {
            input.date = ""
            input.days = 10000000
        }

        // 上で作成したデータをデータベースに保存します。
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Convert Type(String) -> Type(Int)
    func convertType(type_str: String) -> Int {
        if(type_str == "仕事・バイト・インターン") {
            return 1
        } else if(type_str == "課題・宿題") {
            return 2
        } else if(type_str == "雑用") {
            return 3
        } else if (type_str == "自習") {
            return 4
        } else if (type_str == "その他") {
            return 5
        } else {
            return 6
        }
    }
    
    // This func is used to close Keyboard called by TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    private func makeDateStringFromDatePicker() -> String{
        let date = date_picker.date
        let calendar = Calendar(identifier: .gregorian)
        var day_string = ""
        if calendar.component(.day, from: date) < 10 {
            day_string = "0\(calendar.component(.day, from : date))"
        } else {
            day_string = "\(calendar.component(.day, from : date))"
        }
        var month_string = ""
        if calendar.component(.month, from: date) < 10 {
            month_string = "0\(calendar.component(.month, from: date))"
        } else {
            month_string = "\(calendar.component(.month, from: date))"
        }
        let year_string = "\(calendar.component(.year, from: date))"
        return year_string + "-" + month_string + "-" + day_string
    }
    
    private func countDaysFromArray(array: Dictionary<String, Int>) -> Int {
        var count: Int = 0
        let MONTH_DAYS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        let MONTH_DAYS_LEAP = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        let YEAR_DAYS = 365
        let YEAR_DAYS_LEAP = 366
        
        // Count Days
        count = array["d"]!
        
        //Count Months -> Days
        if array["y"]! % 4 != 0 {
            for i in 0..<(array["m"]! - 1) {
                count = count + MONTH_DAYS[i]
            }
        } else {
            if array["y"]! % 100 == 0 {
                for i in 0..<(array["m"]! - 1) {
                    count = count + MONTH_DAYS[i]
                }
            } else {
                for i in 0..<(array["m"]! - 1) {
                    count = count + MONTH_DAYS_LEAP[i]
                }
            }
        }
        
        // Count Years -> Days
        for i in 1...(array["y"]! - 1) {
            if i % 4 != 0 {
                count = count + YEAR_DAYS
            } else {
                if i % 100 == 0 {
                    count = count + YEAR_DAYS
                } else {
                    count = count + YEAR_DAYS_LEAP
                }
            }
        }
        return count
    }
    
    private func convertDateStringToArray(date: String) -> Dictionary<String, Int> {
        var donedate_array: Dictionary<String, Int> = ["y": 0, "m": 0, "d": 0]
        let sprit = date.components(separatedBy: "-")
        donedate_array["y"] = Int(sprit[0])
        donedate_array["m"] = Int(sprit[1])
        donedate_array["d"] = Int(sprit[2])
        return donedate_array
    }
}

