//
//  SWMessageDetailController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/3/27.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWMessageDetailController: QMUICommonViewController {
    
    var message = SWMessageModel()
    let contentView = QMUITextView.init()
    
    override func didInitialize() {
        super.didInitialize()
    }
    
    override func initSubviews() {
        super.initSubviews()
        prepareNavigationItem()
        prepareContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

fileprivate extension SWMessageDetailController {
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = message.title
        navigationItem.detailLabel.text = NSDate.init(timeIntervalSince1970: TimeInterval(message.created/1000)).stringByMessageDate()
    }
    
    func prepareContentView() {
        contentView.text = message.content
        contentView.font = Font.systemFont(ofSize: 14)
        contentView.textColor = Color.blue.accent3
        contentView.textAlignment = .left
        contentView.isEditable = false
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.qmui_navigationBarMaxYInViewCoordinator + 10)
            maker.left.equalTo(10)
            maker.right.bottom.equalTo(-10)
        }
    }
    
}
