//
//  SWASFSetConfigViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/17.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWASFSetConfigViewController: QMUICommonViewController {
    
    var set: Set<Int> = Set<Int>()
    var savedHandle: (Set<Int>) ->() = {_ in }
    
    var sectionTitle = ""
    
    
    fileprivate var saveButton: IconButton!
    fileprivate var addButton: IconButton!
    fileprivate var tableView: TableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareTableView()
        prepareNavigationItem()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

fileprivate extension SWASFSetConfigViewController {
    
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
        navigationItem.titleLabel.text = self.title
        navigationItem.rightViews = []
        saveButton = IconButton(image: Icon.cm.check)
        saveButton.addTarget(self, action: #selector(saveHandle), for: .touchUpInside)
        
        addButton = IconButton(image: Icon.cm.add)
        addButton.addTarget(self, action: #selector(addItmeHandle), for: .touchUpInside)
        navigationItem.rightViews = [saveButton, addButton]
    }
}

extension SWASFSetConfigViewController : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitle
//    }
    
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let value = Array(set)[indexPath.row]
        self.set.remove(value)
        tableView.reloadData()
    }

}

extension SWASFSetConfigViewController : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return set.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
            cell?.textLabel?.font = Font.boldSystemFont(ofSize: 13)
            cell?.detailTextLabel?.font = Font.systemFont(ofSize: 11)
            cell?.detailTextLabel?.textColor = Color.blue.accent3
        }
        
        let value = Array(set)[indexPath.row]
        cell?.textLabel?.text = "\(value)"
        return cell!
    }
}

fileprivate extension SWASFSetConfigViewController {
    
    @objc
    func saveHandle() -> Void {
        self.savedHandle(set)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func addItmeHandle() {
//        let dialogViewController = QMUIDialogTextFieldViewController()
//        dialogViewController.title = self.title
//        dialogViewController.addTextField(withTitle: nil) { (titleLabel, textField, separatorLayer) in
//            textField?.placeholder = "请输入";
//            textField?.maximumTextLength = 20;
//            textField?.keyboardType = .numberPad
//        }
//        dialogViewController.shouldManageTextFieldsReturnEventAutomatically = true
//        dialogViewController.addCancelButton(withText: "取消", block: nil)
//        dialogViewController.addSubmitButton(withText: "确定") { d in
//            let d = d as! QMUIDialogTextFieldViewController
//            let t = d.textFields.first
//            if let value = t?.text {
//                if let intValue = Int(value) {
//                    self.set.insert(intValue)
//                    self.tableView .reloadData()
//                }
//            }
//            d.hide()
//        }
//        dialogViewController.show()
    }
}
