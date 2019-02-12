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
//        let app = UIApplication.shared.delegate as! AppDelegate
//        app.toLogin()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(imagePickerController, animated: true) {
            
        }
    }
    
    
}

extension SWUserInfoViewController : UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let aImage = info[UIImagePickerController.InfoKey.originalImage];
        OssService().putImage(image: aImage as! UIImage, compression: true, succees: { imageUrl in
            print(imageUrl)
        }) { (error) in
            print(error)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
