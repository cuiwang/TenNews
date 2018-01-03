//
//  SiteDetailCellView.h
//  TenNews
//
//  Created by 崔旺 on 2017/12/26.
//  Copyright © 2017年 崔旺. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SiteDetailCellView : NSTableCellView{
      BOOL mouseInside;
      NSTrackingArea *trackingArea;
}

@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSTextField *subTitleTextField;
@property (weak) IBOutlet NSView *coverView;

@end
