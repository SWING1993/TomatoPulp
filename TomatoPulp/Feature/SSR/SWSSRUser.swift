//
//  SWSSRUser.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/14.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import HandyJSON

class SWSSRUser: HandyJSON {
    
    var d: Int64 = 0
    var enable: Bool = true
    var forbidden_port: String = ""
    var method: String = "aes-256-cfb"
    var obfs: String = "plain"
    var passwd: String = "abcZXC"
    var port: Int = 0
    var protocol_: String = "origin"
    var protocol_param: String = "10"
    var speed_limit_per_con: Int = 0
    var speed_limit_per_user: Int = 0
    var transfer_enable: Int64 = 0
    var u: Int64 = 0
    var user: String = "ssr_user"
    
    required init() {}
}
