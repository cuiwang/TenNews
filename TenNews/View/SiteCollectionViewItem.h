//
//  SiteCollectionViewItem.h
//  TenNews
//
//  Created by 崔旺 on 2017/12/28.
//  Copyright © 2017年 崔旺. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PVAsyncImageView.h"

@interface SiteCollectionViewItem : NSCollectionViewItem
@property (weak) IBOutlet PVAsyncImageView *imageView;
@property (weak) IBOutlet NSBox *bgBox;
@property (weak) IBOutlet NSTextField *titleTextField;

@end
