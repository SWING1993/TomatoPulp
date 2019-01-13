//
//  AppHttpResult.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/12.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import HandyJSON

class AppHttpResponse: HandyJSON {
    
    var success: Bool = false
    var message : String?
    var error: String?
    var time: String?
    var result: Any?
    
    required init() {}
}
