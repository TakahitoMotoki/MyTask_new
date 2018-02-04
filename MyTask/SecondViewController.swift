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
    @IBOutlet weak var horizontalBarChartView: HorizontalBarChartView! {
        didSet {
            //x軸設定
            horizontalBarChartView.xAxis.labelPosition = .bottom //x軸ラベル下側に表示
            horizontalBarChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 11) //x軸のフォントの大きさ
            horizontalBarChartView.xAxis.labelCount = Int(10) //x軸に表示するラベルの数
            horizontalBarChartView.xAxis.labelTextColor = UIColor.white //x軸ラベルの色
            horizontalBarChartView.xAxis.axisLineColor = UIColor.white //x軸の色
            horizontalBarChartView.xAxis.axisLineWidth = CGFloat(1) //x軸の太さ
            horizontalBarChartView.xAxis.drawGridLinesEnabled = false //x軸のグリッド表示(今回は表示しない)
            
            //y軸設定
            horizontalBarChartView.rightAxis.enabled = false //右軸(値)の表示
            horizontalBarChartView.leftAxis.enabled = true //左軸（値)の表示
            horizontalBarChartView.leftAxis.axisMinimum = 0 //y左軸最小値
            horizontalBarChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 11) //y左軸のフォントの大きさ
            horizontalBarChartView.leftAxis.labelTextColor = UIColor.white //y軸ラベルの色
            horizontalBarChartView.leftAxis.axisLineColor = UIColor.white //y左軸の色(今回はy軸消すためにBGと同じ色にしている)
            horizontalBarChartView.rightAxis.axisLineColor = UIColor.white //y左軸の色(今回はy軸消すためにBGと同じ色にしている)
            horizontalBarChartView.leftAxis.drawAxisLineEnabled = true //y左軸の表示(今回は表示しない)
            horizontalBarChartView.rightAxis.drawAxisLineEnabled = true
            horizontalBarChartView.leftAxis.labelCount = Int(4) //y軸ラベルの表示数
            horizontalBarChartView.leftAxis.drawGridLinesEnabled = true //y軸のグリッド表示(今回は表示する)
            horizontalBarChartView.leftAxis.gridColor = UIColor.gray //y軸グリッドの色
            
            //その他UI設定
            horizontalBarChartView.noDataFont = UIFont.systemFont(ofSize: 30) //Noデータ時の表示フォント
            horizontalBarChartView.noDataTextColor = UIColor.white //Noデータ時の文字色
            horizontalBarChartView.noDataText = "Keep Waiting" //Noデータ時に表示する文字
            horizontalBarChartView.chartDescription?.text = nil //Description(今回はなし)
            horizontalBarChartView.animate(xAxisDuration: 1.2, yAxisDuration: 1.5, easingOption: .easeInOutElastic)//グラフのアニメーション(秒数で設定)
        }
    }
    @IBOutlet weak var segmentedController: UISegmentedControl!
    var days_results: Dictionary<String, Int> = ["0": 0, "1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0]
    var weeks_results: Dictionary<String, Int> = ["0": 0, "1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0]
    var months_results: Dictionary<String, Int> = ["0": 0, "1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        level_container.text = "Level. \(level)"
        experience_bar.progress = Float(experience) / 20000.0
        
        horizontalBarChartView.pinchZoomEnabled = false
        horizontalBarChartView.drawBarShadowEnabled = false
        horizontalBarChartView.drawBordersEnabled = true
        horizontalBarChartView.scaleXEnabled = false
        horizontalBarChartView.scaleYEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // 値の初期化
        days_results = ["0": 0, "1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0]
        weeks_results = ["0": 0, "1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0]
        months_results = ["0": 0, "1": 0, "2": 0, "3": 0, "4": 0, "5": 0, "6": 0, "7": 0, "8": 0, "9": 0]
        
        let query = NCMBQuery(className: "Tasks")
        query?.whereKey("isDone", equalTo: false)
        query?.whereKey("user_id", equalTo: NCMBUser.current().objectId!)
        query?.findObjectsInBackground({ (results, error) in
            if (error != nil) {
                // 検索が失敗した時の処理
                
            } else {
                // 検索が成功した時の処理
                self.setTasks(results: results as! [NCMBObject])
                self.calcEXP()
                self.drawCharts(results: self.days_results)
            }
        })
        drawCharts(results: days_results)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeChart(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Days")
            drawCharts(results: days_results)
        case 1:
            print("Weeks")
            drawCharts(results: weeks_results)
        case 2:
            print("Months")
            drawCharts(results: months_results)
        default:
            print("Nothing")
        }
    }
    
    // This func draws Charts
    func drawCharts(results: Dictionary<String, Int>) {
        let entries = [
            BarChartDataEntry(x: 0, y: Double(results["9"]!)),
            BarChartDataEntry(x: 1, y: Double(results["8"]!)),
            BarChartDataEntry(x: 2, y: Double(results["7"]!)),
            BarChartDataEntry(x: 3, y: Double(results["6"]!)),
            BarChartDataEntry(x: 4, y: Double(results["5"]!)),
            BarChartDataEntry(x: 5, y: Double(results["4"]!)),
            BarChartDataEntry(x: 6, y: Double(results["3"]!)),
            BarChartDataEntry(x: 7, y: Double(results["2"]!)),
            BarChartDataEntry(x: 8, y: Double(results["1"]!)),
            BarChartDataEntry(x: 9, y: Double(results["0"]!))
        ]
        let set = BarChartDataSet(values: entries, label: "経験値")
        horizontalBarChartView.data = BarChartData(dataSet: set)
        // アニメーション設定
        horizontalBarChartView.animate(xAxisDuration: 1.2, yAxisDuration: 1.2)
        // X軸設定
        let xaxis = XAxis()
        if segmentedController.selectedSegmentIndex == 0 {
            xaxis.valueFormatter = DayBarChartFormatter()
        } else if segmentedController.selectedSegmentIndex == 1 {
            xaxis.valueFormatter = WeekBarChartFormatter()
        } else {
            xaxis.valueFormatter = MonthBarChartFormatter()
        }
        horizontalBarChartView.xAxis.valueFormatter = xaxis.valueFormatter
        horizontalBarChartView.xAxis.labelPosition = .bottom
        horizontalBarChartView.xAxis.labelTextColor = UIColor.white
    }
    
    public class DayBarChartFormatter: NSObject, IAxisValueFormatter{
        // x軸のラベル
        var xLabel: [String]! = ["9日前", "8日前", "7日前", "6日前", "5日前", "4日前", "3日前", "2日前", "昨日", "今日"]
        
        // デリゲート。TableViewのcellForRowAtで、indexで渡されたセルをレンダリングするのに似てる。
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // 0 -> Jan, 1 -> Feb...
            return xLabel[Int(value)]
        }
    }
    
    public class WeekBarChartFormatter: NSObject, IAxisValueFormatter{
        // x軸のラベル
        var xLabel: [String]! = ["9週前", "8週前", "7週前", "6週前", "5週前", "4週前", "3週前", "2週前", "先週", "今週"]
        
        // デリゲート。TableViewのcellForRowAtで、indexで渡されたセルをレンダリングするのに似てる。
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // 0 -> Jan, 1 -> Feb...
            return xLabel[Int(value)]
        }
    }
    
    public class MonthBarChartFormatter: NSObject, IAxisValueFormatter{
        // x軸のラベル
        var xLabel: [String]! = ["9ヶ月前", "8ヶ月前", "7ヶ月前", "6ヶ月前", "5ヶ月前", "4ヶ月前", "3ヶ月前", "2ヶ月前", "先月", "今日"]
        
        // デリゲート。TableViewのcellForRowAtで、indexで渡されたセルをレンダリングするのに似てる。
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // 0 -> Jan, 1 -> Feb...
            return xLabel[Int(value)]
        }
    }
    
    func setTasks(results: [NCMBObject]!) {
        tasks = results
    }
    
    func calcEXP() {
        for tasks_number in 0..<tasks.count {
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
        let today_count = countDaysFromArray(array: today_array)
        let donedate_array = convertDoneDateToArray(date: date)
        let donedate_count = countDaysFromArray(array: donedate_array)
        let interval = today_count - donedate_count
        return interval
    }
    // !---   Not Completed End   ---!
    
    func addEXPToMonth(interval: Int, weight: Int) {
        let tmp = Int(floor(Double(interval) / 30.0))
        if tmp < 10 && tmp >= 0{
            months_results["\(tmp)"] = months_results["\(tmp)"]! + weight
        }
    }
    
    func addEXPToWeek(interval: Int, weight: Int) {
        let tmp = Int(floor(Double(interval) / 7.0))
        if tmp < 10 && tmp >= 0 {
            weeks_results["\(tmp)"] = weeks_results["\(tmp)"]! + weight
        }
    }
    
    func addEXPToDay(interval: Int, weight: Int) {
        let tmp = interval
        if tmp < 10 && tmp >= 0{
            days_results["\(tmp)"] = days_results["\(tmp)"]! + weight
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
}

