//
//  VideoCell.m
//  JShareDemo
//
//  Created by 黄鹏志 on 06/03/2017.
//  Copyright © 2017 ys. All rights reserved.
//

#import "VideoCell.h"

@interface VideoCell ()
@property (strong, nonatomic) UIImageView *videoThumbnail;
@property (strong, nonatomic) UIImageView *selectedIcon;

@end

@implementation VideoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isSelected = NO;
        self.videoThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        self.selectedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 40, 40)];
        [self.selectedIcon setHidden:YES];
        self.selectedIcon.image = [UIImage imageNamed:@"mark"];
        
        [self.contentView addSubview:self.videoThumbnail];
        [self.contentView addSubview:self.selectedIcon];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    self.isSelected = selected;
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage{
    self.videoThumbnail.image = thumbnailImage;
}

- (void)setIsSelected:(BOOL)isSelected{
    [self.selectedIcon setHidden:!isSelected];

}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.videoThumbnail.image = nil;
    self.isSelected = NO;
}

@end
