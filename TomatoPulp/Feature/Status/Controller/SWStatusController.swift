//
//  SWStatusController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/3/14.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWStatusController: QMUICommonViewController {

    fileprivate var tableView: TableView!
    
    override func didInitialize() {
        super.didInitialize()
    }
    
    override func initSubviews() {
        super.initSubviews()
        prepareNavigationItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

fileprivate extension SWStatusController {
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = "Status"
        navigationItem.detailLabel.text = "👿👿👿"
    }
}
