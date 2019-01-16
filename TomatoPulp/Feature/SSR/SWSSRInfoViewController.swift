//
//  SWSSRInfoViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/16.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material
import Charts

class SWSSRInfoViewController: UIViewController {

    var ssr: SWSSRUser = SWSSRUser()
    var ssrDict: [String : Any]?
    var ssrKeys: Array<String>?
    
    fileprivate var tableView: TableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        prepareTableView()
        prepareNavigationItem()
        configChartView()
        
        ssrDict = self.ssr.toJSON()
        if let keys = ssrDict?.keys {
            ssrKeys = Array(keys)
            ssrKeys?.sort(){
                $0 < $1
            }
        }
    }
}

fileprivate extension SWSSRInfoViewController {
    
    func prepareTableView() {
        tableView = TableView.init(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        view.layout(tableView).edges()
    }
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = ssr.user
        navigationItem.detailLabel.text = "配置文件"
    }
    
    func configChartView() {
        let chartView: PieChartView = PieChartView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 300))
        
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "SSR\n用户流量")
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        // 不显示title
//        chartView.drawEntryLabelsEnabled = false
//        chartView.legend.enabled = false
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        
        // entry label styling
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 10, weight: .light)
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        let entries = [PieChartDataEntry(value: Double(ssr.u + ssr.d),
                                         label: "已用"),
                       PieChartDataEntry(value: Double(ssr.transfer_enable - ssr.d - ssr.u),
                                         label: "剩余")]
        
        let set = PieChartDataSet(values: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.valueLinePart1OffsetPercentage = 0.8
        set.valueLinePart1Length = 0.2
        set.valueLinePart2Length = 0.4
        //set.xValuePosition = .outsideSlice
        set.yValuePosition = .outsideSlice
        set.colors = [Color.red.base, Color.green.base, Color.blue.base, Color.orange.base, Color.pink.base, Color.purple.base, Color.yellow.base, Color.red.accent1, Color.blue.darken4, Color.cyan.base]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 10, weight: .light))
        data.setValueTextColor(.black)
        chartView.data = data
        chartView.highlightValues(nil)
        
        tableView.tableHeaderView = chartView
        
    }
}


extension SWSSRInfoViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension SWSSRInfoViewController : UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = ssrKeys?.count {
            return count;
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        }
        
        if let key = ssrKeys?[indexPath.row] {
            cell?.textLabel?.text = key
            if let value = ssrDict?[key] {
                cell?.detailTextLabel?.text =  "\(String(describing: value))"
            }
        }
        
        cell?.textLabel?.font = Font.boldSystemFont(ofSize: 13)
        cell?.detailTextLabel?.font = Font.systemFont(ofSize: 11)
        cell?.detailTextLabel?.textColor = Color.blue.accent3
        
        return cell!
    }
}




