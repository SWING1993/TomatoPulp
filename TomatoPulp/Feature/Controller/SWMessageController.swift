//
//  SWMessageController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/3/25.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

// curl -d "access_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiIyIiwiZXhwIjoxNTU1MDcyMDQ0fQ.hPfK8X0PM3IjnOWliBrq4OALRhvVgR3NFv0ROnteYfc&title=消息标题&content=消息内容" http://118.24.216.163:8080/orange/message/send
class SWMessageController: QMUICommonViewController {

    var messages: Array<SWMessageModel> = Array()
    fileprivate var tableView: TableView!
    
    override func initSubviews() {
        super.initSubviews()
        prepareNavigationItem()
        prepareTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMessageData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.messages.count <= 0 {
            setupMessageData()
        }
    }
}

fileprivate extension SWMessageController {
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = "Message"
        navigationItem.detailLabel.text = "✉️✉️✉️"
    }
    
    func prepareTableView() {
        tableView = TableView.init(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.tableHeaderView = UIView()
        view.layout(tableView).edges()
    }
    
    func setupMessageData() {
        self.showProgreeHUD("加载中...")
        HttpUtils.default.request("/message", method: .get, params: ["pageNum":"1"]).response(success: { result in
            self.hideHUD()
            self.messages.removeAll()
            if let dict = result as? [String: Any] {
                if let list: Array<[String: Any]> = dict["list"] as? Array<[String: Any]> {
                    list.forEach({ (obj) in
                        if let message = SWMessageModel.deserialize(from: obj) {
                            self.messages.append(message)
                        }
                    })
                }
            }
            self.tableView.reloadData()
            self.hideEmptyView()
        }) { errorMsg in
            self.hideHUD()
            self.showTextHUD(errorMsg, dismissAfterDelay: 3)
        }
    }
}


extension SWMessageController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.showProgreeHUD("删除中...")
            let message = messages[indexPath.section]
            HttpUtils.default.request("/message", method: .delete, params: ["msgId":message.id]).response(success: { result in
                self.hideHUD()
                self.messages.remove(at: indexPath.section)
                tableView.reloadData()
            }) { errorMsg in
                self.hideHUD()
                self.showTextHUD(errorMsg, dismissAfterDelay: 3)
            }
        }
    }
}

extension SWMessageController : UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        }
        let message = messages[indexPath.section]
        cell?.textLabel?.text = message.title
        cell?.detailTextLabel?.text =  message.content
        cell?.textLabel?.font = Font.boldSystemFont(ofSize: 13)
        cell?.detailTextLabel?.font = Font.systemFont(ofSize: 11)
        cell?.detailTextLabel?.textColor = Color.blue.accent3
        cell?.detailTextLabel?.numberOfLines = 1;
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let message = messages[section]
        print("create:\(message.created)")
        return NSDate.init(timeIntervalSince1970: TimeInterval(message.created/1000)).stringByMessageDate()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
}
