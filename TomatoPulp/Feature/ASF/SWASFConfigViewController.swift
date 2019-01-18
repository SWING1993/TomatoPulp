//
//  SWASFSettingViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/14.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

import Material

class SWASFConfigViewController: UIViewController {
    
    var asf: SWASF = SWASF()
    var asfDict: [String : Any]?
    var asfKeys: Array<String>?

    fileprivate var tableView: TableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareTableView()
        prepareNavigationItem()
        
        asfDict = self.asf.toJSON()
        if let keys = asfDict?.keys {
            asfKeys = Array(keys)
            asfKeys?.sort(){
                $0 < $1
            }
        }
    }
}

fileprivate extension SWASFConfigViewController {
    
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
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = "ASF"
        navigationItem.detailLabel.text = "配置文件"
    }
}


extension SWASFConfigViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let key = asfKeys?[section] {
            return SWASF.printDesc(key: key)
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension SWASFConfigViewController : UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if let count = asfKeys?.count {
            return count;
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
            cell?.textLabel?.font = Font.boldSystemFont(ofSize: 13)
            cell?.detailTextLabel?.font = Font.systemFont(ofSize: 11)
            cell?.detailTextLabel?.textColor = Color.blue.accent3
        }
        
        if let key = asfKeys?[indexPath.section] {
            cell?.textLabel?.text = key
            if let value = asfDict?[key] {
                cell?.detailTextLabel?.text =  "\(String(describing: value))"
            }
        }        
        return cell!
    }
    
}
