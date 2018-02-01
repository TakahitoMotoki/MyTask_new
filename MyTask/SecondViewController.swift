//
//  SecondViewController.swift
//  MyTask
//
//  Created by 元木嵩人 on 2018/01/11.
//  Copyright © 2018年 元木嵩人. All rights reserved.
//

/* Todo
 1. 1日ごとの成果をグラフ化(見える化) => 棒グラフにする
 => Library の Chartsを使おう
*/

import UIKit
import NCMB
import Charts

class SecondViewController: UIViewController {
    // !---   Not Completed Start   ---!
    var level = 100
    var experience = 10000
    var tasks: [NCMBObject]!
    // !---   Not Completed End   ---!
    @IBOutlet weak var level_container: UILabel!
    @IBOutlet weak var experience_bar: UIProgressView!
    @IBOutlet weak var graph_view: UIView!
    var days_results: Dictionary<String, Int> = ["d0": 0, "d1": 0, "d2": 0, "d3": 0, "d4": 0, "d5": 0, "d6": 0, "d7": 0, "d8": 0, "d9": 0]
    var weeks_results: Dictionary<String, Int> = ["w0": 0, "w1": 0, "w2": 0, "w3": 0, "w4": 0, "w5": 0, "w6": 0, "w7": 0, "w8": 0, "w9": 0]
    var months_results: Dictionary<String, Int> = ["m0": 0, "m1": 0, "m2": 0, "m3": 0, "m4": 0, "m5": 0, "m6": 0, "m7": 0, "m8": 0, "m9": 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        level_container.text = "Level. \(level)"
        experience_bar.progress = Float(experience) / 20000.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // 値の初期化
        days_results = ["d0": 0, "d1": 0, "d2": 0, "d3": 0, "d4": 0, "d5": 0, "d6": 0, "d7": 0, "d8": 0, "d9": 0]
        weeks_results = ["w0": 0, "w1": 0, "w2": 0, "w3": 0, "w4": 0, "w5": 0, "w6": 0, "w7": 0, "w8": 0, "w9": 0]
        months_results = ["m0": 0, "m1": 0, "m2": 0, "m3": 0, "m4": 0, "m5": 0, "m6": 0, "m7": 0, "m8": 0, "m9": 0]
        
        let query = NCMBQuery(className: "Tasks")
        query?.whereKey("isDone", equalTo: false)
        // query?.whereKey("user_id", equalTo: )
        query?.findObjectsInBackground({ (results, error) in
            if (error != nil) {
                // 検索が失敗した時の処理
                
            } else {
                // 検索が成功した時の処理
                self.setTasks(results: results as! [NCMBObject])
                self.calcEXP()
                self.drawCharts()
                print(self.days_results)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTasks(results: [NCMBObject]!) {
        tasks = results
    }
    
    func calcEXP() {
        for tasks_number in 0...tasks.count - 1 {
            let interval: Int!
            let weight: Int!
            interval = calcInterval(date: tasks[tasks_number].object(forKey: "doneDate") as! String)
            weight = tasks[tasks_number].object(forKey: "weight") as! Int
            addEXPToMonth(interval: interval, weight: weight)
            addEXPToWeek(interval: interval, weight: weight)
            addEXPToDay(interval: interval, weight: weight)
        }
    }
    
    // !---   Not Completed Start   ---!
    // !---   Caution: Task's column "doneDate" should be String and format is "yyyy-mm-dd"   ---!
    func calcInterval(date: String) -> Int {
        let today_array = convertTodayToArray()
        let today_count: Int = countDaysFromArray(array: today_array)
        let donedate_array = convertDoneDateToArray(date: date)
        let donedate_count = countDaysFromArray(array: donedate_array)
        // let interval = today_count - donedate_count
        let interval = today_count - donedate_count 
        return interval
    }
    // !---   Not Completed End   ---!
    
    func addEXPToMonth(interval: Int, weight: Int) {
        let tmp = Int(floor(Double(interval) / 30.0))
        if tmp < 10 && tmp >= 0{
            months_results["m\(tmp)"] = months_results["m\(tmp)"]! + weight
        }
    }
    
    func addEXPToWeek(interval: Int, weight: Int) {
        let tmp = Int(floor(Double(interval) / 7.0))
        if tmp < 10 && tmp >= 0 {
            weeks_results["w\(tmp)"] = weeks_results["w\(tmp)"]! + weight
        }
    }
    
    func addEXPToDay(interval: Int, weight: Int) {
        let tmp = interval
        if tmp < 10 && tmp >= 0{
            days_results["d\(tmp)"] = days_results["d\(tmp)"]! + weight
        }
    }
    
    func convertTodayToArray() -> Dictionary<String, Int> {
        var today_array: Dictionary<String, Int> = ["y": 0, "m": 0, "d": 0]
        let now = Date()
        let calendar = Calendar.current
        today_array["y"] = calendar.component(.year, from: now)
        today_array["m"] = calendar.component(.month, from: now)
        today_array["d"] = calendar.component(.day, from: now)
        return today_array
    }

    // !---   Not Completed Start   ---!
    func convertDoneDateToArray(date: String) -> Dictionary<String, Int> {
        var donedate_array: Dictionary<String, Int> = ["y": 0, "m": 0, "d": 0]
        let sprit = date.components(separatedBy: "-")
        donedate_array["y"] = Int(sprit[0])
        donedate_array["m"] = Int(sprit[1])
        donedate_array["d"] = Int(sprit[2])
        return donedate_array
    }
    // !---   Not Completed End   ---!

    // !---   Not Completed Start   ---!
    func countDaysFromArray(array: Dictionary<String, Int>) -> Int {
        var count: Int = 0
        let MONTH_DAYS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        let MONTH_DAYS_LEAP = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        let YEAR_DAYS = 365
        let YEAR_DAYS_LEAP = 366
        
        // Count Days
        count = array["d"]!
        
        //Count Months -> Days
        if array["m"]! % 4 != 0 {
            for i in 0...array["m"]! - 1 {
                count = count + MONTH_DAYS[i]
            }
        } else {
            if array["m"]! % 100 == 0 {
                for i in 0...array["m"]! - 1 {
                    count = count + MONTH_DAYS[i]
                }
            } else {
                for i in 0...array["m"]! - 1 {
                    count = count + MONTH_DAYS_LEAP[i]
                }
            }
        }
        
        // Count Years -> Days
        for i in 1...array["y"]! - 1 {
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
    // !---   Not Completed End   ---!
    
    // This func draws Charts
    func drawCharts() {
        var rect = graph_view.bounds
        rect.origin.y += 0
        rect.size.height += 0
        let chartView = LineChartView(frame: rect)
        let entries = [
            BarChartDataEntry(x: 0, y: Double(days_results["d0"]!)),
            BarChartDataEntry(x: 1, y: Double(days_results["d1"]!)),
            BarChartDataEntry(x: 2, y: Double(days_results["d2"]!)),
            BarChartDataEntry(x: 3, y: Double(days_results["d3"]!)),
            BarChartDataEntry(x: 4, y: Double(days_results["d4"]!)),
            BarChartDataEntry(x: 5, y: Double(days_results["d5"]!)),
            BarChartDataEntry(x: 6, y: Double(days_results["d6"]!)),
            BarChartDataEntry(x: 7, y: Double(days_results["d7"]!)),
            BarChartDataEntry(x: 8, y: Double(days_results["d8"]!)),
            BarChartDataEntry(x: 9, y: Double(days_results["d9"]!))
        ]
        let set = LineChartDataSet(values: entries, label: "Data")
        chartView.data = LineChartData(dataSet: set)
        graph_view.addSubview(chartView)
    }
}

