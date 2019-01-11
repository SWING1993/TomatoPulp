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
        loginBtn.reactive.pressed = CocoaAction<RaisedButton>(viewModel.loginAction) {
            _ in
            return (self.phoneField.text!, self.passwordField.text!)
        }
        viewModel.loginAction.values.observeValues { success in
            if success {
                print("login success")
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
        phoneField.placeholder = "Phone"
        phoneField.detail = "11位手机号码"
//        phoneField.detailColor = Color.red.base
        phoneField.error = "手机号码不正确"
        phoneField.isClearIconButtonEnabled = true
//        phoneField.delegate = self
        phoneField.isPlaceholderUppercasedWhenEditing = true
//        emailField.placeholderAnimation = .hidden
//        let leftView = UIImageView()
//        leftView.image = Icon.cm.audio
//        emailField.leftView = leftView
        view.layout(phoneField).top(20).left(20).right(20)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = ErrorTextField()
        passwordField.placeholder = "Password"
        passwordField.detail = "至少6个字符的密码"
//        passwordField.detailColor = Color.red.base
        passwordField.error = "密码不符合要求"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        view.layout(passwordField).top(80).left(20).right(20)
    }
    
    /// Prepares the login button.
    fileprivate func prepareResignResponderButton() {
        loginBtn = RaisedButton(title: "登录", titleColor: Color.blue.base)
        loginBtn.addTarget(self, action: #selector(handleResignResponderButton(button:)), for: .touchUpInside)
        view.layout(loginBtn).top(160).width(100).height(constant).right(20)
    }
}


//extension SWLoginViewController: TextFieldDelegate {
//    public func textFieldDidEndEditing(_ textField: UITextField) {
//        (textField as? ErrorTextField)?.isErrorRevealed = textField.text!.count >= 6
//    }
//}

