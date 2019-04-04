//
//  SWFont.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/4/3.
//  Copyright © 2019 songguohua. All rights reserved.
//

import Foundation

extension UIFont {
   
    static func PFSCRegular(aSize: CGFloat) -> UIFont? {
        return UIFont.init(name: "PingFangSC-Regular", size: aSize)
    }
    
    static func PFSCMedium(aSize: CGFloat) -> UIFont? {
        return UIFont.init(name: "PingFangSC-Medium", size: aSize)
    }
    
    static func PFSCSemibold(aSize: CGFloat) -> UIFont? {
        return UIFont.init(name: "PingFangSC-Semibold", size: aSize)
    }
    
    static func PFSCLight(aSize: CGFloat) -> UIFont? {
        return UIFont.init(name: "PingFangSC-Light", size: aSize)
    }
    
    static func PFSCThin(aSize: CGFloat) -> UIFont? {
        return UIFont.init(name: "PingFangSC-Thin", size: aSize)
    }
    
}
