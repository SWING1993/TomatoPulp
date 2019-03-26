//
//  NSDate+Extension.h
//
//  Created by 宋国华 on 15/4/25.
//  Copyright (c) 2015年 swing1993.cn All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 * 获取日、月、年、小时、分钟、秒
 */
- (NSUInteger)day;
- (NSUInteger)month;
- (NSUInteger)year;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)second;
+ (NSUInteger)day:(NSDate *)date;
+ (NSUInteger)month:(NSDate *)date;
+ (NSUInteger)year:(NSDate *)date;
+ (NSUInteger)hour:(NSDate *)date;
+ (NSUInteger)minute:(NSDate *)date;
+ (NSUInteger)second:(NSDate *)date;

/**
 * 获取格式化为 YYYY年MM月dd日 格式的日期字符串
 */
- (NSString *)formatMDWEEK;
- (NSString *)formatYMDHM;
- (NSString *)formatYMD;
- (NSString *)formatYMDHMLine;
- (NSString *)formatYMDWith:(NSString *)c;

- (NSString *)formatMD;
- (NSString *)formatM:(NSString *)m D:(NSString *)d;
- (NSString *)formatMDHM;
/** 获取 xx日xx时xx分xx秒 */
- (NSString *)formatD:(NSString *)d H:(NSString *)h M:(NSString *)m S:(NSString *)s;

- (NSString *)formatHM;
- (NSString *)formatWeekDay;

/**
 *  获取星期几
 */
- (NSInteger)weekday;
+ (NSInteger)weekday:(NSDate *)date;

/**
 *  获取星期几(名称)
 */
- (NSString *)dayFromWeekday;
+ (NSString *)dayFromWeekday:(NSDate *)date;

/**
 *  Add days to self
 *
 *  @param days The number of days to add
 *  @return Return self by adding the gived days number
 */
- (NSDate *)dateByAddingDays:(NSUInteger)days;

/**
 * 获取月份
 */
+ (NSString *)monthWithMonthNumber:(NSInteger)month;

/**
 * 根据日期返回字符串
 */
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;
/**
 获取当前日期之后几天的日期

 @param day day
 @return date
 */
- (NSDate *)dayInTheFollowingDay:(int)day;
+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format;

/**
 * 获取指定月份的天数
 */
- (NSUInteger)daysInMonth:(NSUInteger)month;
+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month;

/**
 * 获取当前月份的天数
 */
- (NSUInteger)daysInMonth;
+ (NSUInteger)daysInMonth:(NSDate *)date;

/**
 * 返回x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
- (NSString *)timeDetail;
- (NSString *)timeInfo;
+ (NSString *)timeInfoWithDate:(NSDate *)date;
+ (NSString *)timeInfoWithDateString:(NSString *)dateString;

/** 获取像个日期相隔的天数 */
+ (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;

/** 获取日期的年份 xxxx年 */
- (NSString *)yearTextBySendDate;
/** 日期逻辑：今天，昨天，具体日期（xx日xx月） */
- (NSString *)stringBySendDate;
/** 根据日前获取年龄 */
- (NSInteger)getAgeOfBirthDate:(NSDate *)toDay;

/** 日期逻辑：今天 xx:xx，昨天xx:xx，具体日期（xx日xx月） */
- (NSString *)stringByMessageDate;
- (NSString *)stringByTimeHM;
@end
