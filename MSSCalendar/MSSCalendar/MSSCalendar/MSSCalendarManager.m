//
//  MSSCalendarManager.m
//  MSSCalendar
//
//  Created by 于威 on 16/4/3.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "MSSCalendarManager.h"
#import "MSSChineseCalendarManager.h"

@interface MSSCalendarManager ()

@property (nonatomic,strong)NSDate *todayDate;
@property (nonatomic,strong)NSDateComponents *todayCompontents;
@property (nonatomic,strong)NSCalendar *greCalendar;
@property (nonatomic,strong)NSDateFormatter *dateFormatter;
@property (nonatomic,strong)MSSChineseCalendarManager *chineseCalendarManager;
@property (nonatomic,assign)BOOL showChineseHoliday;// 是否展示农历节日
@property (nonatomic,assign)BOOL showChineseCalendar;// 是否展示农历
@property (nonatomic,assign)NSInteger startDate;

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation MSSCalendarManager

- (instancetype)initWithShowChineseHoliday:(BOOL)showChineseHoliday showChineseCalendar:(BOOL)showChineseCalendar startDate:(NSInteger)startDate
{
    self = [super init];
    {
        _greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        _todayDate = [NSDate date];
        _todayCompontents = [self dateToComponents:_todayDate];
        _dateFormatter = [[NSDateFormatter alloc]init];
        _chineseCalendarManager = [[MSSChineseCalendarManager alloc]init];
        _showChineseCalendar = showChineseCalendar;
        _showChineseHoliday = showChineseHoliday;
        _startDate = startDate;
    }
    return self;
}




- (NSArray *)getCalendarDataSoruceWithLimitMonth:(NSInteger)limitMonth type:(MSSCalendarViewControllerType)type
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    NSDateComponents *components = [self dateToComponents:_todayDate];
    components.day = 1;
    if(type == MSSCalendarViewControllerNextType)
    {
        components.month -= 1;
    }
    else if(type == MSSCalendarViewControllerLastType)
    {
        components.month -= limitMonth;
    }
    else
    {
        components.month -= (limitMonth + 1) / 2;
    }
    NSInteger i = 0;
    for(i = 0;i < limitMonth;i++)
    {
        components.month++;
        MSSCalendarHeaderModel *headerItem = [[MSSCalendarHeaderModel alloc]init];
        NSDate *date = [self componentsToDate:components];
        [_dateFormatter setDateFormat: @"yyyy年MM月"];
        NSString *dateString = [_dateFormatter stringFromDate:date];
        headerItem.headerText = dateString;
        headerItem.calendarItemArray = [self getCalendarItemArrayWithDate:date section:i];
        [resultArray addObject:headerItem];
    }
    return resultArray;
}

// 得到每一天的数据源
- (NSArray *)getCalendarItemArrayWithDate:(NSDate *)date section:(NSInteger)section
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSInteger tatalDay = [self numberOfDaysInCurrentMonth:date];
    NSInteger firstDay = [self startDayOfWeek:date];
    
    NSDateComponents *components = [self dateToComponents:date];
    
    // 判断日历有多少列
    NSInteger tempDay = tatalDay + (firstDay - 1);
    NSInteger column = 0;
    if(tempDay % 7 == 0)
    {
        column = tempDay / 7;
    }
    else
    {
        column = tempDay / 7 + 1;
    }
    
    NSInteger i = 0;
    NSInteger j = 0;
    components.day = 0;
    for(i = 0;i < column;i++)
    {
        for(j = 0;j < 7;j++)
        {
            if(i == 0 && j < firstDay - 1)
            {
                MSSCalendarModel *calendarItem = [[MSSCalendarModel alloc]init];
                calendarItem.year = 0;
                calendarItem.month = 0;
                calendarItem.day = 0;
                calendarItem.chineseCalendar = @"";
                calendarItem.holiday = @"";
                calendarItem.week = -1;
                calendarItem.dateInterval = -1;
                [resultArray addObject:calendarItem];
                continue;
            }
            components.day += 1;
            if(components.day == tatalDay + 1)
            {
                i = column;// 结束外层循环
                break;
            }
            MSSCalendarModel *calendarItem = [[MSSCalendarModel alloc]init];
            calendarItem.year = components.year;
            calendarItem.month = components.month;
            calendarItem.day = components.day;
            calendarItem.week = j;
            NSDate *date = [self componentsToDate:components];
            // 时间戳
            calendarItem.dateInterval = [self dateToInterval:date];
            if(_startDate == calendarItem.dateInterval)
            {
                _startIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            }
            [self setChineseCalendarAndHolidayWithDate:components date:date calendarItem:calendarItem];
            
            [resultArray addObject:calendarItem];
        }
    }
    return resultArray;
}

