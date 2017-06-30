//
//  DNAlbumViewCell.m
//  XDImagePicker
//
//  Created by YingshanDeng on 2017/6/30.
//  Copyright © 2017年 YingshanDeng. All rights reserved.
//

#import "DNAlbumViewCell.h"

static int const DNAlbumViewCellImageViewBorder = 10;

@implementation DNAlbumViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.albumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DNAlbumViewCellImageViewBorder,
                                                                            DNAlbumViewCellImageViewBorder,
                                                                            64,
                                                                            64)];
        
        [self.albumImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.albumImageView setClipsToBounds:YES];
        [self.contentView addSubview:self.albumImageView];
        
        
        self.albumTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.albumImageView.frame) + DNAlbumViewCellImageViewBorder,
                                                                   0,
                                                                   self.frame.size.width - CGRectGetMaxX(self.albumImageView.frame) - DNAlbumViewCellImageViewBorder,
                                                                   self.frame.size.height)];
        [self.albumTextLabel setTextAlignment:NSTextAlignmentLeft];
        [self.albumTextLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self.contentView addSubview:self.albumTextLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
