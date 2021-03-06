//
//  HomeViewController.m
//  SecretAlbum
//
//  Created by 王雪剑 on 17/11/27.
//  Copyright © 2017年 zkml－wxj. All rights reserved.
//

#import "HomeMainViewController.h"
#import "HomeCollectionModel.h"
#import "HomeCollectionViewCell.h"
#import <Photos/Photos.h>
#import "YFLookImageView.h"

@interface HomeMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,HomeCollectionViewCellDelegate>
{
    UICollectionView *_collectionView;
 
    
    NSMutableArray *_dataArray; //保存的是字典：image的64位转换码(imageBase64)、保存到本地的状态(saveToLocal)
    NSMutableArray *_saveArray;
}
@end

@implementation HomeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithRGBString(@"#f5f3f0");
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _dataArray = [NSMutableArray new];
    _saveArray = [NSMutableArray new];
    [self createView];
    [self createRightNavBtn];
    [self loadData];
}

-(void)createView{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollPositionCenteredVertically;
    flow.minimumInteritemSpacing = 10;//垂直方向的间距
    flow.minimumLineSpacing = 10;//水平方向的间距
    flow.itemSize = CGSizeMake((kSelfWidth-30)/2, (kSelfHeight-64-49-30)/2);
    flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kSelfWidth, kSelfHeight-64-49-kSize(114+48)) collectionViewLayout:flow];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(kSize(48), kSelfHeight-49-kSize(48+114), kSelfWidth-kSize(48+48), kSize(114));
    addBtn.backgroundColor = colorWithRGBString(@"#3dcc6d");
    addBtn.layer.cornerRadius = kSize(6);
    addBtn.layer.shadowColor = colorWithRGBString(@"#3dcc6d").CGColor;
    addBtn.layer.shadowOffset = CGSizeMake(0,kSize(10));
    addBtn.layer.shadowOpacity = 0.3;
    addBtn.layer.shadowRadius = 5; //阴影的模糊程度
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:kSize(48)];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(handleAddBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}

#pragma mark ********【界面】********创建导航栏按钮
-(void)createRightNavBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:kFont(42)];
    [btn setTitle:@"管理" forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateSelected];
    [btn setTitleColor:colorWithRGBString(@"#03a9f4") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *navigationSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    navigationSpacer.width = -(15-kSize(24)); //间距减小17pix
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:navigationSpacer,item, nil];
}

#pragma mark ********【界面】********创建导航栏按钮
-(void)createLeftNavBtnWithShow:(BOOL)isShow{
    if (isShow) {
        UIButton *leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftNavBtn.frame = CGRectMake(0, 0, 40, 30);
        leftNavBtn.titleLabel.font = [UIFont systemFontOfSize:kFont(42)];
        [leftNavBtn setTitle:@"删除" forState:UIControlStateNormal];
        [leftNavBtn setTitleColor:colorWithRGBString(@"#03a9f4") forState:UIControlStateNormal];
        [leftNavBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavBtn];
        
        UIBarButtonItem *navigationSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        navigationSpacer.width = -(15-kSize(24)); //间距减小17pix
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:navigationSpacer,leftItem, nil];
    }else{
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:nil ,nil];
    }
   
}

-(void)loadData{
    [self readFromPlist];
    [_collectionView reloadData];
}

#pragma mark ********【代理】********UICollectionView的代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ide = @"cell";
    
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ide forIndexPath:indexPath];
    
    NSDictionary *dic = _dataArray[indexPath.row];
    NSString *str = [dic objectForKey:@"imageBase64"];
    NSString *saveTolocalStr = [dic objectForKey:@"saveToLocal"];
    NSString * isShowSelectBtn = [dic objectForKey:@"isShowSelectBtn"];
    NSString * isSelected = [dic objectForKey:@"isSelected"];
    
    HomeCollectionModel *model = [[HomeCollectionModel alloc]init];
    model.imageStr = str;
    model.saveToLocal = saveTolocalStr;
    model.isShowSelectBtn = isShowSelectBtn;
    model.isSelected = isSelected;
    cell.model = model;
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.backgroundColor = colorWithRGBString(@"#03a9f4");
    
    //已选车辆的选中状态
    for (NSDictionary *dictionary in _saveArray) {
        NSString *isShowSelectSave = [dictionary objectForKey:@"isShowSelectBtn"] ;
        NSString *isSelectedSave = [dictionary objectForKey:@"isSelected"] ;
        if ([model.imageStr isEqualToString:[dictionary objectForKey:@"imageBase64"]] ) {
            if(isShowSelectSave){
                cell.selectBtn.hidden = NO;
            }
            
            if (isSelectedSave) {
                cell.selectBtn.selected = YES;
            }
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
//    NSDictionary *dic = _dataArray[indexPath.row];
//    NSString *str = [dic objectForKey:@"imageBase64"];
//    UIImage *image = Base64StrToUIImage(str);
    
    YFLookImageView *lookImageView = [[YFLookImageView alloc]initWithImageArray:_dataArray withIndex:indexPath.row];
    [lookImageView show];
}

#pragma mark ********【代理】********长按图片
-(void)handleLongGestureOnClick:(NSInteger)index{
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UIImage *image = Base64StrToUIImage(cell.model.imageStr);
    
    //判断是否保存过
    if ([cell.model.saveToLocal boolValue]) {
        [[Message sharedMessage] showImageMessage:@"请勿重复保存" isCorrect:NO];
        return;
    }
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"保存图片到本地相册" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消保存图片");
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //写入图片到相册
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *req;
            req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"success = %d, error = %@", success, error);
            //保存成功后
            NSMutableDictionary *mutableDic = _dataArray[index];
            [mutableDic setValue:@"YES" forKey:@"saveToLocal"];
            [_dataArray replaceObjectAtIndex:index withObject:mutableDic];
            [_collectionView reloadData];
        }];
    }];
    
    [alertControl addAction:cancel];
    [alertControl addAction:confirm];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}

