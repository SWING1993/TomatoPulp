//
//  AppNavigationController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/10.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class AppNavigationController: NavigationController {
    open override func prepare() {
        super.prepare()
        isMotionEnabled = true
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        v.backgroundColor = .white
        v.depthPreset = .none
        v.dividerColor = Color.grey.lighten2
    }
}
