//
//  LoginViewModel.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/11.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError
import Alamofire.Swift
import Material

class SWLoginViewModel: NSObject {
    
    // 接收用户手机号的信号
    var phoneSignal : Signal<String?, NoError>
    
    // 接收密码的信号
    var passwordSignal : Signal<String?, NoError>
    
    // 用户名合法与否的信号
    var phoneErrorSignal : Signal<Bool, NoError>
    
    // 密码合法与否的信号
    var passwordErrorSignal : Signal<Bool, NoError>
    
    // 用户名密码合法与否的信号
    var loginEnableSignal : Signal<Bool, NoError>
    
    var loginAlpha : Property<CGFloat>

    // 登录的Action
    var loginAction : Action<(String, String), String, NoError>
    
    init(_ signal1 : Signal<String?, NoError>, signal2 : Signal<String?, NoError>) {
        // 信号赋值
        phoneSignal = signal1
        passwordSignal = signal2
        
        // 手机号是否合法
        phoneErrorSignal = phoneSignal.map{$0!.count < 6}
        
        // 密码号是否合法
        passwordErrorSignal = passwordSignal.map{$0!.count < 6}
        
        // 合并信号
        loginEnableSignal = Signal.combineLatest(phoneErrorSignal, passwordErrorSignal).map{ !$0 && !$1 }
        
        //通过.map对输入框变化的信号进行映射
        let alphaSignal : Signal<CGFloat, NoError> = loginEnableSignal.map {
            return $0 ? 1 : 0.5
        }
        //根据信号创建textfield的颜色属性
        loginAlpha = Property(initial: 0.5, then: alphaSignal)
        
        // 根据合并的信号，创建控制登录按钮enable的属性
        let loginEnable = Property(initial: false, then: loginEnableSignal)
        
        loginAction = Action(enabledIf: loginEnable) {
            phone, password in
            return SignalProducer<String, NoError> { observer, disposable in
                let parameters: Parameters = ["phone": phone, "password": password]
                AF.request("http://118.24.216.163:8080/tomato/user/login", method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders.init(["Content-Type" : "application/json"])).responseString(completionHandler: { response in
                    //网络请求
                    var message : String = ""
                    response.result.ifSuccess {
                        if let httpResult = AppHttpResponse.deserialize(from: response.result.value) {
                            if httpResult.success {
                                message = "登录成功"
                                if let user  = SWUser.deserialize(from: httpResult.result) {
                                   clientShared.saveUserInfo(user: user)
                                }
                            } else {
                                message = httpResult.message!
                            }
                        }
                    }
                    response.result.ifFailure({
                        message = (response.error?.localizedDescription)!
                    })
                    
                    observer.send(value: message)
                    observer.sendCompleted()
                })

            }
        }
    }
}