- (NSArray *)getCalendarDataSoruceWithMinNum:(NSInteger )minNum MaxNum:(NSInteger )maxNum startDate:(NSInteger )startDate endDate:(NSInteger )endDate andDataArray:(NSArray *)dataArray{
    
    NSMutableArray *daArr = [NSMutableArray array];
    [daArr addObjectsFromArray:dataArray];
//    int index = 0;
//    for (int i = 0; i < dataArray.count; i++) {
//        MSSCalendarHeaderModel *headerItem = daArr[i];
//        MSSCalendarModel *first = headerItem.calendarItemArray.firstObject;
//        MSSCalendarModel *last  = headerItem.calendarItemArray.lastObject;
//        if (startDate >= first.dateInterval && startDate <= last.dateInterval) {
//            index = i;
//        }
//    }
    if (startDate > 0) {
        for (int i = 0; i < dataArray.count; i++) {
            MSSCalendarHeaderModel *headerItem = daArr[i];
            for (int j = 0; j < headerItem.calendarItemArray.count; j++) {
                
                MSSCalendarModel *model = headerItem.calendarItemArray[j];
                
                if (model.dateInterval == startDate) {
                    
                }
                if(model.dateInterval >= startDate + minNum*24*3600 && model.dateInterval <= startDate + maxNum*24*3600){
                    model.middleSelect = YES;
                    model.userInteractionEnabled = YES;
                    
                }else{
                    model.userInteractionEnabled = NO;
                }
            }
        }
    }

    if (endDate > 0  || startDate == 0) {
        for (int i = 0; i < dataArray.count; i++) {
            MSSCalendarHeaderModel *headerItem = daArr[i];
            for (int j = 0; j < headerItem.calendarItemArray.count; j++) {
                
                MSSCalendarModel *model = headerItem.calendarItemArray[j];
                if ([model.price floatValue] > 0) {
                    model.userInteractionEnabled = YES;
                    model.middleSelect = NO;
                }
            }
        }
    }


    
//    int  selectedStart = 0;
//    NSInteger  secSelStart = 0; // minNum超出了
//    NSInteger  midSeleNum = 0;
//    for (int i = index; i < dataArray.count; i++) {
//        MSSCalendarHeaderModel *headerItem = daArr[i];
//
//        for (int j = 0; j < headerItem.calendarItemArray.count; j++) {
//            MSSCalendarModel *model = headerItem.calendarItemArray[j];
//            if (model.dateInterval == startDate) {
//                // 找到了点击的开始时间
//                selectedStart = j;
//            }
//
//            if (selectedStart + maxNum < headerItem.calendarItemArray.count -1){
//                if (j > selectedStart + minNum) {
//                    MSSCalendarModel *model = headerItem.calendarItemArray[j];
//                    model.middleSelect = YES;
//                }
//                if (j > selectedStart + maxNum) {
//                    MSSCalendarModel *model = headerItem.calendarItemArray[j];
//                    model.middleSelect = NO;
//                }
//                midSeleNum = maxNum - minNum;
//                break;
//            }else if (selectedStart + minNum < headerItem.calendarItemArray.count - 1) {
//                if (j > selectedStart + minNum) {
//                    MSSCalendarModel *model = headerItem.calendarItemArray[j];
//                    model.middleSelect = YES;
//                }
//                midSeleNum = headerItem.calendarItemArray.count - selectedStart - minNum -1;
//
//            }else if (selectedStart + minNum >= headerItem.calendarItemArray.count){
//                midSeleNum  = 0;
//                secSelStart = headerItem.calendarItemArray.count - selectedStart - 1;
//            }
//
//        }
//        if(midSeleNum == maxNum - minNum){
//            break;
//        }
//    }
    
    return daArr;
    
}

