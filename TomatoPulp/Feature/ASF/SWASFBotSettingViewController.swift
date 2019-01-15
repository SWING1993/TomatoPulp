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

    var asfBot: SWASFBot = SWASFBot()
    var saved = {}
    
    fileprivate var asfBotDict: [String : Any]?
    fileprivate var asfBotKeys: Array<String>?
    fileprivate var saveButton: IconButton!
    fileprivate var tableView: TableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareTableView()
        prepareNavigationItem()
        
        navigationItem.titleLabel.text = self.asfBot.SteamLogin
        asfBotDict = self.asfBot.toJSON()
        if let keys = asfBotDict?.keys {
            asfBotKeys = Array(keys)
            asfBotKeys?.sort(){
                $0 < $1
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
        navigationItem.rightViews = [];
        saveButton = IconButton(image: Icon.cm.check)
        saveButton.addTarget(self, action: #selector(saveBot), for: .touchUpInside)
        navigationItem.rightViews = [saveButton]
        saveButton.isEnabled = false
    }
    
    @objc func saveBot() {
        self.showProgreeHUD("保存中...")
        let parameters: Parameters = ["filename": self.asfBot.FileName, "content": self.asfBot.toJSONString()!]
        AF.request("http://swing1993.xyz:8080/tomato/asf/save", method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders.init(["Content-Type" : "application/json"])).responseString(completionHandler: { response in
            self.hideHUD()
            response.result.ifSuccess {
                if let httpResult = AppHttpResponse.deserialize(from: response.result.value) {
                    if httpResult.success {
                        self.saved()
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.showTextHUD(httpResult.message!, dismissAfterDelay: 3)
                    }
                }
            }
            
            response.result.ifFailure {
                self.showTextHUD(response.error?.localizedDescription, dismissAfterDelay: 3)
            }
        })
    }
}


extension SWASFBotSettingViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    

    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let key = asfBotKeys?[section] {
            return SWASFBot.printDesc(key: key)
        }
        return ""
    }
    
}

extension SWASFBotSettingViewController : UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        if let count = asfBotKeys?.count {
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
        }
        cell?.accessoryView = nil
        
        if let key = asfBotKeys?[indexPath.section] {
            cell?.textLabel?.text = key
            if key == "Enabled" {
                let botSwitch: Switch = Switch(state: .off, style: .light, size: .small)
                botSwitch.isOn = self.asfBot.Enabled
                botSwitch.tag = indexPath.section
                botSwitch.delegate = self
                cell?.accessoryView = botSwitch
            } else {
                if let value = asfBotDict?[key] {
                    cell?.detailTextLabel?.text =  "\(String(describing: value))"
                }
            }
        }

        
        cell?.textLabel?.font = Font.boldSystemFont(ofSize: 14)
        cell?.detailTextLabel?.font = Font.systemFont(ofSize: 11)
        cell?.detailTextLabel?.textColor = Color.blue.accent3
        
        return cell!
    }
    
}

extension SWASFBotSettingViewController: SwitchDelegate {
    func switchDidChangeState(control: Switch, state: SwitchState) {
        print("Switch changed state to: ", .on == state ? "on" : "off")
        self.asfBot.Enabled = control.isOn
        self.saveButton?.isEnabled = true
    }
}
