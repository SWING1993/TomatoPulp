//
//  CMLoginViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/10.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material
import ReactiveCocoa
import ReactiveSwift

class SWLoginViewController: UIViewController {
    
    fileprivate var phoneField: ErrorTextField!
    fileprivate var passwordField: ErrorTextField!
    fileprivate var loginBtn: RaisedButton!

    /// A constant to layout the textFields.
    fileprivate let constant: CGFloat = 32
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        preparePhoneField()
        preparePasswordField()
        prepareResignResponderButton()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.phoneField.text = "18667905583"
        self.passwordField.text = "123456"
        loginBtn.isEnabled = true
        loginBtn.alpha = 0
    }
    
    fileprivate func bindViewModel() -> () {
        // 初始化vm
        let viewModel = SWLoginViewModel.init(phoneField.reactive.continuousTextValues, signal2: passwordField.reactive.continuousTextValues)

        viewModel.phoneErrorSignal.observeValues {
            self.phoneField.isErrorRevealed = $0
        }
        viewModel.passwordErrorSignal.observeValues {
            self.passwordField.isErrorRevealed = $0
        }
        
        // 把信号绑定给登录的button
        loginBtn.reactive.isEnabled <~ viewModel.loginEnableSignal
        loginBtn.reactive.alpha <~ viewModel.loginAlpha
        loginBtn.reactive.pressed = CocoaAction<RaisedButton>(viewModel.loginAction) {
            _ in
            return (self.phoneField.text!, self.passwordField.text!)
        }
        viewModel.loginAction.values.observeValues { message in
            print("登录 + \(message)")
            if message == "登录成功" {
                print("login success")
                let app = UIApplication.shared.delegate as! AppDelegate
                app.toMain()
            } else {
                self.showTextHUD(message, dismissAfterDelay: 3)
            }
        }
    }
    
    /// Handle the resign responder button.
    @objc
    internal func handleResignResponderButton(button: UIButton) {
        phoneField?.resignFirstResponder()
        passwordField?.resignFirstResponder()
    }
}

extension SWLoginViewController {
    fileprivate func preparePhoneField() {
        phoneField = ErrorTextField()
        phoneField.placeholder = "手机号"
        phoneField.detail = "11位手机号码"
        phoneField.error = "手机号码不正确"
        phoneField.isClearIconButtonEnabled = true
        phoneField.isPlaceholderUppercasedWhenEditing = true
        let leftView = UIImageView()
        leftView.image = UIImage.init(named: "phone-solid")?.resize(toWidth: 20)
        phoneField.leftView = leftView
        view.layout(phoneField).top(30).left(20).right(20)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = ErrorTextField()
        passwordField.placeholder = "密码"
        passwordField.detail = "至少6个字符"
        passwordField.error = "密码不符合要求"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        let leftView = UIImageView()
        leftView.image = UIImage.init(named: "unlock-solid")?.resize(toWidth: 20)
        passwordField.leftView = leftView
        view.layout(passwordField).top(120).left(20).right(20)
    }
    
    /// Prepares the login button.
    fileprivate func prepareResignResponderButton() {
        loginBtn = RaisedButton(title: "登录", titleColor: Color.blue.base)
        loginBtn.addTarget(self, action: #selector(handleResignResponderButton(button:)), for: .touchUpInside)
        view.layout(loginBtn).top(220).width(100).height(constant).right(20)
    }
}


