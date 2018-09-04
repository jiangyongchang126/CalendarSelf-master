//
//  JYCAplaceCalendarController.m
//  MSSCalendar
//
//  Created by 蒋永昌 on 2018/8/31.
//  Copyright © 2018年 于威. All rights reserved.
//

#import "JYCAplaceCalendarController.h"
#import "MSSCalendarCollectionViewCell.h"
#import "MSSCalendarHeaderModel.h"
#import "MSSCalendarManager.h"
#import "MSSCalendarCollectionReusableView.h"
#import "MSSCalendarPopView.h"
#import "MSSCalendarDefine.h"

@interface JYCAplaceCalendarController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)MSSCalendarPopView *popView;
@property (nonatomic,strong)MSSCalendarManager *manager;
@end

@implementation JYCAplaceCalendarController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _afterTodayCanTouch = YES;
        _beforeTodayCanTouch = YES;
        _dataArray = [[NSMutableArray alloc]init];
        _showChineseCalendar = NO;
        _showChineseHoliday = NO;
        _showHolidayDifferentColor = NO;
        _showAlertView = YES;
        _endDate = 0;
        _startDate = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDataSource];
    [self createUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(_popView)
    {
        [_popView removeFromSuperview];
        _popView = nil;
    }
}

- (void)initDataSource
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.manager = [[MSSCalendarManager alloc]initWithShowChineseHoliday:_showChineseHoliday showChineseCalendar:_showChineseCalendar startDate:_startDate];
        
        NSArray *tempDataArray = [self.manager getJYCCalendarDataSoruceWithLimitMonth:_limitMonth type:_type calendarType:MSSCalendarAplaceType  priceArray:_priceArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dataArray addObjectsFromArray:tempDataArray];
            [self showCollectionViewWithStartIndexPath:self.manager.startIndexPath];
        });
    });
}

- (void)upDateDataSouce{
    
   NSArray *arr = [self.manager getCalendarDataSoruceWithMinNum:self.minNum MaxNum:self.maxNum startDate:_startDate endDate:_endDate andDataArray:_dataArray];
    
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:arr];
    [_collectionView reloadData];
}

- (void)addWeakView
{
    UIView *weekView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSS_SCREEN_WIDTH, MSS_WeekViewHeight)];
    weekView.backgroundColor = MSS_SelectBackgroundColor;
    [self.view addSubview:weekView];
    
    NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    int i = 0;
    NSInteger width = MSS_Iphone6Scale(54);
    for(i = 0; i < 7;i++)
    {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, MSS_WeekViewHeight)];
        weekLabel.backgroundColor = [UIColor clearColor];
        weekLabel.text = weekArray[i];
        weekLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        if(i == 0 || i == 6)
        {
            weekLabel.textColor = MSS_WeekEndTextColor;
        }
        else
        {
            weekLabel.textColor = MSS_SelectTextColor;
        }
        [weekView addSubview:weekLabel];
    }
}

- (void)showCollectionViewWithStartIndexPath:(NSIndexPath *)startIndexPath
{
    [self addWeakView];
    [_collectionView reloadData];
    // 滚动到上次选中的位置
    if(startIndexPath)
    {
        [_collectionView scrollToItemAtIndexPath:startIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        _collectionView.contentOffset = CGPointMake(0, _collectionView.contentOffset.y - MSS_HeaderViewHeight);
    }
    else
    {
        if(_type == MSSCalendarViewControllerLastType)
        {
            if([_dataArray count] > 0)
            {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_dataArray.count - 1] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            }
        }
        else if(_type == MSSCalendarViewControllerMiddleType)
        {
            if([_dataArray count] > 0)
            {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(_dataArray.count - 1) / 2] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                _collectionView.contentOffset = CGPointMake(0, _collectionView.contentOffset.y - MSS_HeaderViewHeight);
            }
        }
    }
}

