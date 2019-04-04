//
//  SWPostStatusController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/4/4.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material
import ReactiveCocoa
import ReactiveSwift

class SWPostStatusController: QMUICommonViewController {

    fileprivate var dismissButton: IconButton!
    fileprivate var postButton: Button!
    fileprivate var tableView: TableView!
    fileprivate var postModel = SWStatusModel()
    fileprivate var textView: QMUITextView!
    
    override func didInitialize() {
        super.didInitialize()
        self.postModel.uid = clientShared.user.id
        self.postModel.fromDevice = "iPhone Xs Max"
        
    }
    
    override func initSubviews() {
        super.initSubviews()
        prepareNavigationItem()
        prepareTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.snp.makeConstraints { maker in
            maker.left.top.equalTo(12.5);
            maker.right.bottom.equalTo(-12.5)
        }
    }
}

fileprivate extension SWPostStatusController {

    func prepareTableView() {
        let tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 200))
        textView = QMUITextView()
        textView.placeholder = "此刻的心情..."
        textView.font = UIFont.PFSCRegular(aSize: 14)
        textView.textColor = Color.darkText.primary
        tableHeaderView.addSubview(textView)
        textView.reactive.continuousTextValues.observeValues({ text in
            self.postModel.content = text!
        })
        tableView = TableView.init(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.tableHeaderView = tableHeaderView
        view.layout(tableView).edges()
    }
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = "Status"
        dismissButton = IconButton(image: Icon.cm.close)
        dismissButton.addTarget(self, action: #selector(handleToDismiss), for: .touchUpInside)
        navigationItem.leftViews = [dismissButton]
        postButton = Button.init(title: "Post")
        postButton.addTarget(self, action: #selector(handleToPost), for: .touchUpInside)
        navigationItem.rightViews = [postButton]
    }
}


fileprivate extension SWPostStatusController {
    
    @objc
    func handleToDismiss() {
        self.dismiss(animated: true) {
        }
    }
    
    @objc
    func handleToPost() {
        self.view.endEditing(true)
        if self.postModel.content.isEmpty {
            self.showTextHUD("状态内容不能为空", dismissAfterDelay: 3)
            return
        }
        self.showProgreeHUD()
        HttpUtils.default.request("/status", method: .post, params: self.postModel.toJSON()).response(success: { _ in
            self.hideHUD()
            self.handleToDismiss()
        }) { error in
            self.hideHUD()
            self.showTextHUD(error, dismissAfterDelay: 3)
        }
    }
}


extension SWPostStatusController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension SWPostStatusController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = TableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        }
        return cell!
    }
}

extension SWPostStatusController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

