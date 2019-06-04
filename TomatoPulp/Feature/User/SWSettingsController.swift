//
//  SWSettingsController.swift
//  TomatoPulp
//
//  Created by YZL-SWING on 2019/6/4.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

class SWSettingsController: QMUICommonTableViewController {
    
    override func initSubviews() {
        super.initSubviews()
        self.prepareNavigationItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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


fileprivate extension SWSettingsController {
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = "设置"
    }
    
}
