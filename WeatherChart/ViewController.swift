//
//  ViewController.swift
//  WeatherChart
//
//  Created by Вадим on 18/04/2019.
//  Copyright © 2019 Shamratov Vadim. All rights reserved.
//

import UIKit
import SWXMLHash
import SwiftChart

class ViewController: UIViewController, XMLParserDelegate, ChartDelegate {
    
    var hours: [Int] = []
    var hoursDouble: [Double] = []
    var avTemps: [Double] = []
    var avTempsFeels: [Double] = []
    var hour0 = 0
    var hour1 = 0
    var hour2 = 0
    var hour3 = 0
    var avTemp0 = 0.0
    var avTemp1 = 0.0
    var avTemp2 = 0.0
    var avTemp3 = 0.0
    var avTempFeels0 = 0.0
    var avTempFeels1 = 0.0
    var avTempFeels2 = 0.0
    var avTempFeels3 = 0.0
    
    @IBOutlet weak var chart: Chart!
    
    
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        return
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        return
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chart.delegate = self
        getXMLDataFromServer()
        delay(4){
            self.setChart()
        }
    }
    
    func getXMLDataFromServer(){
        
        let url = NSURL(string: "http://xml.meteoservice.ru/export/gismeteo/point/140.xml")
        
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
            if data == nil {
                print("dataTaskWithRequest error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            let xml = SWXMLHash.parse(data!)
            
            self.hour0 = (Int((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][0].element?.attribute(by: "hour")!.text)!)!)
            self.hour1 = (Int((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][1].element?.attribute(by: "hour")!.text)!)!)
            self.hour2 = (Int((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][2].element?.attribute(by: "hour")!.text)!)!)
            self.hour3 = (Int((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][3].element?.attribute(by: "hour")!.text)!)!)
            self.hours += [self.hour0, self.hour1, self.hour2, self.hour3]
            
            for i in 0...3 { self.hoursDouble.append(Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][i].element?.attribute(by: "hour")!.text)!)!)
            }
            self.hoursDouble.append(21.01)
            
            self.avTemp0 = (Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][0]["TEMPERATURE"][0].element?.attribute(by: "max")!.text)!)! + Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][0]["TEMPERATURE"][0].element?.attribute(by: "min")!.text)!)!) / 2
            self.avTemp1 = (Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][1]["TEMPERATURE"][0].element?.attribute(by: "max")!.text)!)! + Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][1]["TEMPERATURE"][0].element?.attribute(by: "min")!.text)!)!) / 2
            self.avTemp2 = (Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][2]["TEMPERATURE"][0].element?.attribute(by: "max")!.text)!)! + Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][2]["TEMPERATURE"][0].element?.attribute(by: "min")!.text)!)!) / 2
            self.avTemp3 = (Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][3]["TEMPERATURE"][0].element?.attribute(by: "max")!.text)!)! + Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][3]["TEMPERATURE"][0].element?.attribute(by: "min")!.text)!)!) / 2
            self.avTemps += [self.avTemp0, self.avTemp1, self.avTemp2, self.avTemp3]
            
            self.avTempFeels0 = (Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][0]["HEAT"][0].element?.attribute(by: "max")!.text)!)! + Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][0]["HEAT"][0].element?.attribute(by: "min")!.text)!)!) / 2
            self.avTempFeels1 = (Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][1]["HEAT"][0].element?.attribute(by: "max")!.text)!)! + Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][1]["HEAT"][0].element?.attribute(by: "min")!.text)!)!) / 2
            self.avTempFeels2 = (Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][2]["HEAT"][0].element?.attribute(by: "max")!.text)!)! + Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][2]["HEAT"][0].element?.attribute(by: "min")!.text)!)!) / 2
            self.avTempFeels3 = (Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][3]["HEAT"][0].element?.attribute(by: "max")!.text)!)! + Double((xml["MMWEATHER"]["REPORT"]["TOWN"]["FORECAST"][3]["HEAT"][0].element?.attribute(by: "min")!.text)!)!) / 2
            self.avTempsFeels += [self.avTempFeels0, self.avTempFeels1, self.avTempFeels2, self.avTempFeels3]
            
            print(self.avTempsFeels)
            print(self.avTemps)
            print(self.hours)
        }
        task.resume()
    }
    
    func setChart() {
        let data0 = [(x: hour0, y: avTemp0),
                     (x: hour1, y: avTemp1),
                     (x: hour2, y: avTemp2),
                     (x: hour3, y: avTemp3),]
        let data1 = [(x: hour0, y: avTempFeels0),
                     (x: hour1, y: avTempFeels1),
                     (x: hour2, y: avTempFeels2),
                     (x: hour3, y: avTempFeels3),]
        
        chart.yLabels = ([avTemps.max()] + [avTempsFeels.min()] + [0.0] as! [Double])
        chart.xLabels = hoursDouble
        chart.minY = avTempsFeels.min()! - 1
        chart.maxY = avTemps.max()! + 1
        chart.yLabelsFormatter = { String(Int(round($1))) + "°С" }
        chart.xLabelsFormatter = { String(Int(round($1))) + ":00" }
        let series0 = ChartSeries(data: data0)
        let series1 = ChartSeries(data: data1)
        series0.colors = (above: ChartColors.redColor(), below: ChartColors.redColor(), zeroLevel: -1)
        series1.colors = (above: ChartColors.greenColor(), below: ChartColors.greenColor(), zeroLevel: -1)
        chart.add(series0)
        chart.add(series1)
    }
    
    func delay(_ delay: Int, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            closure()
        }
    }
    
    @IBAction func reloadButton(_ sender: UIButton) {
        getXMLDataFromServer()
        delay(4){
            self.setChart()
        }
    }
}




