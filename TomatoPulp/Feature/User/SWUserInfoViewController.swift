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
import Async

class SWUserInfoViewController: QMUICommonTableViewController {
    
    fileprivate let settingsButton: IconButton = IconButton(image: Icon.cm.settings)
    fileprivate var userBGView : SWUserBGView?
    
    override func didInitialize() {
        super.didInitialize()
    }
    
    override func initSubviews() {
        super.initSubviews()
        prepareSettingButton()
        prepareNavigationItem()
    }
    
    override func initTableView() {
        super.initTableView()
        self.userBGView = SWUserBGView.init(frame: CGRect.init(x: 0, y: 0, width: kUIScreenWidth, height: 300))
        self.tableView.tableHeaderView = userBGView
        userBGView?.avatarView.bk_(whenTapped: {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if clientShared.user.avatarUrl.count > 0 {
            self.userBGView?.avatarView.af_setImage(withURL: URL(string: clientShared.user.avatarUrl)!)
        }
        self.userBGView?.nicknameLabel.text = clientShared.user.nickname;
        
    }

}

fileprivate extension SWUserInfoViewController {
    
    func prepareSettingButton() {
        settingsButton.addTarget(self, action: #selector(handleToSettings), for: .touchUpInside)
    }
    
    func prepareNavigationItem() {
//        navigationItem.titleLabel.text = clientShared.user.nickname
//        navigationItem.detailLabel.text = "🎈🎈🎈"
        navigationItem.rightViews = [settingsButton]
    }
    
    @objc
    func handleToSettings() {
        let controller = SWSettingsController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        //        let app = UIApplication.shared.delegate as! AppDelegate
        //        app.toLogin()
    }

}

extension SWUserInfoViewController : UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.showProgreeHUD("上传中...")
        let aImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        OssService().putImage(image: aImage, compression: true, succees: { imageUrl in
            Async.main{
                print("图片上传成功：\(imageUrl)")
                self.hideHUD()
                clientShared.user.avatarUrl = imageUrl
                let params = clientShared.user.toJSON()
                HttpUtils.default.request("/user", method: .put, params: params).response(success: { result in
                    print("保存成功：\(String(describing: result))")
                    clientShared.saveUserInfo()
                    self.userBGView?.avatarView.image = aImage
                }, failure: { error in
                    print("保存失败：\(error)")
                    self.showTextHUD("图片保存失败：\(error)", dismissAfterDelay: 3)
                })
            }
            
        }) { (error) in
            Async.main{
                print("图片上传失败：\(error)")
                self.hideHUD()
                self.showTextHUD("图片上传失败：\(error)", dismissAfterDelay: 3)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

