//
//  SWASFLogViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/18.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

import Material

class SWASFLogViewController: QMUICommonViewController {
    
    var logs: Array<String> = Array<String>()
    fileprivate var tableView: TableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        prepareTableView()
        prepareNavigationItem()
        setupASFLogData()
    }
}


fileprivate extension SWASFLogViewController {
    
    func prepareTableView() {
        tableView = TableView.init(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.init(red: 245, green: 245, blue: 245, alpha: 1)
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        view.layout(tableView).edges()
    }
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = "ArchiSteamFarm "
        navigationItem.detailLabel.text = "Log"
//        settingButton.addTarget(self, action: #selector(handleToASFSetting), for: .touchUpInside)
//        navigationItem.rightViews = [settingButton]
    }
    
    func setupASFLogData() {
        self.showProgreeHUD("加载中...")
        HttpUtils.default.request("/asf/logs").response(success: { result in
            self.hideHUD()
            if let x = result as? Array<String> {
                self.logs = x
            }
            if self.logs.count > 0 {
                self.tableView.reloadData()
                self.hideEmptyView()
            } else {
                self.showEmptyView(withText: "暂无日志", detailText: nil, buttonTitle: nil, buttonAction: nil)
            }
        }) { msg in
            self.hideHUD()
            self.showTextHUD(msg, dismissAfterDelay: 3)
            self.showEmptyView(withText: "暂无日志", detailText: nil, buttonTitle: nil, buttonAction: nil)

        }
    }
}

extension SWASFLogViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return logs[section]
    }
}

extension SWASFLogViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.logs.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }
        return cell!
    }
}
