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

    // 登录的Action
    var loginAction : Action<(String, String), Bool, NoError>
    
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
        
        // 根据合并的信号，创建控制登录按钮enable的属性
        let loginEnable = Property(initial: false, then: loginEnableSignal)
        
        loginAction = Action(enabledIf: loginEnable) {
            phone, password in
            return SignalProducer<Bool, NoError> { observer, disposable in
                let parameters: Parameters = ["phone": phone, "password": password]
                AF.request("http://118.24.216.163:8080/tomato/user/login", method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: HTTPHeaders.init(["Content-Type" : "application/json"])).responseString(completionHandler: { response in
                    //网络请求
                    print(response)
                    observer.send(value: true)
                    observer.sendCompleted()
                })

            }
        }
    }


}
