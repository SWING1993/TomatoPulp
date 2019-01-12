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
        if let token = self.user.token {
            return !token.isEmpty
        }
        return false
    }
    
    public func saveUserInfo(user: SWUser) {
        let userJson = user.toJSONString()!
        UserDefaults.standard.set(userJson, forKey: userStoreKey)
        UserDefaults.standard.synchronize()
    }
}
