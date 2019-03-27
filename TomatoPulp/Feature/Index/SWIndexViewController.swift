//
//  SWIndexViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/10.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material
import Alamofire.Swift

class SWIndexViewController: QMUICommonViewController {

    fileprivate var menuButton: IconButton!
    fileprivate var starButton: IconButton!
    
    override func didInitialize() {
        super.didInitialize()
        self.hidesBottomBarWhenPushed = false

    }
    
    override func initSubviews() {
        super.initSubviews()
        view.backgroundColor = Color.grey.lighten5
        prepareMenuButton()
        prepareStarButton()
        prepareNavigationItem()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

    }

}

fileprivate extension SWIndexViewController {

    func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.addTarget(self, action: #selector(handleToASF), for: .touchUpInside)
    }
    
    func prepareStarButton() {
        starButton = IconButton(image: Icon.cm.star)
        starButton.addTarget(self, action: #selector(handleToSSR), for: .touchUpInside)
    }
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = "Index"
        navigationItem.detailLabel.text = "🔥🔥🔥"
        navigationItem.rightViews = [starButton, menuButton]
    }
}

fileprivate extension SWIndexViewController {
    @objc
    func handleToASF() {
        let controller = SWASFViewController()
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc
    func handleToSSR() {
        let controller = SWSSRViewController()
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}
