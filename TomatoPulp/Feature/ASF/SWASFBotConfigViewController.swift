//
//  SWASFUserSettingViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/14.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

import Material
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError
import Alamofire

class SWASFBotConfigViewController: UIViewController {

    var saved = {}
    var asfBot: SWASFBot = SWASFBot()
    fileprivate var asfBotDict: [String : Any]?
    fileprivate var asfBotKeys: Array<String>?
    fileprivate var saveButton: IconButton!
    fileprivate var tableView: TableView!
    
    fileprivate var boolArray: Array<String> = Array<String>()
    fileprivate var stringArray: Array<String> = Array<String>()
    fileprivate var intArray: Array<String> = Array<String>()
    fileprivate var setArray: Array<String> = Array<String>()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareTableView()
        prepareNavigationItem()
        
        let hMirror: Mirror = Mirror(reflecting: asfBot)
        for case let (key, value) in hMirror.children {
            let sMirror = Mirror(reflecting: value)
            let subjectType = String(describing: sMirror.subjectType)
            print("\(key!)类型：\(subjectType)")
            if let element = key {
                if subjectType == "Bool" {
                    boolArray.append(element)
                } else if subjectType == "String" {
                    stringArray.append(element)
                } else if String(describing: sMirror.subjectType).hasPrefix("Int") {
                    intArray.append(element)
                } else if String(describing: sMirror.subjectType) == "Set<Int>" {
                    setArray.append(element)
                }
            }
        }
        
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

fileprivate extension SWASFBotConfigViewController {
    
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
        navigationItem.titleLabel.text = "ASFBot"
        navigationItem.detailLabel.text = "配置文件"
        navigationItem.rightViews = [];
        saveButton = IconButton(image: Icon.cm.check)
        saveButton.addTarget(self, action: #selector(saveBot), for: .touchUpInside)
        navigationItem.rightViews = [saveButton]
    }
    
    @objc func saveBot() {
        if let x: SWASFBot = SWASFBot.deserialize(from: self.asfBotDict) {
            self.showProgreeHUD("保存中...")
            let parameters: Parameters = ["filename": self.asfBot.FileName, "content": x.toJSONString()!]
            HttpUtils.default.request("/asf/save", method: .post, params: parameters).response(success: { _ in
                self.hideHUD()
                self.saved()
                self.navigationController?.popViewController(animated: true)
            }) { errorMsg in
                self.hideHUD()
                self.showTextHUD(errorMsg, dismissAfterDelay: 3)
            }
        }
    }
}


extension SWASFBotConfigViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let key = asfBotKeys?[section] {
            return SWASFBot.printDesc(key: key)
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let key = asfBotKeys?[indexPath.section] {
            let hMirror: Mirror = Mirror(reflecting: asfBot)
            for case let (label, value) in hMirror.children {
                if label == key {
                    let sMirror = Mirror(reflecting: value)
                    if String(describing: sMirror.subjectType) == "String" {
                        self.xxString(key, value: value as! String)
                    }
                    if String(describing: sMirror.subjectType).hasPrefix("Int") {
                        self.xxInt(key)
                    }
                    if String(describing: sMirror.subjectType) == "Set<Int>" {
                        self.xxSet(key, value: value as! Set<Int>)
                    }
                }
            }
        }
    }
}

extension SWASFBotConfigViewController : UITableViewDataSource {
    
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
            cell?.textLabel?.font = Font.boldSystemFont(ofSize: 13)
            cell?.detailTextLabel?.font = Font.systemFont(ofSize: 11)
            cell?.detailTextLabel?.textColor = Color.blue.accent3
        }
        
        cell?.textLabel?.text = ""
        cell?.detailTextLabel?.text = ""
        cell?.accessoryView = nil
        
        if let key = asfBotKeys?[indexPath.section] {
            cell?.textLabel?.text = key
            let value = asfBotDict?[key]
            
            if boolArray.contains(key) {
                let botSwitch: Switch = Switch(state: .off, style: .light, size: .small)
                botSwitch.isOn = value as! Bool
                botSwitch.tag = indexPath.section
                botSwitch.delegate = self
                cell?.accessoryView = botSwitch
            } else {
                cell?.detailTextLabel?.text = String(describing: value!)
            }
        }
        return cell!
    }
}

extension SWASFBotConfigViewController: SwitchDelegate {
    func switchDidChangeState(control: Switch, state: SwitchState) {
        print("Switch changed state to: ", .on == state ? "on" : "off")
        let key: String = (asfBotKeys?[control.tag])!
        asfBotDict?[key] = control.isOn
    }
}


extension SWASFBotConfigViewController {
    
    func xxInt(_ key: String) {
//        let dialogViewController = QMUIDialogTextFieldViewController()
//        dialogViewController.title = key
//        dialogViewController.addTextField(withTitle: nil) { (titleLabel, textField, separatorLayer) in
//            textField?.placeholder = "请输入";
//            textField?.maximumTextLength = 70;
//            textField?.keyboardType = .numberPad
//        }
//        dialogViewController.shouldManageTextFieldsReturnEventAutomatically = true
//        dialogViewController.addCancelButton(withText: "取消", block: nil)
//        dialogViewController.addSubmitButton(withText: "确定") { d in
//            let d = d as! QMUIDialogTextFieldViewController
//            let t = d.textFields.first
//            if let tValue = t?.text {
//                if let intValue = Int(tValue) {
//                    self.asfBotDict?[key] = intValue
//                    self.tableView.reloadData()
//                }
//            }
//            d.hide()
//        }
//        dialogViewController.show()
    }
    
    func xxString(_ key: String, value: String) {
//        let dialogViewController = QMUIDialogTextFieldViewController()
//        dialogViewController.title = key
//        dialogViewController.addTextField(withTitle: nil) { (titleLabel, textField, separatorLayer) in
//            textField?.placeholder = "请输入";
//            textField?.text = value
//            textField?.maximumTextLength = 70;
//        }
//        dialogViewController.shouldManageTextFieldsReturnEventAutomatically = true
//        dialogViewController.shouldEnableSubmitButtonBlock = { _ in
//            return true
//        }
//
//        dialogViewController.addCancelButton(withText: "取消", block: nil)
//        dialogViewController.addSubmitButton(withText: "确定") { d in
//            let d = d as! QMUIDialogTextFieldViewController
//            let t = d.textFields.first
//            if let tValue = t?.text {
//                self.asfBotDict?[key] = tValue
//            } else {
//                self.asfBotDict?[key] = ""
//            }
//            self.tableView.reloadData()
//            d.hide()
//        }
//        dialogViewController.show()
    }
    
    func xxSet(_ key: String, value: Set<Int>) {
        let controller = SWASFSetConfigViewController()
        controller.title = key
        controller.sectionTitle = SWASFBot.printDesc(key: key)
        controller.set = value
        controller.savedHandle = { set in
            print(set)
            self.asfBotDict?[key] = set
            self.tableView.reloadData()
        }
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
