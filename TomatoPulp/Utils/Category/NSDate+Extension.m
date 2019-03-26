//
//  NSDate+Extension.m
//
//  Created by 宋国华 on 15/4/25.
//  Copyright (c) 2015年 swing1993.cn All rights reserved.

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSUInteger)day {
    return [NSDate day:self];
}

- (NSUInteger)month {
    return [NSDate month:self];
}

- (NSUInteger)year {
    return [NSDate year:self];
}

- (NSUInteger)hour {
    return [NSDate hour:self];
}

- (NSUInteger)minute {
    return [NSDate minute:self];
}

- (NSUInteger)second {
    return [NSDate second:self];
}

+ (NSUInteger)day:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents day];
}

+ (NSUInteger)month:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents month];
}

+ (NSUInteger)year:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents year];
}

+ (NSUInteger)hour:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitHour) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSHourCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents hour];
}

+ (NSUInteger)minute:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMinute) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMinuteCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents minute];
}

+ (NSUInteger)second:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitSecond) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSSecondCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents second];
}


- (BOOL)isLeapYear {
    return [NSDate isLeapYear:self];
}

+ (BOOL)isLeapYear:(NSDate *)date {
    NSUInteger year = [date year];
    if ((year % 4  == 0 && year % 100 != 0) || year % 400 == 0) {
        return YES;
    }
    return NO;
}

- (NSString *)formatMDWEEK {
    return [NSString stringWithFormat:@"%02lu-%02lu %@", (unsigned long)[self month], (unsigned long)[self day],[self formatWeekDay]];

}

- (NSString *)formatYMDHM {
    return [NSString stringWithFormat:@"%lu年%02lu月%02lu日 %02lu:%02lu", (unsigned long)[self year],(unsigned long)[self month], (unsigned long)[self day],(unsigned long)[self hour],(unsigned long)[self minute]];
}

- (NSString *)formatYMDHMLine {
    return [NSString stringWithFormat:@"%lu-%02lu-%02lu %02lu:%02lu:%02lu", (unsigned long)[self year],(unsigned long)[self month], (unsigned long)[self day],(unsigned long)[self hour],(unsigned long)[self minute],(unsigned long)[self second]];
}

- (NSString *)formatYMD {
    return [NSString stringWithFormat:@"%lu年%02lu月%02lu日", (unsigned long)[self year],(unsigned long)[self month], (unsigned long)[self day]];
}

- (NSString *)formatYMDWith:(NSString *)c {
    return [NSString stringWithFormat:@"%lu%@%02lu%@%02lu", (unsigned long)[self year], c, (unsigned long)[self month], c, (unsigned long)[self day]];
}

- (NSString *)formatMD
{
    return [NSString stringWithFormat:@"%02lu月%02lu日", (unsigned long)[self month], (unsigned long)[self day]];
}
- (NSString *)formatMDHM
{
    return [NSString stringWithFormat:@"%02lu-%02lu %02lu:%02lu", (unsigned long)[self month], (unsigned long)[self day], (unsigned long)[self hour], (unsigned long)[self minute]];
}
- (NSString *)formatM:(NSString *)m D:(NSString *)d
{
    return [NSString stringWithFormat:@"%02lu%@%02lu%@", (unsigned long)[self month], m,(unsigned long)[self day],d];
}

- (NSString *)formatHM {
    return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)[self hour], (unsigned long)[self minute]];
}

- (NSString *)formatD:(NSString *)d H:(NSString *)h M:(NSString *)m S:(NSString *)s {
    return [NSString stringWithFormat:@"%02lu%@%02lu%@%02lu%@%02lu%@", (unsigned long)[self day], d,(unsigned long)[self hour],h,(unsigned long)[self minute], m,(unsigned long)[self second],s];
}

- (NSInteger)weekday {
    return [NSDate weekday:self];
}

+ (NSInteger)weekday:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:date];
    NSInteger weekday = [comps weekday];
    
    return weekday;
}

- (NSString *)dayFromWeekday {
    return [NSDate dayFromWeekday:self];
}

- (NSString *)formatWeekDay {
    switch([self weekday]) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)dayFromWeekday:(NSDate *)date {
    switch([date weekday]) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}