#pragma mark ********【操作】********删除
-(void)deleteBtnClick:(UIButton *)sender{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:_dataArray];
    for (int i = 0; i<_dataArray.count; i++) {
        NSDictionary *dic = _dataArray[i];
        NSString *imageStr = [dic objectForKey:@"imageBase64"];
        
        for (int j = 0; j<_saveArray.count; j++) {
            NSDictionary *dictionary = _saveArray[j];
            NSString *imageString = [dictionary objectForKey:@"imageBase64"];
            
            if ([imageStr isEqualToString:imageString]) {
                [mutableArray removeObject:dic];
                break;
            }
        }
    }
    
    _dataArray = mutableArray;
    [_collectionView reloadData];
    
    [self writeToPlist];
}

#pragma mark ********【操作】********管理按钮
-(void)rightBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self createLeftNavBtnWithShow:sender.selected];
    
    if (sender.selected) {
        for (int i = 0 ;i<_dataArray.count;i++) {
            NSDictionary *dictionary = _dataArray[i];
            [dictionary setValue:@"YES" forKey:@"isShowSelectBtn"];
            [_dataArray replaceObjectAtIndex:i withObject:dictionary];
        }
    }else{
        for (int i = 0 ;i<_dataArray.count;i++) {
            NSDictionary *dictionary = _dataArray[i];
            [dictionary setValue:@"NO" forKey:@"isShowSelectBtn"];
            [_dataArray replaceObjectAtIndex:i withObject:dictionary];
        }
    }
    
    [_collectionView reloadData];
}

-(void)handleSelectedWithIndex:(NSInteger)index{
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSString *imageStr = [NSString stringWithFormat:@"%@",cell.model.imageStr];
    NSString *saveToLocal = cell.model.saveToLocal;
    NSString *isShowSelectBtn = cell.model.isShowSelectBtn;
    NSString *isSelected = cell.selectBtn.selected?@"YES":@"NO";
    [dic setObject:imageStr forKey:@"imageBase64"];
    [dic setObject:saveToLocal forKey:@"saveToLocal"];
    [dic setObject:isShowSelectBtn forKey:@"isShowSelectBtn"];
    [dic setObject:isSelected forKey:@"isSelected"];
    
    if (cell.selectBtn.selected) { //被选中 添加进保存数组中
        [_saveArray addObject:dic];
    }else{ //取消选中
        //不能采用[_saveArray removeObject:dic];  防止在修改订单时，dic 与_saveArray中保存的不一致，无法删除
        for (NSDictionary *dictionary in _saveArray) {
            NSString *imageString = [dictionary objectForKey:@"driverId"];
            if ([imageStr isEqualToString:imageString]) {
                [_saveArray removeObject:dic];
                break;
            }
        }
    }
}

#pragma mark ---添加按钮
-(void)handleAddBtnClick:(UIButton *)sender{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: @"从相册选择", @"拍照",nil];
    [myActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self LocalPhoto];
            break;
        case 1:
            //拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}

//从相册选择
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        SNLog(@"该设备无摄像头");
    }
}

#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{

    NSString *imageString = [self UIImageToBase64Str:image];
    
    NSMutableDictionary *mutableDic = [NSMutableDictionary new];
    [mutableDic setObject:imageString forKey:@"imageBase64"];
    
    
    if (![_dataArray containsObject:mutableDic]) {
        [_dataArray addObject:mutableDic];
    }else{
        [[Message sharedMessage] showImageMessage:@"请勿重复添加" isCorrect:NO];
    }
    
    [_collectionView reloadData];
    
    [self writeToPlist];
    
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ---图片转字符串
-(NSString *)UIImageToBase64Str:(UIImage *) image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

#pragma mark ---写入plist文件
-(void)writeToPlist{
    //获取documents文件路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    //拼接
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"imageArray.plist"];
    //写入
    [_dataArray writeToFile:filePath atomically:YES];
}

#pragma mark ---读取plist文件中的数据
-(void)readFromPlist{
    //获取documents文件路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    //文件路径拼接
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"imageArray.plist"];
    //读取
    NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
    _dataArray = [NSMutableArray arrayWithArray:arr];
    
    //读取出来之后，将数据初始化
    for (int i = 0 ;i<_dataArray.count;i++) {
        NSDictionary *dictionary = _dataArray[i];
        [dictionary setValue:@"NO" forKey:@"isShowSelectBtn"];
        [_dataArray replaceObjectAtIndex:i withObject:dictionary];
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
