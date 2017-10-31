/************************************************************
 Class    : AppViewController.m
 Describe : 使用模块视图控制器
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-30
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppViewController.h"
#import "AppTopView.h"
#import "AppPullHidenView.h"
#import "AppGroupView.h"
#import "AppBorderView.h"
#import "AppView.h"
#import "AppModel.h"
#import "AppUtil.h"

#pragma mark 应用类型分组ENUM
typedef NS_ENUM(NSInteger, AppViewType) {
    AppViewTypeMine,    // 应用视图类型，我的应用
    AppViewTypeOther    // 应用视图类型，其他应用
};

@interface AppViewController () <AppTopViewDelegate, AppViewDelegate>

@property (nonatomic, assign) CGPoint viewPoint;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) NSInteger beginPos;
@property (nonatomic, assign) NSInteger endPos;

@property (nonatomic, assign) CGFloat mineViewHeight;
@property (nonatomic, assign) CGFloat otherViewHeight;

@property (nonatomic, strong) AppTopView *topView;
@property (nonatomic, strong) AppPullHidenView *pullHidenView;
@property (nonatomic, strong) BaseScrollView *baseScrollView;

@property (nonatomic, strong) AppGroupView *mineGroupView;
@property (nonatomic, strong) AppGroupView *otherGroupView;

@property (nonatomic, strong) NSArray *mineAppData;
@property (nonatomic, strong) NSArray *otherAppData;
@property (nonatomic, strong) NSMutableArray *viewArray;

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.baseScrollView];
    [self.baseScrollView addSubview:self.pullHidenView];
    [self.baseScrollView addSubview:self.mineGroupView];
    
    [self initializeData];
    [self.baseScrollView setContentSize:CGSizeMake(WIDTH_SCREEN, _otherViewHeight+35)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化数据
- (void)initializeData {
    NSDictionary *appData = [[AppUtil sharedAppUtil] loadData];
    
    _mineAppData = [appData objectForKey:@"mineData"];
    //[self initAppViewData:_mineAppData type:AppViewTypeMine];
    [self initAppBorderView];
    
    _otherAppData = [appData objectForKey:@"otherData"];
    [self initAppViewData:_otherAppData type:AppViewTypeOther];
}

#pragma mark - 添加应用图标底层虚线边框
- (void)initAppBorderView {
    int itemWidth = ((WIDTH_SCREEN - 25) / 4);
    
    for (int i = 0; i < _mineAppData.count; i++) {
        CGRect frame = CGRectMake((i%4)*(itemWidth+5)+10,(i/4)*(itemWidth+5)+self.mineGroupView.frameBottom+10,itemWidth-10,itemWidth-10);
        frame = CGRectInset(frame, 1, 1);
        AppBorderView *appBorderView = [[AppBorderView alloc] initWithFrame:frame];
        [self.baseScrollView addSubview:appBorderView];
    }
    [self initAppViewData:_mineAppData type:AppViewTypeMine];
}

#pragma mark - 初始化创建应用模块视图
- (void)initAppViewData:(NSArray *)data type:(AppViewType)type{
    int viewWidth = ((WIDTH_SCREEN - 25) / 4);
    
    for (int i = 0; i < data.count; i++) {
        AppModelItem *item = [AppModelItem createWithJSON:data[i]];
        AppView *appView = [[AppView alloc] init];
        appView.delegate = self;
        appView.item = item;
        
        if(type == AppViewTypeMine){
            appView.tag = i;
            appView.frame = CGRectMake((i%4)*(viewWidth+5)+5,(i/4)*(viewWidth+5)+self.mineGroupView.frameBottom,viewWidth,viewWidth);
            
            if(i == data.count-1)
                _mineViewHeight = appView.frameBottom;
                
            // 添加长按手势
            UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerAction:)];
            [appView addGestureRecognizer:longGesture];
            
            [self.baseScrollView addSubview:appView];
            [self.viewArray addObject:appView];
        }
        
        if(type == AppViewTypeOther){
            [self.baseScrollView addSubview:self.otherGroupView];
            appView.frame = CGRectMake((i%4)*(viewWidth+5)+5,(i/4)*(viewWidth+5)+self.otherGroupView.frameBottom,viewWidth,viewWidth);
            
            if(i == data.count-1)
                _otherViewHeight = appView.frameBottom;
            
            [self.baseScrollView addSubview:appView];
        }
    }
        
}

#pragma mark - 长按挪动方法
#pragma mark 长安触发事件
- (void)longPressGestureRecognizerAction:(UILongPressGestureRecognizer *)sender {
    AppView *appView = (AppView *)sender.view;
    [appView.superview bringSubviewToFront:appView];// 把当前选中视图挪到最前方
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        _startPoint = [sender locationInView:appView];
        _beginPos = appView.tag;
        _viewPoint = appView.center;
        NSLog(@"appView = %@",appView);
        NSLog(@"appView.tag = %lu",appView.tag);
        [UIView animateWithDuration:0.2 animations:^{
            appView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
            appView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            appView.alpha = 1.0;
        }];
    } else if (sender.state == UIGestureRecognizerStateChanged){
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x - _startPoint.x;
        CGFloat deltaY = newPoint.y - _startPoint.y;
        appView.center = CGPointMake(appView.center.x + deltaX, appView.center.y + deltaY);
        NSInteger fromIndex = appView.tag;
        
        NSInteger toIndex = [self judgeMoveByButtonPoint:appView.center moveButton:appView];
        
        if (toIndex < 0) {
            return;
        } else {
            appView.tag = toIndex;
            // 向后移动
            if (fromIndex - toIndex < 0) {
                for (NSInteger i = fromIndex; i < toIndex; i ++) {
                    UIButton *nextBtn = _viewArray[i+1];
                    // 改变按钮中心点的位置
                    CGPoint temp = nextBtn.center;
                    [UIView animateWithDuration:0.5 animations:^{
                        nextBtn.center = _viewPoint;
                    }];
                    _viewPoint = temp;
                    // 交换tag值
                    nextBtn.tag = i;
                    
                }
                [self sortArray];
            } else if (fromIndex - toIndex > 0) {
                // 向前移动
                for (NSInteger i = fromIndex; i > toIndex; i --) {
                    UIButton *beforBtn = _viewArray[i - 1];
                    CGPoint temp = beforBtn.center;
                    [UIView animateWithDuration:0.5 animations:^{
                        beforBtn.center = _viewPoint;
                    }];
                    _viewPoint = temp;
                    beforBtn.tag = i;
                }
                [self sortArray];
            }
        }
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            appView.backgroundColor = [UIColor whiteColor];
            appView.transform = CGAffineTransformIdentity;
            appView.alpha = 1.0f;
            appView.center = _viewPoint;
        }];
    }
}
#pragma mark 对数组排序
- (void)sortArray {
    // 对已改变按钮的数组进行排序
    [_viewArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UIButton *temp1 = (UIButton *)obj1;
        UIButton *temp2 = (UIButton *)obj2;
        return temp1.tag > temp2.tag;    //将tag值大的按钮向后移
    }];
}
#pragma mark 移动判断方法
- (NSInteger)judgeMoveByButtonPoint:(CGPoint)point moveButton:(AppView *)view {
    /**
     * 判断移动按钮的中心点是否包含了所在按钮的中心点如果是将i返回
     */
    for (NSInteger i = 0; i < _mineAppData.count; i++) {
        AppView *appView = _viewArray[i];
        if (!view || appView != view) {
            if (CGRectContainsPoint(appView.frame, point)) {
                return i;
            }
        }
    }
    return -1;
}