- (NSDate *)dateByAddingDays:(NSUInteger)days {
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

/**
 *  Get the month as a localized string from the given month number
 *
 *  @param month The month to be converted in string
 *  [1 - January]
 *  [2 - February]
 *  [3 - March]
 *  [4 - April]
 *  [5 - May]
 *  [6 - June]
 *  [7 - July]
 *  [8 - August]
 *  [9 - September]
 *  [10 - October]
 *  [11 - November]
 *  [12 - December]
 *
 *  @return Return the given month as a localized string
 */
+ (NSString *)monthWithMonthNumber:(NSInteger)month {
    switch(month) {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format {
    return [date stringWithFormat:format];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *retStr = [outputFormatter stringFromDate:self];
    return retStr;
}

//获取当前日期之后的几个天
- (NSDate *)dayInTheFollowingDay:(int)day{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

- (NSUInteger)daysInMonth:(NSUInteger)month {
    return [NSDate daysInMonth:self month:month];
}

+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month {
    switch (month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return [date isLeapYear] ? 29 : 28;
    }
    return 30;
}

- (NSUInteger)daysInMonth {
    return [NSDate daysInMonth:self];
}

+ (NSUInteger)daysInMonth:(NSDate *)date {
    return [self daysInMonth:date month:[date month]];
}

- (NSString *)timeDetail {
    
    NSDate *curDate = [NSDate date];
    NSTimeInterval time = -[self timeIntervalSinceDate:curDate];
    int month = (int)([curDate month] - [self month]);
    int year = (int)([curDate year] - [self year]);
    int day = (int)([curDate day] - [self day]);
    
    NSTimeInterval retTime = 1.0;
    if (time < 3600) { // 小于一小时
        retTime = time / 60;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        if (retTime <  1.0) {
            return @"刚刚";
        }
        return [NSString stringWithFormat:@"%.0f分钟前", retTime];
    } else if (time < 3600 * 24) { // 小于一天，也就是今天
        retTime = time / 3600;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f小时前", floor(retTime)];
    } else if (time < 3600 * 24 * 2) {
        return @"昨天";
    }
    // 第一个条件是同年，且相隔时间在一个月内
    // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
    else if ((abs(year) == 0 && abs(month) <= 1)
             || (abs(year) == 1 && [curDate month] == 1 && [self month] == 12)) {
        int retDay = 0;
        if (year == 0) { // 同年
            if (month == 0) { // 同月
                retDay = day;
            }
        }
        
        if (retDay <= 0) {
            // 获取发布日期中，该月有多少天
            int totalDays = (int)[self daysInMonth];
            
            // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
            retDay = (int)[curDate day] + (totalDays - (int)[self day]);
        }
        
        return [NSString stringWithFormat:@"%d天前", (abs)(retDay)];
    } else  {
        if (abs(year) <= 1) {
            if (year == 0) { // 同年
                return [NSString stringWithFormat:@"%d个月前", abs(month)];
            }
            
            // 隔年
            int month = (int)[curDate month];
            int preMonth = (int)[self month];
            if (month == 12 && preMonth == 12) {// 隔年，但同月，就作为满一年来计算
                return @"1年前";
            }
            return [NSString stringWithFormat:@"%d个月前", (abs)(12 - preMonth + month)];
        }
        return [NSString stringWithFormat:@"%d年前", abs(year)];
    }
    return @"1小时前";
}

- (NSString *)timeInfo {
    return [NSDate timeInfoWithDate:self];
}

+ (NSString *)timeInfoWithDate:(NSDate *)date {
    return [self timeInfoWithDateString:[self stringWithDate:date format:@"yyyy-MM-dd HH:mm:ss"]];
}

+ (NSString *)timeInfoWithDateString:(NSString *)dateString {
    NSDate *date = [self dateWithString:dateString format:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *curDate = [NSDate date];
    NSTimeInterval time = -[date timeIntervalSinceDate:curDate];
    
    int month = (int)([curDate month] - [date month]);
    int year = (int)([curDate year] - [date year]);
    int day = (int)([curDate day] - [date day]);
    
    NSTimeInterval retTime = 1.0;
    if (time < 3600) { // 小于一小时
        if (time < 60) {
            return @"刚刚";
        }
        retTime = time/60;
        return [NSString stringWithFormat:@"%ld分钟前", (long)retTime];
    } else if (time < 3600 * 24) { // 小于一天，也就是今天
        retTime = time / 3600;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f小时前", retTime];
    } else if (time < 3600 * 24 * 2) {
        return @"昨天";
    }
    // 第一个条件是同年，且相隔时间在一个月内
    // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
    else if ((abs(year) == 0 && abs(month) <= 1)
             || (abs(year) == 1 && [curDate month] == 1 && [date month] == 12)) {
        int retDay = 0;
        if (year == 0) { // 同年
            if (month == 0) { // 同月
                retDay = day;
            }
        }
        
        if (retDay <= 0) {
            // 获取发布日期中，该月有多少天
            int totalDays = (int)[self daysInMonth:date month:[date month]];
            
            // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
            retDay = (int)[curDate day] + (totalDays - (int)[date day]);
        }
        
        return [NSString stringWithFormat:@"%d天前", (abs)(retDay)];
    } else  {
        if (abs(year) <= 1) {
            if (year == 0) { // 同年
                return [NSString stringWithFormat:@"%d个月前", abs(month)];
            }
            
            // 隔年
            int month = (int)[curDate month];
            int preMonth = (int)[date month];
            if (month == 12 && preMonth == 12) {// 隔年，但同月，就作为满一年来计算
                return @"1年前";
            }
            return [NSString stringWithFormat:@"%d个月前", (abs)(12 - preMonth + month)];
        }
        
        return [NSString stringWithFormat:@"%d年前", abs(year)];
    }
    
    return @"1小时前";
}

+ (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

/** 获取日期的年份 今年：@"", 其他：xxxx年 */
- (NSString *)yearTextBySendDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *sendCom = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitSecond) fromDate:self];
    NSString *str = [NSString stringWithFormat:@"%lu年",(unsigned long)sendCom.year];
    return str;
}

/** 日期逻辑：今天，昨天，具体日期（xx日xx月） */
- (NSString *)stringBySendDate {
    NSDate *toDay = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *sendCom = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitSecond) fromDate:self];
    
    NSString *str_date = [NSString stringWithFormat:@"%02lu%ld月",(unsigned long)sendCom.day,(unsigned long)sendCom.month];
    NSDate *date1 = [toDay dateByAddingDays:-1];
    
    NSString *station_ymd = [self formatYMD];
    NSString *str_toDay = [toDay formatYMD];
    NSString *str_day1 = [date1 formatYMD];
    if ([station_ymd isEqualToString:str_toDay]) {
        str_date = @"今天";
    } else if ([station_ymd isEqualToString:str_day1]) {
        str_date = @"昨天";
    }
    return str_date;
}

- (NSString *)stringByMessageDate {
    NSDate *toDay = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *sendCom = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitSecond) fromDate:self];
    
    NSString *str_date = [NSString stringWithFormat:@"%02lu/%02lu",(unsigned long)sendCom.month,(unsigned long)sendCom.day];
    NSDate *date1 = [toDay dateByAddingDays:-1];
    
    NSString *station_ymd = [self formatYMD];
    NSString *str_toDay = [toDay formatYMD];
    NSString *str_day1 = [date1 formatYMD];
    if ([station_ymd isEqualToString:str_toDay]) {
        str_date = [NSString stringWithFormat:@"今天 %@",[self formatHM]];
    } else if ([station_ymd isEqualToString:str_day1]) {
        str_date = [NSString stringWithFormat:@"昨天 %@",[self formatHM]];
    }
    return str_date;
}

