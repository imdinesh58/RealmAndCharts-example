//
//  ViewController.swift
//  RealmAndCharts-example
//
//  Created by Sami Korpela on 8.10.2016.
//  Copyright © 2016 skipadu. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var barView: BarChartView!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    @IBAction func btnAddTapped(_ sender: AnyObject) {
        if let value = tfValue.text , value != "" {
            let visitorCount = VisitorCount()
            visitorCount.count = (NumberFormatter().number(from: value)?.intValue)!
            visitorCount.save()
            tfValue.text = ""
        }
        updateChartWithData()
    }
    
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May"]
    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0]
    let unitsBought = [10.0, 14.0, 60.0, 13.0, 2.0]
    let unitsBought2 = [10.0, 14.0, 60.0, 13.0, 2.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        barView.noDataText = "You need to provide data for the chart."
        barView.chartDescription?.text = "sales vs bought "
        
        barView.pinchZoomEnabled = false
        barView.doubleTapToZoomEnabled = false
        barView.scaleXEnabled = false
        barView.scaleYEnabled = false
        barView.isUserInteractionEnabled = false
        
        //legend
        let legend = barView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        let xaxis = barView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        
        barView.rightAxis.enabled = false
        //axisFormatDelegate = self
        setChart()
    }
    
    func setChart() {
        barView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        var dataEntries2: [BarChartDataEntry] = []
        for i in 0..<self.months.count {
            let dataEntry = BarChartDataEntry(x: Double(i) , y: self.unitsSold[i])
            dataEntries.append(dataEntry)
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.self.unitsBought[i])
            dataEntries1.append(dataEntry1)
            let dataEntry2 = BarChartDataEntry(x: Double(i) , y: self.self.unitsBought2[i])
            dataEntries2.append(dataEntry2)
            //stack barchart
            //let dataEntry = BarChartDataEntry(x: Double(i), yValues:  [self.unitsSold[i],self.unitsBought[i]], label: "groupChart")
            //dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Unit sold")
        let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: "Unit Bought")
        let chartDataSet2 = BarChartDataSet(values: dataEntries2, label: "Unit Bought 2")
        
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1,chartDataSet2]
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        //chartDataSet.colors = ChartColorTemplates.colorful()
        chartDataSet2.colors = [UIColor(red: 250/255, green: 126/255, blue: 34/255, alpha: 1)]
        //let chartData = BarChartData(dataSet: chartDataSet)
        
        let chartData = BarChartData(dataSets: dataSets)

        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = self.months.count
        let startYear = 0
        
        chartData.barWidth = barWidth;
        barView.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        barView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barView.notifyDataSetChanged()
        
        barView.data = chartData
        //background color
        barView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        //chart animation
        barView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    func PieChart() {
        let chart = PieChartView(frame: self.view.frame)
        // 2. generate chart data entries
        let track = ["Income", "Expense", "Wallet", "Bank"]
        let money = [650, 456.13, 78.67, 856.52]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Pie Chart")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        chart.data = data
        chart.noDataText = "No data available"
        // user interaction
        chart.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = "iOSCharts.io"
        chart.chartDescription = d
        chart.centerText = "Pie Chart"
        chart.holeRadiusPercent = 0.4 //0.2
        chart.transparentCircleColor = UIColor.clear
        self.view.addSubview(chart)
        
    }
    
    
    func updateChartWithData() {
        var dataEntries: [BarChartDataEntry] = []
        
        let visitorCounts = getVisitorCountsFromDatabase()
        
        for i in 0..<visitorCounts.count {
            let timeIntervalForDate: TimeInterval = visitorCounts[i].date.timeIntervalSince1970
            let dataEntry = BarChartDataEntry(x: Double(timeIntervalForDate), y: Double(visitorCounts[i].count))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Visitor count")
        let chartData = BarChartData(dataSet: chartDataSet)
        barView.data = chartData
        
        let xaxis = barView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
    }
    
    func getVisitorCountsFromDatabase() -> Results<VisitorCount> {
        do {
            let realm = try Realm()
            return realm.objects(VisitorCount.self)
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: axisFormatDelegate
extension ViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm.ss"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
    
}
