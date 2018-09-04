//
//  ViewController.m
//  MSSCalendar
//
//  Created by 于威 on 16/4/3.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "ViewController.h"
#import "MSSCalendarViewController.h"
#import "JYCSecnicFlightViewController.h"
#import "JYCAplaceCalendarController.h"
#import "JYCActivityLineController.h"
#import "MSSCalendarDefine.h"

@interface ViewController ()<MSSCalendarViewControllerDelegate,JYCSecnicFlightCalendarDelegate,JYCAplaceCalendarDelegate,JYCActivityCalendarDelegate>
@property (nonatomic,strong)UILabel *startLabel;
@property (nonatomic,strong)UILabel *endLabel;
@property (nonatomic,assign)NSInteger startDate;
@property (nonatomic,assign)NSInteger endDate;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((MSS_SCREEN_WIDTH - 110) / 2 - 80, 80, 110, 50);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    btn.layer.cornerRadius = 5.0f;
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [btn setTitle:@"打开日历" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(calendarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake((MSS_SCREEN_WIDTH - 110) / 2 + 80, 80, 110, 50);
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    btn2.layer.cornerRadius = 5.0f;
    btn2.layer.borderWidth = 1.0f;
    btn2.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [btn2 setTitle:@"价格日历" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2calendarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];

    
    _startLabel = [[UILabel alloc]init];
    _startLabel.backgroundColor = MSS_SelectBackgroundColor;
    _startLabel.textColor = MSS_SelectTextColor;
    _startLabel.textAlignment = NSTextAlignmentCenter;
    _startLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _startLabel.frame = CGRectMake(20, CGRectGetMaxY(btn.frame) + 20, MSS_SCREEN_WIDTH - 20 * 2, 50);
    _startLabel.text = @"开始日期";
    [self.view addSubview:_startLabel];
    
    _endLabel = [[UILabel alloc]init];
    _endLabel.backgroundColor = MSS_SelectBackgroundColor;
    _endLabel.textColor = MSS_SelectTextColor;
    _endLabel.textAlignment = NSTextAlignmentCenter;
    _endLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _endLabel.frame = CGRectMake(20, CGRectGetMaxY(_startLabel.frame) + 20, MSS_SCREEN_WIDTH - 20 * 2, 50);
    _endLabel.text = @"开始日期";
    _endLabel.text = @"结束日期";
    [self.view addSubview:_endLabel];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake((MSS_SCREEN_WIDTH - 110)/2, CGRectGetMaxY(_endLabel.frame) + 50, 110, 50);
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    btn3.layer.cornerRadius = 5.0f;
    btn3.layer.borderWidth = 1.0f;
    btn3.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [btn3 setTitle:@"基地日历" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btn3calendarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake((MSS_SCREEN_WIDTH - 110)/2, CGRectGetMaxY(_endLabel.frame) + 50 + 80, 110, 50);
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    btn4.layer.cornerRadius = 5.0f;
    btn4.layer.borderWidth = 1.0f;
    btn4.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [btn4 setTitle:@"线路日历" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(btn4calendarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];


}

- (void)calendarClick:(UIButton *)btn
{
    MSSCalendarViewController *cvc = [[MSSCalendarViewController alloc]init];
    cvc.limitMonth = 12;// 显示几个月的日历
    /*
     MSSCalendarViewControllerLastType 只显示当前月之前
     MSSCalendarViewControllerMiddleType 前后各显示一半
     MSSCalendarViewControllerNextType 只显示当前月之后
     */
    cvc.type = MSSCalendarViewControllerNextType;
    cvc.calendarType = MSSCalendarHotelType;
    cvc.beforeTodayCanTouch = NO;// 今天之后的日期是否可以点击
    cvc.afterTodayCanTouch = YES;// 今天之前的日期是否可以点击
//    cvc.startDate = _startDate;// 选中开始时间
//    cvc.endDate = _endDate;// 选中结束时间
    /*以下两个属性设为YES,计算中国农历非常耗性能（在5s加载15年以内的数据没有影响）*/
    cvc.showChineseHoliday = YES;// 是否展示农历节日
    cvc.showChineseCalendar = YES;// 是否展示农历
    cvc.showHolidayDifferentColor = YES;// 节假日是否显示不同的颜色
    cvc.showAlertView = YES;// 是否显示提示弹窗
    cvc.delegate = self;
    [self presentViewController:cvc animated:YES completion:nil];
}

- (void)calendarViewConfirmClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate
{
    _startDate = startDate;
    _endDate = endDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
    NSString *endDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_endDate]];
    _startLabel.text = [NSString stringWithFormat:@"开始日期:%@",startDateString];
    _endLabel.text = [NSString stringWithFormat:@"结束日期:%@",endDateString];
}

- (void)calendarViewConFirmClickWithStartDate:(NSInteger)startDate{
    
    _startDate = startDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
    _startLabel.text = [NSString stringWithFormat:@"开始日期:%@",startDateString];

}


- (void)btn2calendarClick:(UIButton *)sender{
    
     JYCSecnicFlightViewController *cvc = [[JYCSecnicFlightViewController alloc]init];
    cvc.limitMonth = 12;// 显示几个月的日历
    /*
     MSSCalendarViewControllerLastType 只显示当前月之前
     MSSCalendarViewControllerMiddleType 前后各显示一半
     MSSCalendarViewControllerNextType 只显示当前月之后
     */
    cvc.type = MSSCalendarViewControllerNextType;
    cvc.priceArray = @[@{@"date":@"2018-09-07",@"price":@"237"},
                                      @{@"date":@"2018-09-08",@"price":@"238"},
                                      @{@"date":@"2018-09-09",@"price":@"239"},
                                      @{@"date":@"2018-09-10",@"price":@"230"},
                                      @{@"date":@"2018-09-11",@"price":@"230"},
                                      @{@"date":@"2018-09-12",@"price":@"293"},
                                      @{@"date":@"2018-09-13",@"price":@"273"},
                                      @{@"date":@"2018-09-14",@"price":@"2630"},
                                      @{@"date":@"2018-09-15",@"price":@"253"},
                                      @{@"date":@"2018-09-16",@"price":@"233"},
                                      @{@"date":@"2018-09-17",@"price":@"213"},
                                      @{@"date":@"2018-09-18",@"price":@"230"},
                                      @{@"date":@"2018-09-19",@"price":@"923"},
                                      @{@"date":@"2018-09-20",@"price":@"113"},
                                      @{@"date":@"2018-09-21",@"price":@"222"},
                                      @{@"date":@"2018-09-22",@"price":@"333"},
                                      @{@"date":@"2018-09-23",@"price":@"244"},
                                      @{@"date":@"2018-09-24",@"price":@"355"},
                                      @{@"date":@"2018-09-25",@"price":@"266"},
                                      @{@"date":@"2018-09-26",@"price":@"773"},
                                      @{@"date":@"2018-09-27",@"price":@"278"},
                                      @{@"date":@"2018-09-28",@"price":@"397"},
                                      @{@"date":@"2018-09-29",@"price":@"0"},
                                      @{@"date":@"2018-09-30",@"price":@"2"},
                                      
                                      @{@"date":@"2018-10-01",@"price":@"231"},
                                      @{@"date":@"2018-10-02",@"price":@"232"},
                                      @{@"date":@"2018-10-03",@"price":@"233"},
                                      @{@"date":@"2018-10-04",@"price":@"234"},
                                      @{@"date":@"2018-10-05",@"price":@"235"},
                                      @{@"date":@"2018-10-06",@"price":@"236"},
                                      @{@"date":@"2018-10-07",@"price":@"237"},
                                      @{@"date":@"2018-10-08",@"price":@"238"},
                                      @{@"date":@"2018-10-09",@"price":@"239"},
                                      @{@"date":@"2018-10-10",@"price":@"230"},
                                      @{@"date":@"2018-10-11",@"price":@"230"},
                                      @{@"date":@"2018-10-12",@"price":@"293"},
                                      @{@"date":@"2018-10-13",@"price":@"273"},
                                      @{@"date":@"2018-10-14",@"price":@"2630"},
                                      @{@"date":@"2018-10-15",@"price":@"253"},
                                      @{@"date":@"2018-10-16",@"price":@"233"},
                                      @{@"date":@"2018-10-17",@"price":@"213"},
                                      @{@"date":@"2018-10-18",@"price":@"230"},
                                      @{@"date":@"2018-10-19",@"price":@"923"},
                                      @{@"date":@"2018-10-20",@"price":@"113"},
                                      @{@"date":@"2018-10-21",@"price":@"222"},
                                      @{@"date":@"2018-10-22",@"price":@"333"},
                                      @{@"date":@"2018-10-23",@"price":@"244"},
                                      @{@"date":@"2018-10-24",@"price":@"355"},
                                      @{@"date":@"2018-10-25",@"price":@"266"},
                                      @{@"date":@"2018-10-26",@"price":@"773"},
                                      @{@"date":@"2018-10-27",@"price":@"278"},
                                      @{@"date":@"2018-10-28",@"price":@"397"},
                                      @{@"date":@"2018-10-29",@"price":@"244"},
                                      @{@"date":@"2018-10-30",@"price":@"2"},
                                      @{@"date":@"2018-10-31",@"price":@"231"},

                                      @{@"date":@"2018-11-01",@"price":@"231"},
                                      @{@"date":@"2018-11-02",@"price":@"232"},
                                      @{@"date":@"2018-11-03",@"price":@"233"},
                                      @{@"date":@"2018-11-04",@"price":@"234"},
                                      @{@"date":@"2018-11-05",@"price":@"235"},
                                      @{@"date":@"2018-11-06",@"price":@"236"},
                                      @{@"date":@"2018-11-07",@"price":@"237"},
                                      @{@"date":@"2018-11-08",@"price":@"238"},

                                      @{@"date":@"2018-12-02",@"price":@"232"},
                                      @{@"date":@"2018-12-03",@"price":@"233"},
                                      @{@"date":@"2018-12-04",@"price":@"234"},
                                      @{@"date":@"2018-12-05",@"price":@"235"},
                                      @{@"date":@"2018-12-06",@"price":@"236"},
                                      ];
    cvc.calendarType = MSSCalendarSecnicType;
    cvc.beforeTodayCanTouch = NO;// 今天之后的日期是否可以点击
    cvc.afterTodayCanTouch = YES;// 今天之前的日期是否可以点击
//    cvc.startDate = _startDate;// 选中开始时间
//    cvc.endDate = _endDate;// 选中结束时间
    /*以下两个属性设为YES,计算中国农历非常耗性能（在5s加载15年以内的数据没有影响）*/
    cvc.showChineseHoliday = YES;// 是否展示农历节日
    cvc.showChineseCalendar = NO;// 是否展示农历
    cvc.showHolidayDifferentColor = YES;// 节假日是否显示不同的颜色
    cvc.showAlertView = NO;// 是否显示提示弹窗
    cvc.delegate = self;
    [self presentViewController:cvc animated:YES completion:nil];
}


- (void)calendarClickWithStartDate:(NSInteger)startDate{
    
    _startDate = startDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
    _startLabel.text = [NSString stringWithFormat:@"开始日期:%@",startDateString];
    

}


- (void)btn3calendarClick:(UIButton *)sender{
    
    JYCAplaceCalendarController *cvc = [[JYCAplaceCalendarController alloc]init];
    cvc.limitMonth = 12;// 显示几个月的日历
    /*
     MSSCalendarViewControllerLastType 只显示当前月之前
     MSSCalendarViewControllerMiddleType 前后各显示一半
     MSSCalendarViewControllerNextType 只显示当前月之后
     */
    cvc.type = MSSCalendarViewControllerNextType;
    cvc.priceArray = @[@{@"date":@"2018-09-07",@"price":@"237"},
                       @{@"date":@"2018-09-08",@"price":@"238"},
                       @{@"date":@"2018-09-09",@"price":@"239"},
                       @{@"date":@"2018-09-10",@"price":@"230"},
                       @{@"date":@"2018-09-11",@"price":@"230"},
                       @{@"date":@"2018-09-12",@"price":@"293"},
                       @{@"date":@"2018-09-13",@"price":@"273"},
                       @{@"date":@"2018-09-14",@"price":@"2630"},
                       @{@"date":@"2018-09-15",@"price":@"253"},
                       @{@"date":@"2018-09-16",@"price":@"233"},
                       @{@"date":@"2018-09-17",@"price":@"213"},
                       @{@"date":@"2018-09-18",@"price":@"230"},
                       @{@"date":@"2018-09-19",@"price":@"923"},
                       @{@"date":@"2018-09-20",@"price":@"113"},
                       @{@"date":@"2018-09-21",@"price":@"222"},
                       @{@"date":@"2018-09-22",@"price":@"333"},
                       @{@"date":@"2018-09-23",@"price":@"244"},
                       @{@"date":@"2018-09-24",@"price":@"355"},
                       @{@"date":@"2018-09-25",@"price":@"266"},
                       @{@"date":@"2018-09-26",@"price":@"773"},
                       @{@"date":@"2018-09-27",@"price":@"278"},
                       @{@"date":@"2018-09-28",@"price":@"397"},
                       @{@"date":@"2018-09-29",@"price":@"34"},
                       @{@"date":@"2018-09-30",@"price":@"2"},
                       
                       @{@"date":@"2018-10-01",@"price":@"231"},
                       @{@"date":@"2018-10-02",@"price":@"232"},
                       @{@"date":@"2018-10-03",@"price":@"233"},
                       @{@"date":@"2018-10-04",@"price":@"234"},
                       @{@"date":@"2018-10-05",@"price":@"235"},
                       @{@"date":@"2018-10-06",@"price":@"236"},
                       @{@"date":@"2018-10-07",@"price":@"237"},
                       @{@"date":@"2018-10-08",@"price":@"238"},
                       @{@"date":@"2018-10-09",@"price":@"239"},
                       @{@"date":@"2018-10-10",@"price":@"230"},
                       @{@"date":@"2018-10-11",@"price":@"230"},
                       @{@"date":@"2018-10-12",@"price":@"293"},
                       @{@"date":@"2018-10-13",@"price":@"273"},
                       @{@"date":@"2018-10-14",@"price":@"2630"},
                       @{@"date":@"2018-10-15",@"price":@"253"},
                       @{@"date":@"2018-10-16",@"price":@"233"},
                       @{@"date":@"2018-10-17",@"price":@"213"},
                       @{@"date":@"2018-10-18",@"price":@"230"},
                       @{@"date":@"2018-10-19",@"price":@"923"},
                       @{@"date":@"2018-10-20",@"price":@"113"},
                       @{@"date":@"2018-10-21",@"price":@"222"},
                       @{@"date":@"2018-10-22",@"price":@"333"},
                       @{@"date":@"2018-10-23",@"price":@"244"},
                       @{@"date":@"2018-10-24",@"price":@"355"},
                       @{@"date":@"2018-10-25",@"price":@"266"},
                       @{@"date":@"2018-10-26",@"price":@"773"},
                       @{@"date":@"2018-10-27",@"price":@"278"},
                       @{@"date":@"2018-10-28",@"price":@"397"},
                       @{@"date":@"2018-10-29",@"price":@"244"},
                       @{@"date":@"2018-10-30",@"price":@"2"},
                       @{@"date":@"2018-10-31",@"price":@"231"},
                       
                       @{@"date":@"2018-11-01",@"price":@"231"},
                       @{@"date":@"2018-11-02",@"price":@"232"},
                       @{@"date":@"2018-11-03",@"price":@"233"},
                       @{@"date":@"2018-11-04",@"price":@"234"},
                       @{@"date":@"2018-11-05",@"price":@"235"},
                       @{@"date":@"2018-11-06",@"price":@"236"},
                       @{@"date":@"2018-11-07",@"price":@"237"},
                       @{@"date":@"2018-11-08",@"price":@"238"},
                       @{@"date":@"2018-11-09",@"price":@"239"},
                       @{@"date":@"2018-11-10",@"price":@"230"},
                       @{@"date":@"2018-11-11",@"price":@"230"},
                       @{@"date":@"2018-11-12",@"price":@"293"},
                       @{@"date":@"2018-11-13",@"price":@"273"},
                       @{@"date":@"2018-11-14",@"price":@"2630"},
                       @{@"date":@"2018-11-15",@"price":@"253"},
                       @{@"date":@"2018-11-16",@"price":@"233"},
                       @{@"date":@"2018-11-17",@"price":@"213"},
                       @{@"date":@"2018-11-18",@"price":@"230"},
                       @{@"date":@"2018-11-19",@"price":@"923"},
                       @{@"date":@"2018-11-20",@"price":@"113"},
                       @{@"date":@"2018-11-21",@"price":@"222"},
                       @{@"date":@"2018-11-22",@"price":@"333"},
                       @{@"date":@"2018-11-23",@"price":@"244"},
                       @{@"date":@"2018-11-24",@"price":@"355"},
                       @{@"date":@"2018-11-25",@"price":@"266"},
                       @{@"date":@"2018-11-26",@"price":@"773"},
                       @{@"date":@"2018-11-27",@"price":@"278"},
                       @{@"date":@"2018-11-28",@"price":@"397"},
                       @{@"date":@"2018-11-29",@"price":@"244"},
                       @{@"date":@"2018-11-30",@"price":@"2"},
                       ];
    cvc.calendarType = MSSCalendarAplaceType;
    cvc.minNum = 8;
    cvc.maxNum = 30;
    cvc.beforeTodayCanTouch = NO;// 今天之后的日期是否可以点击
    cvc.afterTodayCanTouch = YES;// 今天之前的日期是否可以点击
//    cvc.startDate = _startDate;// 选中开始时间
//    cvc.endDate = _endDate;// 选中结束时间
    /*以下两个属性设为YES,计算中国农历非常耗性能（在5s加载15年以内的数据没有影响）*/
    cvc.showChineseHoliday = YES;// 是否展示农历节日
    cvc.showChineseCalendar = NO;// 是否展示农历
    cvc.showHolidayDifferentColor = YES;// 节假日是否显示不同的颜色
    cvc.showAlertView = YES;// 是否显示提示弹窗
    cvc.delegate = self;
    [self presentViewController:cvc animated:YES completion:nil];
}

- (void)calendarClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate{
    
    _startDate = startDate;
    _endDate = endDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
    NSString *endDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_endDate]];
    _startLabel.text = [NSString stringWithFormat:@"开始日期:%@",startDateString];
    _endLabel.text = [NSString stringWithFormat:@"结束日期:%@",endDateString];
}

