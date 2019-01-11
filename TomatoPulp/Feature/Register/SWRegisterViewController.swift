//
//  SWRegisterViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/10.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWRegisterViewController: UIViewController {
    fileprivate var phoneField: ErrorTextField!
    fileprivate var passwordField: TextField!
    fileprivate var checkoutPasswordField: TextField!

    /// A constant to layout the textFields.
    fileprivate let constant: CGFloat = 32
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        preparePasswordField()
        prepareEmailField()
        prepareResignResponderButton()
    }
    
    /// Prepares the resign responder button.
    fileprivate func prepareResignResponderButton() {
        let btn = RaisedButton(title: "Resign", titleColor: Color.blue.base)
        btn.addTarget(self, action: #selector(handleResignResponderButton(button:)), for: .touchUpInside)
        view.layout(btn).width(100).height(constant).top(40).right(20)
    }
    
    /// Handle the resign responder button.
    @objc
    internal func handleResignResponderButton(button: UIButton) {
        phoneField?.resignFirstResponder()
        passwordField?.resignFirstResponder()
        checkoutPasswordField?.resignFirstResponder()
    }
}

extension SWRegisterViewController {
    fileprivate func prepareEmailField() {
        phoneField = ErrorTextField()
        phoneField.placeholder = "Email"
        phoneField.detail = "Error, incorrect email"
        phoneField.detailColor = Color.red.base
        phoneField.isClearIconButtonEnabled = true
        phoneField.delegate = self
        phoneField.isPlaceholderUppercasedWhenEditing = true
        view.layout(phoneField).center(offsetY: -passwordField.bounds.height - 60).left(20).right(20)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Password"
        passwordField.detail = "At least 8 characters"
        passwordField.detailColor = Color.red.base
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        view.layout(passwordField).center().left(20).right(20)
    }
    
    fileprivate func prepareCheckoutPasswordField() {
        checkoutPasswordField = TextField()
        checkoutPasswordField.placeholder = "Password"
        checkoutPasswordField.detail = "At least 8 characters"
        checkoutPasswordField.detailColor = Color.red.base
        checkoutPasswordField.clearButtonMode = .whileEditing
        checkoutPasswordField.isVisibilityIconButtonEnabled = true
        view.layout(checkoutPasswordField).center(offsetY: -passwordField.bounds.height + 60).left(20).right(20)
    }
}

extension SWRegisterViewController: TextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? ErrorTextField)?.isErrorRevealed = true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = true
        return true
    }
}