- (NSArray *)getJYCCalendarDataSoruceWithLimitMonth:(NSInteger)limitMonth type:(MSSCalendarViewControllerType)type calendarType:(MSSCalendarWithUserType)calendarType priceArray:(NSArray *_Nonnull)priceArray{
    
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSMutableArray *priceMuArr = [NSMutableArray arrayWithArray:priceArray];
    
    NSDateComponents *components = [self dateToComponents:_todayDate];
    components.day = 1;
    if(type == MSSCalendarViewControllerNextType)
    {
        components.month -= 1;
    }
    else if(type == MSSCalendarViewControllerLastType)
    {
        components.month -= limitMonth;
    }
    else
    {
        components.month -= (limitMonth + 1) / 2;
    }
    NSInteger i = 0;
    for(i = 0;i < limitMonth;i++)
    {
        components.month++;
        MSSCalendarHeaderModel *headerItem = [[MSSCalendarHeaderModel alloc]init];
        NSDate *date = [self componentsToDate:components];
        [_dateFormatter setDateFormat: @"yyyy年MM月"];
        NSString *dateString = [_dateFormatter stringFromDate:date];
        headerItem.headerText = dateString;
        
        // 价格
        NSString *MMyue = [dateString substringWithRange:NSMakeRange(5, 2)];
        NSMutableArray *priArr = [NSMutableArray array];
        for (NSDictionary *dic in priceMuArr) {
            //        if (calendarType == MSSCalendarSecnicType) {
            //            ti = [dic objectForKey:@"departDate"];
            //        }else if (calendarType == MSSCalendarAplaceType){
            //            ti = [dic objectForKey:@"day"];
            //        }
            NSString *da = [dic objectForKey:@"date"];
            if (da.length > 7) {
                NSString *mm = [da substringWithRange:NSMakeRange(5, 2)];
                if (MMyue == mm) {
                    [priArr addObject:dic];
                }
            }
        }
        [priceMuArr removeObjectsInArray:priArr];
        
        
        
        headerItem.calendarItemArray = [self getCalendarItemArrayWithDate:date section:i calendarType:calendarType withPriceArray:priArr];
        [resultArray addObject:headerItem];
        
        if (calendarType == MSSCalendarSecnicType || calendarType == MSSCalendarAplaceType || calendarType == MSSCalendarActivityType) {
            if (priceMuArr.count <= 0) {
                break;
            }
        }
    }
    return resultArray;
}

