//
//  UserInfoViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/2/11.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import AlamofireImage
import Material
import SnapKit
import BlocksKit

class SWUserInfoViewController: QMUICommonViewController {
    
    fileprivate let settingsButton: IconButton = IconButton(image: Icon.cm.settings)
    fileprivate let avatarView: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareSettingButton()
        prepareNavigationItem()
        prepareAvatarView()
    }
}

fileprivate extension SWUserInfoViewController {

    func prepareSettingButton() {
        settingsButton.addTarget(self, action: #selector(handleToSettings), for: .touchUpInside)
    }
    
    func prepareNavigationItem() {
        navigationItem.titleLabel.text = clientShared.user.nickname
        navigationItem.detailLabel.text = "用户信息"
        navigationItem.rightViews = [settingsButton]
    }
    
    func prepareAvatarView() {
        if let avatarUrl = clientShared.user.avatarUrl {
            let url = URL(string: avatarUrl)!
            avatarView.af_setImage(withURL: url)
        }
        avatarView.isUserInteractionEnabled = true
        avatarView.layer.cornerRadius = 30
        avatarView.layer.masksToBounds = true
        avatarView.layer.borderColor = UIColor(red: 225/255, green: 245/255, blue: 254/255, alpha: 1).cgColor
        avatarView.layer.borderWidth = 0.5
        self.view.addSubview(avatarView)
        avatarView.snp.makeConstraints { maker in
            maker.left.equalTo(15)
            maker.top.equalTo(80)
            maker.size.equalTo(CGSize(width: 60, height: 60))
        }
        avatarView.bk_(whenTapped: {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        })
    }
    
    @objc
    func handleToSettings() {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.toLogin()
    }
}

extension SWUserInfoViewController : UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.showProgreeHUD("上传中...")
        let aImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        OssService().putImage(image: aImage, compression: true, succees: { imageUrl in
            print("图片上传成功：\(imageUrl)")
            self.hideHUD()
            clientShared.user.avatarUrl = imageUrl
            let params = clientShared.user.toJSON()
            HttpUtils.default.request("/user", method: .put, params: params).response(success: { result in
                print("保存成功：\(String(describing: result))")
                clientShared.saveUserInfo()
                self.avatarView.image = aImage
            }, failure: { error in
                print("保存失败：\(error)")
                self.showTextHUD("图片保存失败：\(error)", dismissAfterDelay: 3)
            })
        }) { (error) in
            print("图片上传失败：\(error)")
            self.hideHUD()
            self.showTextHUD("图片上传失败：\(error)", dismissAfterDelay: 3)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
