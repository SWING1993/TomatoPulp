//
//  SWAppClient.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/12.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit

let clientShared = SWAppClient()

class SWAppClient: NSObject {

    var user : SWUser = SWUser()
    fileprivate let userStoreKey : String = "user"
    
    override init() {
        let userJson  = UserDefaults.standard.string(forKey: userStoreKey)
        if let user  = SWUser.deserialize(from: userJson) {
            self.user = user
        }
    }
    
    public func isLogin() -> Bool {
        return !self.user.token.isEmpty
    }
    
    public func saveUserInfo() {
        let userJson = clientShared.user.toJSONString()!
        UserDefaults.standard.set(userJson, forKey: userStoreKey)
        UserDefaults.standard.synchronize()
    }
    
    public func removeUserInfo() {
        UserDefaults.standard.set("", forKey: userStoreKey)
        UserDefaults.standard.synchronize()
    }
    
    public func refreshToekn() {
        HttpUtils.default.request("/user/refreshToekn").response(success: { result in
            if let dict: [String: String] = result as? [String: String] {
                if let token = dict["token"] {
                    print("refreshToken toekn: \(token)")
                    self.user.token = token
                    self.saveUserInfo()
                }
            }
        }) { error in
            print("refreshToken Error:\(error)")
        }
    }
}
