//
//  CMConfigurationTemplate.h
//
//  Created by 宋国华 on 2018/7/25.
//  Copyright © 2018年 7cm. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIColorMakeX(x)            UIColorMake(x, x, x)
#define UIColorRandom              [UIColor qmui_randomColor]

#define UIFontPFRegularMake(aSize)    [UIFont fontWithName:@"PingFangSC-Regular" size:aSize]
#define UIFontPFMediumMake(aSize)  [UIFont fontWithName:@"PingFangSC-Medium" size:aSize]
#define UIFontPFSemiboldMake(aSize)  [UIFont fontWithName:@"PingFangSC-Semibold" size:aSize]
#define UIFontPFLightMake(aSize)  [UIFont fontWithName:@"PingFangSC-Light" size:aSize]
#define UIFontPFThinMake(aSize)  [UIFont fontWithName:@"PingFangSC-Thin" size:aSize]
#define UIFontHNMake(aSize)  [UIFont fontWithName:@"HelveticaNeue" size:aSize]
#define UIFontHNLightMake(aSize)  [UIFont fontWithName:@"HelveticaNeue-Light" size:aSize]
#define UIFontHNMediumMake(aSize)  [UIFont fontWithName:@"HelveticaNeue-Medium" size:aSize]
#define UIFontHNBoldMake(aSize)  [UIFont fontWithName:@"HelveticaNeue-Bold" size:aSize]

typedef void(^CellTapImageViewBlock)(NSString *imageUrl);

/**
 *  CMConfigurationTemplate 是一份配置表，用于配合 QMUIConfiguration 来管理整个 App 的全局样式，使用方式：
 *  在 QMUI 项目代码的文件夹里找到 QMUIConfigurationTemplate 目录，把里面所有文件复制到自己项目里，保证能被编译到即可，不需要在某些地方 import，也不需要手动运行。
 *
 *  @warning 更新 QMUIKit 的版本时，请留意 Release Log 里是否有提醒更新配置表，请尽量保持自己项目里的配置表与 QMUIKit 里的配置表一致，避免遗漏新的属性。
 *  @warning 配置表的 class 名必须以 QMUIConfigurationTemplate 开头，并且实现 <QMUIConfigurationTemplateProtocol>，因为这两者是 QMUI 识别该 NSObject 是否为一份配置表的条件。
 *  @warning QMUI 2.3.0 之后，配置表改为自动运行，不需要再在某个地方手动运行了。
 */
@interface AppConfigurationTemplate : NSObject

+ (void)applyConfigurationTemplate;

@end
