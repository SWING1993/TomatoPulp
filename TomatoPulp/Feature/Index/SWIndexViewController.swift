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
    fileprivate var searchButton: IconButton!

    
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
        prepareSearchButton()
        prepareNavigationItem()
      
    }

}

fileprivate extension SWIndexViewController {

    func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
//        menuButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
    }
    
    func prepareStarButton() {
        starButton = IconButton(image: Icon.cm.star)
    }
    
    func prepareSearchButton() {
        searchButton = IconButton(image: Icon.cm.search)
    }
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = "Material"
        navigationItem.detailLabel.text = "Build Beautiful Software"
        
        navigationItem.leftViews = [menuButton]
        navigationItem.rightViews = [starButton, searchButton]
    }
    
   
}


fileprivate extension SWIndexViewController {
    @objc
    func handleNextButton() {
        navigationController?.pushViewController(SWASFViewController(), animated: true)
    }
}
