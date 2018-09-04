//
//  MSSCalendarManager.h
//  MSSCalendar
//
//  Created by 于威 on 16/4/3.
//  Copyright © 2016年 于威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MSSCalendarDefine.h"
//#import "MSSCalendarViewController.h"
//#import "JYCAplaceCalendarController.h"

@interface MSSCalendarManager : NSObject

@property (nonatomic,strong)NSIndexPath *startIndexPath;

- (instancetype)initWithShowChineseHoliday:(BOOL)showChineseHoliday showChineseCalendar:(BOOL)showChineseCalendar startDate:(NSInteger)startDate;
// 获取数据源
- (NSArray *)getCalendarDataSoruceWithLimitMonth:(NSInteger)limitMonth type:(MSSCalendarViewControllerType)type;
- (NSArray *)getCalendarDataSoruceWithMinNum:(NSInteger )minNum MaxNum:(NSInteger )maxNum startDate:(NSInteger )startDate endDate:(NSInteger )endDate andDataArray:(NSArray *)dataArray;
- (NSArray *)getJYCCalendarDataSoruceWithLimitMonth:(NSInteger)limitMonth type:(MSSCalendarViewControllerType)type calendarType:(MSSCalendarWithUserType)calendarType priceArray:(NSArray *_Nonnull)priceArray;



@end
