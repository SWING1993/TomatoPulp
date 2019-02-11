//
//  UserInfoViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/2/11.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWUserInfoViewController: QMUICommonViewController {
    
    fileprivate var settingsButton: IconButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareSettingButton()
        prepareNavigationItem()
    }
}

fileprivate extension SWUserInfoViewController {

    func prepareSettingButton() {
        settingsButton = IconButton(image: Icon.cm.settings)
        settingsButton.addTarget(self, action: #selector(handleToSettings), for: .touchUpInside)
    }
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = clientShared.user.nickname
        navigationItem.detailLabel.text = "用户信息"
        navigationItem.rightViews = [settingsButton]
    }
    
    @objc
    func handleToSettings() {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.toLogin()
    }
}
