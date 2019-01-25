//
//  SWSSRViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/14.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material
import Charts
import ReactiveSwift
import ReactiveCocoa

class SWSSRViewController: QMUICommonViewController {

    fileprivate var tableView: TableView!
    
    fileprivate var users: Array<SWSSRUser> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.showEmptyView(withText: "SSRUser为空", detailText: "请检查网络", buttonTitle: nil, buttonAction: nil)
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
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        view.layout(tableView).edges()
    }
    
    func setupSSRUserData() {
        self.showProgreeHUD("加载中...")
        HttpUtils.default.request("/ssr/user", method: .get, params: nil).response(success: { result in
            self.hideHUD()
            self.users.removeAll()
            let userJsonsString: String? = result as? String
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
            self.hideEmptyView()
        }) { errorMsg in
            self.hideHUD()
            self.showTextHUD(errorMsg, dismissAfterDelay: 3)
        }
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
        
        let total = self.users.reduce(0) { (result, user) -> Int64 in
            return result + user.u + user.d
        }
        
        let centerText = NSMutableAttributedString(string: "SSR\n用户总流量\n\(HttpUtils.transformedValue(value: total))")
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
                                     label: user.user)
        }
        
        let set = PieChartDataSet(values: entries, label: "")
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
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "域名：swing1993.xyz\nIP：35.241.122.72"
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user: SWSSRUser = self.users[indexPath.row]
        let controller: SWSSRInfoViewController = SWSSRInfoViewController()
        controller.ssr = user
        self.navigationController?.pushViewController(controller, animated: true)

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
        cell?.detailTextLabel?.text = "已用:\(HttpUtils.transformedValue(value: user.u + user.d)) 剩余:\(HttpUtils.transformedValue(value: user.transfer_enable - user.u - user.d)) 总共:\(HttpUtils.transformedValue(value: user.transfer_enable))"
        cell?.detailTextLabel?.font = Font.systemFont(ofSize: 10)
        cell?.detailTextLabel?.textColor = Color.blue.accent3
        
        cell?.accessoryView = UIImageView.init(image: UIImage.init(named: "paper-plane-regular")?.resize(toWidth: 25)?.tint(with: user.enable ? Color.green.base : Color.red.base)) 
        
        return cell!
    }
    
}

