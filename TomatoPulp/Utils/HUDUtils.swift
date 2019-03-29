//
//  HUDUtils.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/15.
//  Copyright © 2019 songguohua. All rights reserved.
//

import Foundation
import Async

private var hudKey = "hud"

@objc extension UIViewController {
    
    func showProgreeHUD(_ text: String? = nil) {
        QMUITips.hideAllTips(in: self.view)
        QMUITips.showLoading(text, in: self.view)
    }
    
    func showTextHUD(_ text: String?, dismissAfterDelay: TimeInterval) {
        QMUITips.hideAllTips(in: self.view)
        QMUITips.showInfo(text, in: self.view, hideAfterDelay: dismissAfterDelay)
    }
    
    func hideHUD() {
        QMUITips.hideAllTips()
    }
    
    func hideHUD(_ afterDelay: TimeInterval) {
        Async.main(after: afterDelay) {
            QMUITips.hideAllTips()
        }
    }
    
}

