//
//  SiteCollectionViewItem.m
//  TenNews
//
//  Created by 崔旺 on 2017/12/28.
//  Copyright © 2017年 崔旺. All rights reserved.
//

#import "SiteCollectionViewItem.h"
#import "Colours.h"
@interface SiteCollectionViewItem ()

@end

@implementation SiteCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)setSelected:(BOOL)selected {
      [super setSelected:selected];
      [self updateColor];
}


- (void)updateColor {
      if (self.selected) {
            [self.bgBox setFillColor:[NSColor colorFromHexString:@"cccccc"]];
      }else{
            [self.bgBox setFillColor:[NSColor colorFromHexString:@"eeeeee"]];
      }
}




@end
