//
//  JYCActivityLineController.h
//  MSSCalendar
//
//  Created by 蒋永昌 on 2018/9/4.
//  Copyright © 2018年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSCalendarDefine.h"

// 适用于 活动（价格日历）（价格日历特点是时间价格不连续，发团时间不连续）
@protocol JYCActivityCalendarDelegate <NSObject>
//- (void)calendarActivityClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate;
- (void)calendarActivityClickWithStartDate:(NSInteger)startDate;
@end

@interface JYCActivityLineController : UIViewController
@property (nonatomic,weak)id<JYCActivityCalendarDelegate> delegate;
@property (nonatomic,assign)NSInteger startDate;// 选中开始时间
@property (nonatomic,assign)NSInteger endDate;// 选中结束时间

@property (nonatomic,assign)NSInteger limitMonth;// 显示几个月的数据
@property (nonatomic,assign)MSSCalendarViewControllerType type;
@property (nonatomic,assign)MSSCalendarWithUserType  calendarType;
@property (nonatomic,assign)BOOL afterTodayCanTouch;// 今天之后的日期是否可以点击
@property (nonatomic,assign)BOOL beforeTodayCanTouch;// 今天之前的日期是否可以点击

/*以下两个属性设为YES,计算中国农历非常耗性能（在5S加载15年以内的数据没有影响）*/
@property (nonatomic,assign)BOOL showChineseHoliday;// 是否展示农历节日
@property (nonatomic,assign)BOOL showChineseCalendar;// 是否展示农历
@property (nonatomic,assign)BOOL showHolidayDifferentColor;// 节假日是否宣示不同的颜色

@property (nonatomic,assign)BOOL showAlertView;// 是否显示提示弹窗

@property (nonatomic,strong)NSArray *priceArray;
@end
