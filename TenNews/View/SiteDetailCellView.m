//
//  SiteDetailCellView.m
//  TenNews
//
//  Created by 崔旺 on 2017/12/26.
//  Copyright © 2017年 崔旺. All rights reserved.
//

#import "SiteDetailCellView.h"
#import "Colours.h"

@implementation SiteDetailCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}


- (void)setMouseInside:(BOOL)value {
      if (mouseInside != value) {
            mouseInside = value;
            [self setNeedsDisplay:YES];
      }
            if (value) {
                  self.coverView.layer.backgroundColor = [[NSColor colorFromHexString:@"#dddddd"] CGColor];
            }else {
                  self.coverView.layer.backgroundColor = [[NSColor whiteColor] CGColor];
            }
      
}

- (BOOL)mouseInside {
      return mouseInside;
}

- (void)ensureTrackingArea {
      if (trackingArea == nil) {
            trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
      }
}

- (void)updateTrackingAreas {
      [super updateTrackingAreas];
      [self ensureTrackingArea];
      if (![[self trackingAreas] containsObject:trackingArea]) {
            [self addTrackingArea:trackingArea];
      }
}

- (void)mouseEntered:(NSEvent *)theEvent {
      self.mouseInside = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
      self.mouseInside = NO;
}

@end