- (void)btn4calendarClick:(UIButton *)sender{
    
    JYCActivityLineController *cvc = [[JYCActivityLineController alloc]init];
    cvc.limitMonth = 12;// 显示几个月的日历
    /*
     MSSCalendarViewControllerLastType 只显示当前月之前
     MSSCalendarViewControllerMiddleType 前后各显示一半
     MSSCalendarViewControllerNextType 只显示当前月之后
     */
    cvc.type = MSSCalendarViewControllerNextType;
    cvc.priceArray = @[@{@"date":@"2018-09-07",@"price":@"237"},
                       @{@"date":@"2018-09-08",@"price":@"238"},
                       @{@"date":@"2018-09-09",@"price":@"239"},
                       @{@"date":@"2018-09-10",@"price":@"230"},
                       @{@"date":@"2018-09-11",@"price":@"230"},
                       @{@"date":@"2018-09-12",@"price":@"293"},
                       @{@"date":@"2018-09-25",@"price":@"266"},
                       @{@"date":@"2018-09-26",@"price":@"773"},
                       @{@"date":@"2018-09-27",@"price":@"278"},
                       @{@"date":@"2018-09-28",@"price":@"397"},
                       @{@"date":@"2018-09-29",@"price":@"0"},
                       @{@"date":@"2018-09-30",@"price":@"2"},
                       
                       @{@"date":@"2018-10-01",@"price":@"231"},
                       @{@"date":@"2018-10-02",@"price":@"232"},
                       @{@"date":@"2018-10-05",@"price":@"235"},
                       @{@"date":@"2018-10-06",@"price":@"236"},
                       @{@"date":@"2018-10-07",@"price":@"237"},
                       @{@"date":@"2018-10-08",@"price":@"238"},
                       @{@"date":@"2018-10-09",@"price":@"239"},
                       @{@"date":@"2018-10-10",@"price":@"230"},
                       @{@"date":@"2018-10-11",@"price":@"230"},
                       @{@"date":@"2018-10-13",@"price":@"273"},
                       @{@"date":@"2018-10-14",@"price":@"2630"},
                       @{@"date":@"2018-10-15",@"price":@"253"},
                       @{@"date":@"2018-10-17",@"price":@"213"},
                       @{@"date":@"2018-10-20",@"price":@"113"},
                       @{@"date":@"2018-10-21",@"price":@"222"},
           
                       @{@"date":@"2018-10-30",@"price":@"2"},
                       @{@"date":@"2018-10-31",@"price":@"231"},
                       
                       @{@"date":@"2018-11-01",@"price":@"231"},
                       @{@"date":@"2018-11-02",@"price":@"232"},
                       @{@"date":@"2018-11-04",@"price":@"234"},
                       @{@"date":@"2018-11-07",@"price":@"237"},
                       @{@"date":@"2018-11-08",@"price":@"238"},
                       
                       @{@"date":@"2018-12-02",@"price":@"232"},
                       @{@"date":@"2018-12-03",@"price":@"233"},
                       @{@"date":@"2018-12-05",@"price":@"235"},
                       @{@"date":@"2018-12-06",@"price":@"236"},
                       ];
    cvc.calendarType = MSSCalendarActivityType;
    cvc.beforeTodayCanTouch = NO;// 今天之后的日期是否可以点击
    cvc.afterTodayCanTouch = YES;// 今天之前的日期是否可以点击
    //    cvc.startDate = _startDate;// 选中开始时间
    //    cvc.endDate = _endDate;// 选中结束时间
    /*以下两个属性设为YES,计算中国农历非常耗性能（在5s加载15年以内的数据没有影响）*/
    cvc.showChineseHoliday = YES;// 是否展示农历节日
    cvc.showChineseCalendar = NO;// 是否展示农历
    cvc.showHolidayDifferentColor = YES;// 节假日是否显示不同的颜色
    cvc.showAlertView = NO;// 是否显示提示弹窗
    cvc.delegate = self;
    [self presentViewController:cvc animated:YES completion:nil];

}

- (void)calendarActivityClickWithStartDate:(NSInteger)startDate{
    
    _startDate = startDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
    _startLabel.text = [NSString stringWithFormat:@"开始日期:%@",startDateString];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