- (NSString *)stringByTimeHM {
    NSDate *toDay = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *sendCom = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitSecond) fromDate:self];
    
    NSString *str_date = [NSString stringWithFormat:@"%02lu/%02lu",(unsigned long)sendCom.month,(unsigned long)sendCom.day];
    NSDate *date1 = [toDay dateByAddingDays:-1];
    
    NSString *station_ymd = [self formatYMD];
    NSString *str_toDay = [toDay formatYMD];
    NSString *str_day1 = [date1 formatYMD];
    if ([station_ymd isEqualToString:str_toDay]) {
        str_date = [NSString stringWithFormat:@"%@",[self formatHM]];
    } else if ([station_ymd isEqualToString:str_day1]) {
        str_date = [NSString stringWithFormat:@"昨天"];
    }
    return str_date;
}

- (NSInteger)getAgeOfBirthDate:(NSDate *)toDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *sendCom = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitSecond) fromDate:self];
    NSDateComponents *todayCom = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitSecond) fromDate:toDay];
    
    NSInteger brithDateYear  = [sendCom year];
    NSInteger brithDateMonth = [sendCom month];
    NSInteger brithDateDay   = [sendCom day];
    
    NSInteger currentDateYear  = [todayCom year];
    NSInteger currentDateMonth = [todayCom month];
    NSInteger currentDateDay   = [todayCom day];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    return iAge;
}

@end
