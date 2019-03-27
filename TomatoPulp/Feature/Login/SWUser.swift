//
//  SWUser.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/1/12.
//  Copyright © 2019 songguohua. All rights reserved.
//

import UIKit
import HandyJSON

class SWUser: HandyJSON {
    var id: Int = 0
    var phone : String = ""
    var email: String = ""
    var nickname: String = ""
    var sex: Int = 0
    var avatarUrl: String = ""
    var userDesc: String = ""
    var token: String = ""
    var clientId: String = ""

    required init() {}

}


/*
 private int id;
 private String phone;
 private String email;
 @JsonIgnore
 private String password;
 private Date created;
 private Date updated;
 private String nickname;
 private int sex;
 private String avatarUrl;
 private String userDesc;
 
 // 会员状态 0 未开通 1 已开通 2 已到期
 private int vipStatus;
 // 会员开通时间
 private Date vipStartDate;
 // 会员结束时间
 private Date vipEndDate;
 
 private String token;
 */
