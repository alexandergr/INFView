//
//  INFViewLayout.m
//  INFView
//
//  Created by Alexander on 2/9/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFViewLayout.h"

@implementation INFViewLayout

- (void)setContentOffsetPosition:(CGFloat)position forOrientation:(INFOrientation)orientation {
    if (orientation == INFOrientationHorizontal) {
        self.contentOffset = CGPointMake(position, self.contentOffset.y);
    } else {
        self.contentOffset = CGPointMake(self.contentOffset.x, position);
    }
}

- (CGFloat)getContentOffsetPositionForOrientation:(INFOrientation)orientation {
    if (orientation == INFOrientationHorizontal) {
        return self.contentOffset.x;
    } else {
        return self.contentOffset.y;
    }
}

- (void)setContentLength:(CGFloat)contentLength forOrientation:(INFOrientation)orientation {
    if (orientation == INFOrientationHorizontal) {
        self.contentSize = CGSizeMake(contentLength, self.contentSize.height);
    } else {
        self.contentSize = CGSizeMake(self.contentSize.width, contentLength);
    }
}

@end
