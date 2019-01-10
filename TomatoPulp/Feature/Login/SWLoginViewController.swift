//
//  CMLoginViewController.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/10.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import Material

class SWLoginViewController: UIViewController {
    fileprivate var emailField: ErrorTextField!
    fileprivate var passwordField: TextField!
    
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
        emailField?.resignFirstResponder()
        passwordField?.resignFirstResponder()
    }
}

extension SWLoginViewController {
    fileprivate func prepareEmailField() {
        emailField = ErrorTextField()
        emailField.placeholder = "Email"
        emailField.detail = "Error, incorrect email"
        emailField.isClearIconButtonEnabled = true
        emailField.delegate = self
        emailField.isPlaceholderUppercasedWhenEditing = true
        emailField.placeholderAnimation = .hidden
        
        // Set the colors for the emailField, different from the defaults.
        //        emailField.placeholderNormalColor = Color.amber.darken4
        //        emailField.placeholderActiveColor = Color.pink.base
        //        emailField.dividerNormalColor = Color.cyan.base
        //        emailField.dividerActiveColor = Color.green.base
        // Set the text inset
        //        emailField.textInset = 20
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.audio
        emailField.leftView = leftView
        
        view.layout(emailField).center(offsetY: -passwordField.bounds.height - 60).left(20).right(20)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Password"
        passwordField.detail = "At least 8 characters"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        
        view.layout(passwordField).center().left(20).right(20)
    }
}

extension SWLoginViewController: TextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? ErrorTextField)?.isErrorRevealed = false
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
