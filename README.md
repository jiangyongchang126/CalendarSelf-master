# CalendarSelf-master
# 说明
// 选择点击颜色  
#define SelectedColor [UIColor cyanColor]  
// 被选中间颜色  
#define SelMiddleColor [UIColor greenColor]  
// DateLabel默认文字颜色  
#define MSS_TextColor [UIColor blackColor]  
// DateLabel选中时的背景色  
#define MSS_SelectBackgroundColor MSS_UTILS_COLORRGB(29, 154, 72)  
// DateLabel选中后文字颜色  
#define MSS_SelectTextColor [UIColor whiteColor]  
// SubLabel文字颜色  
#define MSS_SelectSubLabelTextColor MSS_UTILS_COLORRGB(29, 154, 180);  
// SubLabel选中开始文字  
#define MSS_SelectBeginText @"开始"  
// SubLabel选中结束文字  
#define MSS_SelectEndText @"结束"  
// 节日颜色  
#define MSS_HolidayTextColor [UIColor purpleColor]  
// 周末颜色  
#define MSS_WeekEndTextColor [UIColor redColor]  
// 不可点击文字颜色  
#define MSS_TouchUnableTextColor MSS_UTILS_COLORRGB(150, 150, 150)  
// 周视图高度  
#define MSS_WeekViewHeight 60  
// headerView线颜色  
#define MSS_HeaderViewLineColor [UIColor lightGrayColor]  
// headerView文字颜色  
#define MSS_HeaderViewTextColor [UIColor blackColor]  
// headerView高度  
#define MSS_HeaderViewHeight 50  
// 弹出层文字颜色  
#define MSS_CalendarPopViewTextColor [UIColor whiteColor]  
// 弹出层背景颜色  
#define MSS_CalendarPopViewBackgroundColor [UIColor blackColor]  
  
typedef NS_ENUM(NSInteger, MSSCalendarViewControllerType)  
{  
    MSSCalendarViewControllerLastType = 0,// 只显示当前月之前  
    MSSCalendarViewControllerMiddleType,// 前后各显示一半  
    MSSCalendarViewControllerNextType// 只显示当前月之后  
};  
typedef NS_ENUM(NSInteger, MSSCalendarWithUserType)  
{  
    MSSCalendarHotelType = 0,  // 酒店   入住 --- 离店  
    MSSCalendarTrainType,      // 火车票，飞机票，单选无价格  
    MSSCalendarAplaceType,     // 基地   价格  
    MSSCalendarSecnicType,     // 景点   价格  
    MSSCalendarPlaneType,      // 机票  
    MSSCalendarActivityType    // 活动，线路  
};  
  
#Example
```Objective-c
MSSCalendarViewController *cvc = [[MSSCalendarViewController alloc]init];
cvc.limitMonth = 12;// 显示几个月的日历 价格日历中没有价格的去掉了
/*
MSSCalendarViewControllerLastType 只显示当前月之前
MSSCalendarViewControllerMiddleType 前后各显示一半
MSSCalendarViewControllerNextType 只显示当前月之后
*/
cvc.type = MSSCalendarViewControllerLastType;
cvc.beforeTodayCanTouch = YES;// 今天之后的日期是否可以点击
cvc.afterTodayCanTouch = NO;// 今天之前的日期是否可以点击
cvc.startDate = _startDate;// 选中开始时间
cvc.endDate = _endDate;// 选中结束时间
/*以下两个属性设为YES,计算中国农历非常耗性能（在5s加载15年以内的数据没有影响）*/
cvc.showChineseHoliday = YES;// 是否展示农历节日
cvc.showChineseCalendar = YES;// 是否展示农历
cvc.showHolidayDifferentColor = YES;// 节假日是否显示不同的颜色
cvc.showAlertView = YES;// 是否显示提示弹窗
cvc.delegate = self;
[self presentViewController:cvc animated:YES completion:nil];
```