#pragma mark - Getter方法
- (NSMutableArray *)viewArray {
    if(!_viewArray){
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}
#pragma mark 初始化顶部视图
- (AppTopView *)topView {
    if(!_topView){
        _topView = [[AppTopView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_STATUS+136)];
        _topView.delegate = self;
    }
    return _topView;
}

- (AppPullHidenView *)pullHidenView {
    if(!_pullHidenView){
        _pullHidenView = [[AppPullHidenView alloc] initWithFrame:CGRectMake(0, -HEIGHT_SCREEN, WIDTH_SCREEN, HEIGHT_SCREEN)];
    }
    return _pullHidenView;
}

#pragma mark 初始化基本的回弹UIScrollView视图
- (BaseScrollView *)baseScrollView {
    if(!_baseScrollView){
        _baseScrollView = [[BaseScrollView alloc] initWithFrame:CGRectMake(0,self.topView.frameBottom, WIDTH_SCREEN, HEIGHT_SCREEN - self.topView.frameBottom - HEIGHT_TABBAR)];
        _baseScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _baseScrollView;
}

#pragma mark 初始化我的应用分组条
- (AppGroupView *)mineGroupView {
    if(!_mineGroupView){
        _mineGroupView = [[AppGroupView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 30)];
        _mineGroupView.top = YES;
        _mineGroupView.title = @"我的应用";
    }
    return _mineGroupView;
}

#pragma mark 初始化其他应用分组条
- (AppGroupView *)otherGroupView {
    if(!_otherGroupView){
        _otherGroupView = [[AppGroupView alloc] initWithFrame:CGRectMake(0, _mineViewHeight, WIDTH_SCREEN, 30)];
        _otherGroupView.title = @"更多应用";
    }
    return _otherGroupView;
}

#pragma mark - <AppTopViewDelegate>应用顶部视图点击代理方法
- (void)appTopViewBtnClick:(UIButton *)sender {
    DLog(@"%@",sender.titleLabel.text);
    
    /*
    [YZNetworkingManager POST:[NSString stringWithFormat:@"%@account/login", SERVER_URL] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        DLog(@"responseObject = %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DLog(@"error = %@", error);
    }];
     */
    
    if(sender.tag == 1){
        DLog(@"搜索方法");
    }
    if(sender.tag == 2){
        [self.navigationController pushViewController:[NSClassFromString(@"AppEditViewController") new] animated:YES];
    }
}

#pragma mark - <AppViewDelegate>应用模块视图点击代理方法
- (void)appViewClick:(AppView *)appView{
    DLog(@"%@",appView.item.title);
}

@end
