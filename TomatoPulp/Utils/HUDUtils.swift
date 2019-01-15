//
//  HUDUtils.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/15.
//  Copyright © 2019 songguohua. All rights reserved.
//

import Foundation
import MBProgressHUD
import Async

private var hudKey = "hud"

@objc extension UIViewController {
    
    func showProgreeHUD(_ text: String? = nil) {
        hideHUD()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = text
    }
    
    func showTextHUD(_ text: String?, dismissAfterDelay: TimeInterval) {
        hideHUD()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.detailsLabel.text = text
        hideHUD(dismissAfterDelay)
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    func hideHUD(_ afterDelay: TimeInterval) {
        Async.main(after: afterDelay) {
            self.hideHUD()
        }
    }
    
}

