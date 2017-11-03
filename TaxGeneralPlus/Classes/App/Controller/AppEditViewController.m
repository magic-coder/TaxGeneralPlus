/************************************************************
 Class    : AppEditViewController.m
 Describe : 应用管理编辑模块视图控制器
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-31
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "AppEditViewController.h"
#import "AppEditViewCell.h"
#import "AppEditHeaderView.h"
#import "AppModel.h"
#import "AppUtil.h"

@interface AppEditViewController () <AppEditViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation AppEditViewController

static NSString * const reuseCellIdentifier = @"reuseCellIdentifier";
static NSString * const reuseHeaderIdentifier = @"reuseHeaderIdentifier";


- (instancetype)init {
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;// 确定是水平滚动，还是垂直滚动
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return [super initWithCollectionViewLayout:_flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的应用管理";
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;// 总是可垂直滑动
    self.collectionView.showsVerticalScrollIndicator = NO; // 隐藏垂直滚动条
    
    // Register cell classes
    [self.collectionView registerClass:[AppEditViewCell class] forCellWithReuseIdentifier:reuseCellIdentifier];
    [self.collectionView registerClass:[AppEditHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier];
    
    [self initializeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;// 设置顶部状态栏字体为黑色
    self.navigationController.navigationBar.tintColor = DEFAULT_BLUE_COLOR;// 设置导航栏itemBar字体颜色
    self.navigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor blackColor] };// 设置导航栏title标题字体颜色
    [self.navigationController.navigationBar yz_setBackgroundColor:[UIColor whiteColor]];
}

- (void)initializeData {
    self.data = [NSMutableArray array];
    NSDictionary *appData = [[AppUtil sharedAppUtil] loadData];
    NSArray *mineAppData = [appData objectForKey:@"mineData"];
    NSArray *otherAppData = [appData objectForKey:@"allData"];
    
    NSMutableArray *mineArray = [NSMutableArray array];
    for(NSDictionary *dict in mineAppData){
        AppModelItem *item = [AppModelItem createWithDictionary:dict];
        [mineArray addObject:item];
    }
    NSMutableArray *otherArray = [NSMutableArray array];
    for(NSDictionary *dict in otherAppData){
        AppModelItem *item = [AppModelItem createWithDictionary:dict];
        [otherArray addObject:item];
    }
    
    AppModelGroup *mineGroup = [[AppModelGroup alloc] init];
    mineGroup.items = mineArray;
    mineGroup.groupTitle = @"我的应用";
    
    AppModelGroup *otherGroup = [[AppModelGroup alloc] init];
    otherGroup.items = otherArray;
    otherGroup.groupTitle = @"全部应用";
    [_data addObject:mineGroup];
    [_data addObject:otherGroup];
}

#pragma mark - <UICollectionViewDataSource> 数据源方法
#pragma mark 返回有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.data.count;
}

#pragma mark 返回每组多少条
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    AppModelGroup *group = [self.data objectAtIndex:section];
    return group.itemsCount;
}

#pragma mark 返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell
    AppModelGroup *group = [_data objectAtIndex:indexPath.section];
    AppModelItem *item = [group itemAtIndex:indexPath.row];
    
    AppEditViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellIdentifier forIndexPath:indexPath];
    
    //第一组为我的应用
    if(indexPath.section == 0){
        cell.editBtnStyle = AppCellEditBtnStyleDelete;
    }else{  // 剩下的为其他应用
        cell.editBtnStyle = AppCellEditBtnStyleAdd;
        AppModelGroup *groupMine = [self.data objectAtIndex:0];
        AppModelGroup *groupAll = [self.data objectAtIndex:1];
        // 循环判断“全部应用”中哪些为“我的应用”，设置编辑按钮样式
        [groupAll.items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AppModelItem *allItem = (AppModelItem *)obj;
            for(AppModelItem *mineObj in groupMine.items){
                if([mineObj.no isEqualToString:allItem.no] && indexPath.row == idx){
                    cell.editBtnStyle = AppCellEditBtnStyleSelected;
                }
            }
        }];
    }
    
    cell.delegate = self;
    
    [cell setItem:item];
    
    return cell;
}

#pragma mark 设置cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = floor((CGFloat)(collectionView.frameWidth)/4);
    return CGSizeMake(width, width);
}

#pragma mark 设置cell上下间隙
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - <UICollectionViewDelegate> 代理方法
#pragma mark 设置每组的顶部视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    AppEditHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AppModelGroup *group = [_data objectAtIndex:indexPath.section];
        headerView.title = group.groupTitle;
    }
    
    return headerView;
}

#pragma mark 设置顶部视图的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return (CGSize){WIDTH_SCREEN, 32};
}

#pragma mark - <UICollectionDelegate>点击代理方法
/*
 - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 if(self.collectionStyle == CollectionStyleNone){
 BaseCollectionViewCell *cell = (BaseCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
 if([cell.titleLabel.text isEqualToString:@"办税地图"]){
 MapDemoViewController *mapVC = [[MapDemoViewController alloc] init];
 mapVC.title = cell.titleLabel.text; // 设置标题
 [self.navigationController pushViewController:mapVC animated:YES];
 }else if([cell.titleLabel.text isEqualToString:@"一户式"]){
 BaseWebViewController *webVC = [[BaseWebViewController alloc] initWithURL:@"http://itunes.com"];
 [self.navigationController pushViewController:webVC animated:YES];
 }else if([cell.titleLabel.text isEqualToString:@"两学一做"]){
 TestWebViewController *testWebView = [[TestWebViewController alloc] initWithURL:@"http://www.apple.com"];
 testWebView.title = cell.titleLabel.text;
 [self.navigationController pushViewController:testWebView animated:YES];
 }else{
 BaseCordovaViewController *cordovaVC = [[BaseCordovaViewController alloc] init];
 NSString *cordovaPage = nil;
 cordovaVC.pagePath = cordovaPage;
 cordovaVC.currentTitle = cell.titleLabel.text;
 [self.navigationController pushViewController:cordovaVC animated:YES];
 }
 }
 }
 */

#pragma mark - 代理编辑按钮点击方法
- (void)appEditViewCellEditBtnClick:(UIButton *)sender {
    
    UIView *view = [sender superview];//获取父类view
    AppEditViewCell *cell = (AppEditViewCell *)[view superview];//获取cell
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];//获取cell对应的indexpath;
    
    if(sender.tag == 0){    // 移除方法
        //DLog(@"进入移除方法 -> senction = %ld, row = %ld",(long)indexpath.section,(long)indexpath.row);
        
        AppModelGroup *mineGroup = [self.data objectAtIndex:0];
        AppModelItem *delItem = [mineGroup.items objectAtIndex:indexpath.row];
        [mineGroup.items removeObject:delItem];
        [self.collectionView reloadData];
    }
    if(sender.tag == 1){    // 添加方法
        //DLog(@"进入添加方法 -> senction = %ld, row = %ld",(long)indexpath.section,(long)indexpath.row);
        
        AppModelGroup *mineGroup = [self.data objectAtIndex:0];
        AppModelGroup *allGroup = [self.data objectAtIndex:1];
        AppModelGroup *addItem = [allGroup.items objectAtIndex:indexpath.row];
        [mineGroup.items addObject:addItem];
        [self.collectionView reloadData];
    }
    
    [self.collectionView reloadData];
    
}


@end
