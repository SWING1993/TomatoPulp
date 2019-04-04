//
//  SWMessageController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/3/25.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

// curl -d "messageToken=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiIyIiwiZXhwIjoxNTU1MDcyMDQ0fQ.hPfK8X0PM3IjnOWliBrq4OALRhvVgR3NFv0ROnteYfc&title=消息标题&content=消息内容" http://118.24.216.163:8080/orange/message/send

class SWMessageController: QMUICommonViewController {

    var messages: Array<SWMessageModel> = Array()
    var pageNum: Int = 1
    fileprivate var tableView: TableView!
    
    override func didInitialize() {
        super.didInitialize()
    }
    
    override func initSubviews() {
        super.initSubviews()
        prepareNavigationItem()
        prepareTableView()
        self.showEmptyViewWithLoading()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMessageData(showHUD: false);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        tableView.mj_header = SWRefreshHeader()
        tableView.mj_header.refreshingBlock = {
            self.pageNum = 1;
            self.setupMessageData(showHUD: false)
        }
        tableView.mj_footer = SWRefreshFooter()
        tableView.mj_footer.refreshingBlock = {
            self.pageNum = self.pageNum + 1;
            self.setupMessageData(showHUD: false)
        }
        view.layout(tableView).edges()
    }
    
    @objc func setupMessageData(showHUD: Bool) {
        if showHUD {
            self.showProgreeHUD("加载中...")
        }
        HttpUtils.default.request("/message", method: .get, params: ["pageNum":pageNum]).response(success: { result in
            if showHUD {
                self.hideHUD()
            }
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if self.pageNum <= 1 {
                self.messages.removeAll()
            }
            if let dict = result as? [String: Any] {
                if let list: Array<[String: Any]> = dict["list"] as? Array<[String: Any]> {
                    list.forEach({ (obj) in
                        if let message = SWMessageModel.deserialize(from: obj) {
                            self.messages.append(message)
                        }
                    })
                }
            }
            if self.messages.count <= 0 {
                self.showEmptyView(withText: "", detailText: "暂无更多消息", buttonTitle: "刷新", buttonAction:#selector (self.setupMessageData(showHUD:)))
            } else {
                self.hideEmptyView()
            }
            self.tableView.reloadData()
        }) { errorMsg in
            if showHUD {
                self.hideHUD()
            }
            self.showTextHUD(errorMsg, dismissAfterDelay: 3)
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if self.messages.count <= 0 {
                self.showEmptyView(withText: "", detailText: "网络错误", buttonTitle: "刷新", buttonAction:#selector (self.setupMessageData(showHUD:)))
            }
            self.tableView.reloadData()
        }
    }
}

extension SWMessageController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.section]
        let detailController = SWMessageDetailController()
        detailController.message = message
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let message = messages[indexPath.section]
            HttpUtils.default.request("/message", method: .delete, params: ["msgId":message.id]).response(success: { result in
               
            }) { errorMsg in
            }
            self.messages.remove(at: indexPath.section)
            if self.messages.count <= 0 {
                self.showEmptyView(withText: "", detailText: "暂无更多消息", buttonTitle: "刷新", buttonAction:#selector (self.setupMessageData(showHUD:)))
            }
            tableView.reloadData()
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
        cell?.textLabel?.font = Font.boldSystemFont(ofSize: 12)
        cell?.detailTextLabel?.text =  message.content
        cell?.detailTextLabel?.font = Font.systemFont(ofSize: 11)
        cell?.detailTextLabel?.textColor = Color.blue.accent3
        cell?.detailTextLabel?.numberOfLines = 1;
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let message = messages[section]
        return NSDate.init(timeIntervalSince1970: TimeInterval(message.created/1000)).stringByMessageDate()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
}
