//
//  SWIndexViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/10.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWIndexViewController: UIViewController {

    fileprivate var menuButton: IconButton!
    fileprivate var starButton: IconButton!
    fileprivate var searchButton: IconButton!
    
    fileprivate var fabButton: FABButton!
    
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
        prepareFABButton()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

fileprivate extension SWIndexViewController {
    func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
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
    
    func prepareFABButton() {
        fabButton = FABButton(image: Icon.cm.moreHorizontal)
        fabButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        view.layout(fabButton).width(64).height(64).bottom(24).right(24)
    }
}

fileprivate extension SWIndexViewController {
    @objc
    func handleNextButton() {
        let transitionViewController = SWIndexViewController()
        navigationController?.pushViewController(transitionViewController, animated: true)
    }
}