// 得到每一天的数据源
- (NSArray *)getCalendarItemArrayWithDate:(NSDate *)date section:(NSInteger)section calendarType:(MSSCalendarWithUserType)calendarType withPriceArray:(NSMutableArray *)priceArray
{
    if (calendarType == MSSCalendarActivityType) {
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        NSInteger tatalDay = [self numberOfDaysInCurrentMonth:date];
        NSInteger firstDay = [self startDayOfWeek:date];
        
        NSDateComponents *components = [self dateToComponents:date];
        
        // 判断日历有多少列
        NSInteger tempDay = tatalDay + (firstDay - 1);
        NSInteger column = 0;
        if(tempDay % 7 == 0)
        {
            column = tempDay / 7;
        }
        else
        {
            column = tempDay / 7 + 1;
        }
        
        NSInteger i = 0;
        NSInteger j = 0;
        components.day = 0;
        NSInteger indexB = 1000;
        
        for(i = 0;i < column;i++)
        {
            for(j = 0;j < 7;j++)
            {
                if(i == 0 && j < firstDay - 1)
                {
                    MSSCalendarModel *calendarItem = [[MSSCalendarModel alloc]init];
                    calendarItem.year = 0;
                    calendarItem.month = 0;
                    calendarItem.day = 0;
                    calendarItem.chineseCalendar = @"";
                    calendarItem.holiday = @"";
                    calendarItem.week = -1;
                    calendarItem.dateInterval = -1;
                    [resultArray addObject:calendarItem];
                    continue;
                }
                components.day += 1;
                if(components.day == tatalDay + 1)
                {
                    i = column;// 结束外层循环
                    break;
                }
                MSSCalendarModel *calendarItem = [[MSSCalendarModel alloc]init];
                calendarItem.year = components.year;
                calendarItem.month = components.month;
                calendarItem.day = components.day;
                calendarItem.week = j;
                NSDate *date = [self componentsToDate:components];
                
//                // 时间戳
                NSInteger dateInterVal = [self dateToInterval:date];
                calendarItem.dateInterval = dateInterVal;
                
                NSInteger priceTime = 0;
                
                for (NSDictionary *dic in priceArray) {
                    
                    //        if (calendarType == MSSCalendarSecnicType) {
                    //            ti = [dic objectForKey:@"departDate"];
                    //        }else if (calendarType == MSSCalendarAplaceType){
                    //            ti = [dic objectForKey:@"day"];
                    //        }
                    NSString *ti = [dic objectForKey:@"date"];
                    if (ti.length > 0) {
                        priceTime = [self dateToInterval:[self dateFromString:ti]];
                    }
                    if (dateInterVal == priceTime) {
                        calendarItem.price = [dic objectForKey:@"price"];
                        calendarItem.userInteractionEnabled = YES;
                        break;
                    }
                }
                
//                if (priceTime == dateInterVal) {
//                    indexB = 0;
//                }
//                if (indexB < priceArray.count) {
//                    NSDictionary *dic = priceArray[indexB];
//                    //                if (calendarType == MSSCalendarSecnicType) {
//                    //                    calendarItem.price = [dic objectForKey:@"salePrice"];
//                    //                }else if (calendarType == MSSCalendarAplaceType){
//                    //                    calendarItem.userPrice = [dic objectForKey:@"userprice"];
//                    //                    calendarItem.price = [dic objectForKey:@"webprice"];
//                    //                }
//                    calendarItem.price = [dic objectForKey:@"price"];
//                    calendarItem.userInteractionEnabled = YES;
//                }
//                indexB++;
                
                
                if(_startDate == calendarItem.dateInterval)
                {
                    _startIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                }
                [self setChineseCalendarAndHolidayWithDate:components date:date calendarItem:calendarItem];
                
                [resultArray addObject:calendarItem];
            }
        }
        return resultArray;
        
    }else{
        
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        NSInteger tatalDay = [self numberOfDaysInCurrentMonth:date];
        NSInteger firstDay = [self startDayOfWeek:date];
        
        NSInteger priceTime = 0;
        if (priceArray.count > 0) {
            NSDictionary *dic = priceArray[0];
            //        if (calendarType == MSSCalendarSecnicType) {
            //            ti = [dic objectForKey:@"departDate"];
            //        }else if (calendarType == MSSCalendarAplaceType){
            //            ti = [dic objectForKey:@"day"];
            //        }
            NSString *ti = [dic objectForKey:@"date"];
            if (ti.length > 0) {
                priceTime = [self dateToInterval:[self dateFromString:ti]];
            }
        }
        
        
        NSDateComponents *components = [self dateToComponents:date];
        
        // 判断日历有多少列
        NSInteger tempDay = tatalDay + (firstDay - 1);
        NSInteger column = 0;
        if(tempDay % 7 == 0)
        {
            column = tempDay / 7;
        }
        else
        {
            column = tempDay / 7 + 1;
        }
        
        NSInteger i = 0;
        NSInteger j = 0;
        components.day = 0;
        NSInteger indexB = 1000;
        
        for(i = 0;i < column;i++)
        {
            for(j = 0;j < 7;j++)
            {
                if(i == 0 && j < firstDay - 1)
                {
                    MSSCalendarModel *calendarItem = [[MSSCalendarModel alloc]init];
                    calendarItem.year = 0;
                    calendarItem.month = 0;
                    calendarItem.day = 0;
                    calendarItem.chineseCalendar = @"";
                    calendarItem.holiday = @"";
                    calendarItem.week = -1;
                    calendarItem.dateInterval = -1;
                    [resultArray addObject:calendarItem];
                    continue;
                }
                components.day += 1;
                if(components.day == tatalDay + 1)
                {
                    i = column;// 结束外层循环
                    break;
                }
                MSSCalendarModel *calendarItem = [[MSSCalendarModel alloc]init];
                calendarItem.year = components.year;
                calendarItem.month = components.month;
                calendarItem.day = components.day;
                calendarItem.week = j;
                NSDate *date = [self componentsToDate:components];
                
                // 时间戳
                NSInteger dateInterVal = [self dateToInterval:date];
                calendarItem.dateInterval = dateInterVal;
                if (priceTime == dateInterVal) {
                    indexB = 0;
                }
                if (indexB < priceArray.count) {
                    NSDictionary *dic = priceArray[indexB];
                    //                if (calendarType == MSSCalendarSecnicType) {
                    //                    calendarItem.price = [dic objectForKey:@"salePrice"];
                    //                }else if (calendarType == MSSCalendarAplaceType){
                    //                    calendarItem.userPrice = [dic objectForKey:@"userprice"];
                    //                    calendarItem.price = [dic objectForKey:@"webprice"];
                    //                }
                    calendarItem.price = [dic objectForKey:@"price"];
                    calendarItem.userInteractionEnabled = YES;
                }
                indexB++;
                
                
                if(_startDate == calendarItem.dateInterval)
                {
                    _startIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                }
                [self setChineseCalendarAndHolidayWithDate:components date:date calendarItem:calendarItem];
                
                [resultArray addObject:calendarItem];
            }
        }
        return resultArray;
    }
   
}



