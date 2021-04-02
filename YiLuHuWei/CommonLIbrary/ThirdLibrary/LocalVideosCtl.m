//
//  LocalVideosCtl.m
//  JShareDemo
//
//  Created by 黄鹏志 on 06/03/2017.
//  Copyright © 2017 ys. All rights reserved.
//

#import "LocalVideosCtl.h"
#import "VideoCell.h"


@interface LocalVideosCtl ()
@property (strong, nonatomic) UIBarButtonItem *shareButtom;
@property (nonatomic,strong) NSMutableArray *localVideos;
@property (nonatomic,strong) NSIndexPath *selectedIndex;
@end

@implementation LocalVideosCtl

static NSString * const reuseIdentifier = @"Cell";

-(instancetype)init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(80, 80);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.localVideos = @[].mutableCopy;
    static ALAssetsLibrary *library = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         library = [[ALAssetsLibrary alloc] init];
    });
    __weak typeof(self) weakSelf = self;
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allVideos]];
        if (group.numberOfAssets) {
            __block NSMutableArray *tempArray = @[].mutableCopy;
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [tempArray addObject:result];
                }else{
                    weakSelf.localVideos = tempArray;
                    [weakSelf.collectionView reloadData];
                }
               
            }];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shareButtom = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(clickToShare:)];
    self.navigationItem.rightBarButtonItem = self.shareButtom;
    
    [self.collectionView registerClass:[VideoCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = UIColor.whiteColor;
}

- (void)viewDidDisappear:(BOOL)animated{
    //[super viewDidDisappear];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)clickToShare:(id)sender {
    ALAsset *selectedVideo = self.localVideos[self.selectedIndex.row];
    NSURL *assetURL = [selectedVideo valueForProperty:@"ALAssetPropertyAssetURL"];
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHAREVideo;
    message.text = @"";
    message.title = @"";
    message.videoAssetURL = assetURL.absoluteString;
    message.platform = self.platform;
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        
        NSLog(@"分享回调");
    }];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.localVideos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (self.localVideos.count) {
        ALAsset *video = self.localVideos[indexPath.row];
        cell.thumbnailImage = [UIImage imageWithCGImage:[video thumbnail]];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.navigationItem.rightBarButtonItem = self.shareButtom;
    VideoCell *cell = (VideoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.isSelected = YES;
    self.selectedIndex = indexPath;
}

@end
