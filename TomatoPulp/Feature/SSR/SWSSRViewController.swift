//
//  SWSSRViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/14.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material
import Alamofire.Swift
import Charts

class SWSSRViewController: UIViewController {

    fileprivate var tableView: TableView!
    
    fileprivate var users: Array<SWSSRUser> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.titleLabel.text = "SSR"
        navigationItem.detailLabel.text = "用户配置"
        prepareTableView()
        setupSSRUserData()
        
    }
    
}

fileprivate extension SWSSRViewController {
    
    func prepareTableView() {
        tableView = TableView.init(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        view.layout(tableView).edges()
    }
    
    func setupSSRUserData() {
        self.showProgreeHUD("加载中...")
        AF.request("http://swing1993.xyz:8080/tomato/ssr/user", method: .get, parameters: nil, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders.init(["Content-Type" : "application/json"])).responseString(completionHandler: { response in
            self.hideHUD()
            //网络请求
            response.result.ifSuccess {
                if let httpResult = AppHttpResponse.deserialize(from: response.result.value) {
                    if httpResult.success {
                        self.users.removeAll()
                        let userJsonsString: String? = httpResult.result as? String
                        if let users: [SWSSRUser] = [SWSSRUser].deserialize(from: userJsonsString) as? [SWSSRUser] {
                            users.forEach({ (user) in
                                print(user.user)
                                if user.u + user.d > 0 {
                                    self.users.append(user)
                                }
                            })
                        }
                        self.users.sort(by: { (user1, user2) -> Bool in
                            return user1.u + user1.d > user2.u + user2.d
                        })
                        self.configChartView()
                        self.tableView.reloadData()
                    } else {
                        self.showTextHUD(httpResult.message!, dismissAfterDelay: 3)
                    }
                }
            }
            response.result.ifFailure({
                self.showTextHUD(response.error?.localizedDescription, dismissAfterDelay: 3)
            })
        })
    }
    
    func transformedValue(value: Int64) -> String {
        var result: Double = Double.init(value)
        var multiplyFactor :Int = 0;
        let tokens: Array<String> = ["Bytes", "KB", "MB", "GB","TB"]
        while result > 1024 {
            multiplyFactor = multiplyFactor + 1
            result = result/1024
        }
        return "\(String(format: "%.2f", result))\(tokens[multiplyFactor])"
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
        chartView.drawEntryLabelsEnabled = false
        
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
        
        let entries = self.users.map { (user) -> PieChartDataEntry in
            return PieChartDataEntry(value: Double(user.d + user.u),
                                     label: user.user,
                                     icon: Icon.cm.audio)
        }
        
        let set = PieChartDataSet(values: entries, label: "用户数据")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = [Color.red.base, Color.green.base, Color.blue.base, Color.orange.base, Color.pink.base, Color.purple.base, Color.yellow.base, Color.red.accent1, Color.blue.darken4, Color.cyan.base]

        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 10, weight: .light))
        data.setValueTextColor(.white)
        
        chartView.data = data
        chartView.highlightValues(nil)
        
        tableView.tableHeaderView = chartView
        
    }
}

extension SWSSRViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "域名：swing1993.xyz\nIP：35.241.122.72"
    }
}

extension SWSSRViewController : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        
        let user: SWSSRUser = self.users[indexPath.row]
        cell?.textLabel?.text = user.user
        cell?.textLabel?.font = Font.boldSystemFont(ofSize: 14)
        cell?.detailTextLabel?.text = "已用:\(self.transformedValue(value: user.u + user.d)) 剩余:\(self.transformedValue(value: user.transfer_enable - user.u - user.d)) 总共:\(self.transformedValue(value: user.transfer_enable))"
        cell?.detailTextLabel?.font = Font.systemFont(ofSize: 10)
        cell?.detailTextLabel?.textColor = Color.blue.accent3
        
        cell?.accessoryView = UIImageView.init(image: UIImage.init(named: "paper-plane-regular")?.resize(toWidth: 25)?.tint(with: user.enable ? Color.green.base : Color.red.base)) 
        
        return cell!
    }
    
}

