//
//  SWPostStatusController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/4/4.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWPostStatusController: QMUICommonViewController {

    fileprivate var dismissButton: IconButton!

    override func initSubviews() {
        super.initSubviews()
        prepareNavigationItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

fileprivate extension SWPostStatusController {

    func prepareNavigationItem() {
        dismissButton = IconButton(image: Icon.cm.close)
        dismissButton.addTarget(self, action: #selector(handleToDismiss), for: .touchUpInside)
        navigationItem.titleLabel.text = "此刻的心情"
        navigationItem.detailLabel.text = "👿👿👿"
        navigationItem.leftViews = [dismissButton]
    }
}


fileprivate extension SWPostStatusController {
    
    @objc
    func handleToDismiss() {
        self.dismiss(animated: true) {
            
        }
    }
}
