//
//  TasksCreateController.swift
//  MyTask
//
//  Created by 元木嵩人 on 2018/01/15.
//  Copyright © 2018年 元木嵩人. All rights reserved.
//

/* Todo
 1. user_idの取得
 2. user_idの保存
*/

import Foundation
import UIKit
import NCMB
import FontAwesomeKit
import SwiftyButton

class TasksCreateController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var title_textfield: UITextField!
    @IBOutlet weak var weight_textfield: UILabel!
    @IBOutlet weak var weight_bar: UISlider!
    @IBOutlet weak var type_picker: UIPickerView!
    @IBOutlet weak var title_font: UIImageView!
    @IBOutlet weak var weight_font: UIImageView!
    @IBOutlet weak var tag_font: UIImageView!
    @IBOutlet weak var create_button: PressableButton!
    @IBOutlet weak var cancel_button: PressableButton!
    var type_list = ["本", "課題", "雑用", "自習", "その他"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weight_textfield.text = "50"
        
        create_button.colors = .init(button: UIColor(red: 0, green: 0, blue: 1.0, alpha: 0.52), shadow: UIColor(red: 0, green: 0, blue: 1.0, alpha: 1.0))
        create_button.shadowHeight = 2
        create_button.cornerRadius = 5
        cancel_button.colors = .init(button: UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.52), shadow: UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0))
        cancel_button.shadowHeight = 2
        cancel_button.cornerRadius = 5
        
        // Font Image
        let title = FAKFontAwesome.diamondIcon(withSize: 30)
        let title_image = title?.image(with: CGSize(width: 30.0, height: 30.0))
        let tag = FAKFontAwesome.hashtagIcon(withSize: 30)
        let tag_image = tag?.image(with: CGSize(width: 30.0, height: 30.0))
        
        title_font.image = title_image
        tag_font.image = tag_image
        
        // TextFieldのDelegate設定
        title_textfield.delegate = self
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
    
    // Called when data is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    // !---   UIPicker Required Method End   ---!
    
    // Set Slider value to weight_textfield
    @IBAction func sliderAction(_ sender: Any) {
        weight_textfield.text = "\(Int(weight_bar.value))"
    }
    
    // !---   Not Completed Start   ---!
    @IBAction func create() {
        let object = NCMBObject(className: "Tasks")
        object?.setObject(title_textfield.text, forKey: "title")
        object?.setObject(title_textfield.text, forKey: "title")
        object?.setObject(Int(weight_bar.value), forKey: "weight")
        object?.setObject(convertType(type_str: self.pickerView(type_picker, titleForRow: type_picker.selectedRow(inComponent: 0), forComponent: 0)!), forKey: "type_id")
        object?.setObject(true, forKey: "isDone")
        object?.setObject(NCMBUser.current().objectId, forKey: "user_id")
        object?.saveInBackground( { (error) in
            if error != nil {
                // エラーが発生したときのコード
            } else {
                //成功したときのコード
                self.dismiss()
            }
        })
    }
    // !---   Not Completed End   ---!
    
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Convert Type(String) -> Type(Int)
    func convertType(type_str: String) -> Int {
        if(type_str == "本") {
            return 1
        } else if(type_str == "課題") {
            return 2
        } else if(type_str == "雑用") {
            return 3
        } else if (type_str == "自習") {
            return 4
        } else {
            return 5
        }
    }
    
    // This func is used to close Keyboard called by TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
}
