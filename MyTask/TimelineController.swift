//
//  TimelineController.swift
//  MyTask
//
//  Created by 元木嵩人 on 2018/01/27.
//  Copyright © 2018年 元木嵩人. All rights reserved.
//

import Foundation
import UIKit
import NCMB

class TimelineController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var timeline: UITableView!
    var outputs: [NCMBObject]!
    var outputs_flag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        queryExecution()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // This func determines the number of cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // This func gives values to post cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "post") as! OutputCellTableViewCell
        if outputs_flag {
            cell.userName.text = "Takahito Motoki"
            cell.titleLabel.text = outputs[indexPath.row].object(forKey: "title") as! String
            cell.contentTextView.text = validateNewLine(text: outputs[indexPath.row].object(forKey: "text") as! String)
            return cell
        } else {
            return cell
        }
    }
    
    func queryExecution() {
        let query = NCMBQuery(className: "Outputs")
        query?.findObjectsInBackground({ (results, error) in
            if (error != nil) {
                // Failed
            } else {
                // Success
                self.setOutputs(results: results as! [NCMBObject])
            }
        })
    }
    
    private func setOutputs(results: [NCMBObject]) {
        outputs = results
        outputs_flag = true
        timeline.reloadData()
    }
    
    // !===   Not Completed   ===!
    private func findUserName(id: String) -> String {
        return ""
    }
    
    private func validateNewLine(text: String) -> String {
        var validatedText = text
        validatedText = validatedText.replacingOccurrences(of:"\\n", with:"\n")
        return validatedText
    }
}