// 一个月有多少天
- (NSUInteger)numberOfDaysInCurrentMonth:(NSDate *)date
{
    return [_greCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

// 确定这个月的第一天是星期几
- (NSUInteger)startDayOfWeek:(NSDate *)date
{
    NSDate *startDate = nil;
    BOOL result = [_greCalendar rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:NULL forDate:date];
    if(result)
    {
        return [_greCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:startDate];
    }
    return 0;
}

// 日期转时间戳
- (NSInteger)dateToInterval:(NSDate *)date
{
    return (long)[date timeIntervalSince1970];
}

#pragma mark 农历和节假日
- (void)setChineseCalendarAndHolidayWithDate:(NSDateComponents *)components date:(NSDate *)date calendarItem:(MSSCalendarModel *)calendarItem
{
    if (components.year == _todayCompontents.year && components.month == _todayCompontents.month && components.day == _todayCompontents.day)
    {
        calendarItem.type = MSSCalendarTodayType;
        calendarItem.holiday = @"今天";
    }
    else
    {
        if([date compare:_todayDate] == 1)
        {
            calendarItem.type = MSSCalendarNextType;
        }
        else
        {
            calendarItem.type = MSSCalendarLastType;
        }
    }
//    if (components.year == _todayCompontents.year && components.month == _todayCompontents.month && components.day == _todayCompontents.day - 1)
//    {
//        calendarItem.holiday = @"昨天";
//    }
//    else if (components.year == _todayCompontents.year && components.month == _todayCompontents.month && components.day == _todayCompontents.day + 1)
//    {
//        calendarItem.holiday = @"明天";
//    }
    
    if(components.month == 1 && components.day == 1)
    {
        calendarItem.holiday = @"元旦";
    }
    else if(components.month == 2 && components.day == 14)
    {
        calendarItem.holiday = @"情人节";
    }
    else if(components.month == 3 && components.day == 8)
    {
        calendarItem.holiday = @"妇女节";
    }
    else if(components.month == 4 && components.day == 1)
    {
        calendarItem.holiday = @"愚人节";
    }
    else if(components.month == 4 && (components.day == 4 || components.day == 5 || components.day == 6))
    {
        if([_chineseCalendarManager isQingMingholidayWithYear:components.year month:components.month day:components.day])
        {
            calendarItem.holiday = @"清明节";
        }
    }
    else if(components.month == 5 && components.day == 1)
    {
        calendarItem.holiday = @"劳动节";
    }
    else if(components.month == 5 && components.day == 4)
    {
        calendarItem.holiday = @"青年节";
    }
    else if(components.month == 6 && components.day == 1)
    {
        calendarItem.holiday = @"儿童节";
    }
    else if(components.month == 8 && components.day == 1)
    {
        calendarItem.holiday = @"建军节";
    }
    else if(components.month == 9 && components.day == 10)
    {
        calendarItem.holiday = @"教师节";
    }
    else if(components.month == 10 && components.day == 1)
    {
        calendarItem.holiday = @"国庆节";
    }
    else if(components.month == 1 && components.day == 1)
    {
        calendarItem.holiday = @"元旦";
    }
    else if(components.month == 11 && components.day == 11)
    {
        calendarItem.holiday = @"光棍节";
    }
    else if(components.month == 12 && components.day == 25)
    {
        calendarItem.holiday = @"圣诞节";
    }
    // 计算农历耗性能
    if(_showChineseCalendar || _showChineseHoliday)
    {
         [_chineseCalendarManager getChineseCalendarWithDate:date calendarItem:calendarItem];
    }
}

#pragma mark NSDate和NSCompontents转换
- (NSDateComponents *)dateToComponents:(NSDate *)date
{
    NSDateComponents *components = [_greCalendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    return components;
}

- (NSDate *)componentsToDate:(NSDateComponents *)components
{
    // 不区分时分秒
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *date = [_greCalendar dateFromComponents:components];
    return date;
}

- (NSDate *)dateFromString:(NSString *)dateString
{
    
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //
    //    //    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    //    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [self.formatter dateFromString:dateString];
    
    return destDate;
    
}

- (NSDateFormatter *)formatter {
    
    if(! _formatter) {
        
        _formatter = [[NSDateFormatter alloc] init];
        
        _formatter.dateFormat = @"yyyy-MM-dd";// twitter date format
        
    }
    
    return _formatter;
    
}


@end
