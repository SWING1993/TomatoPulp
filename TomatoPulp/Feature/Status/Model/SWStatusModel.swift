//
//  SWStatusModel.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/3/15.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import HandyJSON

class SWStatusModel: HandyJSON {
    var id : Int64 = 0
    var uid: Int64 = 0
    // 状态类型 0 = 图文  1 = 视频
    var type : Int = 0
    var created: Int64 = 0
    var nickname : String = ""
    var avatarUrl : String = ""
    var content: String = ""
    var imageUrls: String = ""
    var vedioUrl: String = ""
    var fromDevice: String = ""

    required init() {}
}

extension SWStatusModel : ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self as! NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object {
            return true
        }
        return false
    }
}
