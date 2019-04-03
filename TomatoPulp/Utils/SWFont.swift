//
//  SWFont.swift
//  TomatoPulp
//
//  Created by 宋国华 on 2019/4/3.
//  Copyright © 2019 songguohua. All rights reserved.
//

import Foundation

/*
 #define UIFontPFRegularMake(aSize)    [UIFont fontWithName:@"PingFangSC-Regular" size:aSize]
 #define UIFontPFMediumMake(aSize)  [UIFont fontWithName:@"PingFangSC-Medium" size:aSize]
 #define UIFontPFSemiboldMake(aSize)  [UIFont fontWithName:@"PingFangSC-Semibold" size:aSize]
 #define UIFontPFLightMake(aSize)  [UIFont fontWithName:@"PingFangSC-Light" size:aSize]
 #define UIFontPFThinMake(aSize)  [UIFont fontWithName:@"PingFangSC-Thin" size:aSize]
 
 #define UIFontHNMake(aSize)  [UIFont fontWithName:@"HelveticaNeue" size:aSize]
 #define UIFontHNLightMake(aSize)  [UIFont fontWithName:@"HelveticaNeue-Light" size:aSize]
 #define UIFontHNMediumMake(aSize)  [UIFont fontWithName:@"HelveticaNeue-Medium" size:aSize]
 #define UIFontHNBoldMake(aSize)  [UIFont fontWithName:@"HelveticaNeue-Bold" size:aSize]
 */
extension UIFont {
   
    func PFSCRegular(aSize: CGFloat) -> UIFont? {
        return UIFont.init(name: "PingFangSC-Regular", size: aSize)
    }
    
    func PFSCMedium(aSize: CGFloat) -> UIFont? {
        return UIFont.init(name: "PingFangSC-Medium", size: aSize)
    }
    
    func PFSCSemibold(aSize: CGFloat) -> UIFont? {
        return UIFont.init(name: "PingFangSC-Semibold", size: aSize)
    }
    
    func PFSCLight(aSize: CGFloat) -> UIFont? {
        return UIFont.init(name: "PingFangSC-Light", size: aSize)
    }
    
    func PFThin(aSize: CGFloat) -> UIFont? {
        return UIFont.init(name: "PingFangSC-Thin", size: aSize)
    }
    
}
