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

class SWIndexViewController: UIViewController {

    fileprivate var menuButton: IconButton!
    fileprivate var starButton: IconButton!

    let v1 = UIView()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5

        v1.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        v1.motionIdentifier = "v1"
        v1.backgroundColor = .purple
        view.addSubview(v1)
        
        prepareMenuButton()
        prepareStarButton()
        prepareNavigationItem()

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
