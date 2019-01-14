//
//  SWASFUserSettingViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/14.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

import Material
import Alamofire.Swift

class SWASFBotSettingViewController: UIViewController {

    var asfBot: SWASFBot?
    fileprivate var asfBotDict: [String : Any]?
    fileprivate var asfBotKeys: Array<String>?

    fileprivate var tableView: TableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareTableView()
        prepareNavigationItem()
        
        if let asfBotConfig = self.asfBot {
            navigationItem.titleLabel.text = asfBotConfig.SteamLogin
            asfBotDict = asfBotConfig.toJSON()
            if let keys = asfBotDict?.keys {
                asfBotKeys = Array(keys)
                asfBotKeys?.sort(){
                    $0 < $1
                }
            }
        }
    }
}

fileprivate extension SWASFBotSettingViewController {
    
    func prepareTableView() {
        tableView = TableView.init(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        view.layout(tableView).edges()
    }
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = "ASFBot"
        navigationItem.detailLabel.text = "配置文件"
        //        settingButton.addTarget(self, action: #selector(handleToASFSetting), for: .touchUpInside)
        //        navigationItem.rightViews = [settingButton]
    }
}


extension SWASFBotSettingViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}

extension SWASFBotSettingViewController : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = asfBotKeys?.count {
            return count;
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        }
        
        if let key = asfBotKeys?[indexPath.row] {
            cell?.textLabel?.text = key
            if let value = asfBotDict?[key] {
                cell?.detailTextLabel?.text =  "\(String(describing: value))"
            }
        }
        cell?.textLabel?.font = Font.boldSystemFont(ofSize: 14)
        cell?.detailTextLabel?.font = Font.systemFont(ofSize: 11)
        cell?.detailTextLabel?.textColor = Color.blue.accent3
        
        return cell!
    }
    
}
