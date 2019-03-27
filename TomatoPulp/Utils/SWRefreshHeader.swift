//
//  SWRefreshHeader.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/3/27.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

class SWRefreshHeader: MJRefreshNormalHeader {
    override func prepare() {
        super.prepare()
        self.stateLabel.isHidden = true
        self.lastUpdatedTimeLabel.isHidden = true
    }
}