- (void)createUI
{
    NSInteger width = MSS_Iphone6Scale(54);
    NSInteger height = MSS_Iphone6Scale(60);
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.headerReferenceSize = CGSizeMake(MSS_SCREEN_WIDTH, MSS_HeaderViewHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 1;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, MSS_WeekViewHeight, width * 7, MSS_SCREEN_HEIGHT - MSS_WeekViewHeight) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[MSSCalendarCollectionViewCell class] forCellWithReuseIdentifier:@"MSSCalendarCollectionViewCell"];
    [_collectionView registerClass:[MSSCalendarCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MSSCalendarCollectionReusableView"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_dataArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MSSCalendarHeaderModel *headerItem = _dataArray[section];
    return headerItem.calendarItemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSSCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSSCalendarCollectionViewCell" forIndexPath:indexPath];
    if(cell)
    {
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        MSSCalendarHeaderModel *headerItem = _dataArray[indexPath.section];
        MSSCalendarModel *calendarItem = headerItem.calendarItemArray[indexPath.row];
        cell.dateLabel.text = @"";
        cell.dateLabel.textColor = MSS_TextColor;
        cell.subLabel.text = @"";
        cell.subLabel.textColor = MSS_SelectSubLabelTextColor;
        cell.isSelected = NO;
        cell.userInteractionEnabled = NO;
        if(calendarItem.day > 0)
        {
            cell.dateLabel.text = [NSString stringWithFormat:@"%ld",(long)calendarItem.day];
            cell.userInteractionEnabled = YES;
                if (calendarItem.price.length > 0) {
                    cell.userInteractionEnabled = calendarItem.userInteractionEnabled;
                    cell.subLabel.text = [NSString stringWithFormat:@"%@",calendarItem.price];
                }else{
                    cell.userInteractionEnabled = calendarItem.userInteractionEnabled;
                    cell.dateLabel.textColor = MSS_TouchUnableTextColor;
                    cell.subLabel.textColor = MSS_TouchUnableTextColor;
                }
                
        }
        if(_showChineseCalendar)
        {
            cell.subLabel.text = calendarItem.chineseCalendar;
        }
        if (_startDate > 0) {
            if (_endDate == 0) {
                if (calendarItem.middleSelect) {
                    cell.backgroundColor = SelMiddleColor;
                }else{
                    cell.backgroundColor = [UIColor clearColor];
                }
            }else if (_endDate > 0){
                cell.backgroundColor = [UIColor clearColor];
            }
        }
        // 开始日期
        if(calendarItem.dateInterval == _startDate)
        {
            cell.isSelected = YES;
            cell.dateLabel.textColor = MSS_SelectTextColor;
            cell.subLabel.text = MSS_SelectBeginText;
            cell.contentView.backgroundColor = SelectedColor;
            cell.subLabel.text = @"入住";
            
        }
        // 结束日期
        else if (calendarItem.dateInterval == _endDate)
        {
            cell.isSelected = YES;
            cell.dateLabel.textColor = MSS_SelectTextColor;
            cell.subLabel.text = MSS_SelectEndText;
            cell.contentView.backgroundColor = SelectedColor;
            cell.subLabel.text = @"离店";
            
        }
        // 开始和结束之间的日期
        else if(calendarItem.dateInterval > _startDate && calendarItem.dateInterval < _endDate)
        {
            cell.isSelected = YES;
            cell.dateLabel.textColor = MSS_SelectTextColor;
            cell.contentView.backgroundColor = SelMiddleColor;
            
        }
        else
        {
            if(calendarItem.week == 0 || calendarItem.week == 6)
            {
                cell.dateLabel.textColor = MSS_WeekEndTextColor;
                cell.subLabel.textColor = MSS_WeekEndTextColor;
            }
            if(calendarItem.holiday.length > 0)
            {
                cell.dateLabel.text = calendarItem.holiday;
                if(_showHolidayDifferentColor)
                {
                    cell.dateLabel.textColor = MSS_HolidayTextColor;
                    cell.subLabel.textColor = MSS_HolidayTextColor;
                }
            }
        }
        
        if(calendarItem.day > 0)
            {
                if (!calendarItem.userInteractionEnabled) {
                    cell.dateLabel.textColor = MSS_TouchUnableTextColor;
                    cell.subLabel.textColor = MSS_TouchUnableTextColor;
                }
            }

        if(!_afterTodayCanTouch)
        {
            if(calendarItem.type == MSSCalendarNextType)
            {
                cell.dateLabel.textColor = MSS_TouchUnableTextColor;
                cell.subLabel.textColor = MSS_TouchUnableTextColor;
                cell.userInteractionEnabled = NO;
            }
        }
        if(!_beforeTodayCanTouch)
        {
            if(calendarItem.type == MSSCalendarLastType)
            {
                cell.dateLabel.textColor = MSS_TouchUnableTextColor;
                cell.subLabel.textColor = MSS_TouchUnableTextColor;
                cell.userInteractionEnabled = NO;
            }
        }
    }
    return cell;
}

// 添加header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MSSCalendarCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MSSCalendarCollectionReusableView" forIndexPath:indexPath];
        MSSCalendarHeaderModel *headerItem = _dataArray[indexPath.section];
        headerView.headerLabel.text = headerItem.headerText;
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        MSSCalendarHeaderModel *headerItem = _dataArray[indexPath.section];
        MSSCalendarModel *calendaItem = headerItem.calendarItemArray[indexPath.row];
        // 当开始日期为空时
        if(_startDate == 0)
        {
            _startDate = calendaItem.dateInterval;
            [self showPopViewWithIndexPath:indexPath];
            [self upDateDataSouce];

        }
        // 当开始日期和结束日期同时存在时(点击为重新选时间段)
        else if(_startDate > 0 && _endDate > 0)
        {
            _startDate = calendaItem.dateInterval;
            _endDate = 0;
            [self showPopViewWithIndexPath:indexPath];
            [self upDateDataSouce];

        }
        else
        {
            // 判断第二个选择日期是否比现在开始日期大
            if(_startDate < calendaItem.dateInterval)
            {
                _endDate = calendaItem.dateInterval;
                [self upDateDataSouce];

                if([_delegate respondsToSelector:@selector(calendarClickWithStartDate:endDate:)])
                {
                    [_delegate calendarClickWithStartDate:_startDate endDate:_endDate];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }
            else
            {
                _startDate = calendaItem.dateInterval;
                [self showPopViewWithIndexPath:indexPath];
                [self upDateDataSouce];

            }
        }
        [_collectionView reloadData];
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(_popView)
    {
        [_popView removeFromSuperview];
        _popView = nil;
    }
}

- (void)showPopViewWithIndexPath:(NSIndexPath *)indexPath;
{
    if(_showAlertView)
    {
        [_popView removeFromSuperview];
        _popView = nil;
        
        MSSCalendarPopViewArrowPosition arrowPostion = MSSCalendarPopViewArrowPositionMiddle;
        NSInteger position = indexPath.row % 7;
        if(position == 0)
        {
            arrowPostion = MSSCalendarPopViewArrowPositionLeft;
        }
        else if(position == 6)
        {
            arrowPostion = MSSCalendarPopViewArrowPositionRight;
        }
        
        MSSCalendarCollectionViewCell *cell = (MSSCalendarCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        _popView = [[MSSCalendarPopView alloc]initWithSideView:cell.dateLabel arrowPosition:arrowPostion];
        _popView.topLabelText = [NSString stringWithFormat:@"请选择可选区域日期"];
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"MM月dd日"MSS_SelectBeginText];
//        NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
        _popView.bottomLabelText = [NSString stringWithFormat:@"居住%ld至%ld天",self.minNum,self.maxNum];
        [_popView showWithAnimation];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
