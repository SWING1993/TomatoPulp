//
//  SWMessageModel.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/3/25.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import HandyJSON

class SWMessageModel: HandyJSON {
    
    var id: Int64 = 0
    var uid: Int64 = 0
    var type: Int = 0
    var created: Int64 = 0
    var title: String = ""
    var content: String = ""

    required init() {}
}
