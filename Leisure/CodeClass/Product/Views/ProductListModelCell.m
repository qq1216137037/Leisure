//
//  ProductListModelCell.m
//  Leisure
//
//  Created by zero on 16/3/31.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ProductListModelCell.h"
#import "ProductListModel.h"

@implementation ProductListModelCell

- (void)setData:(ProductListModel *)model
{
    NSURL *url = [NSURL URLWithString:model.coverimg];
    [self.coverImageView sd_setImageWithURL:url];
    
    self.titleLabel.text = model.title;
    
    [self.buyButton.layer setMasksToBounds:YES];
    [self.buyButton.layer setCornerRadius:10];
    [self.buyButton.layer setBorderWidth:1];
}

@end
