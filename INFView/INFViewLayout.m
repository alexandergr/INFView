//
//  INFViewLayout.m
//  INFView
//
//  Created by Alexander on 2/9/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFViewLayout.h"

@implementation INFViewLayout

- (void)setContentOffsetPosition:(CGFloat)position {
    if (self.orientation == INFOrientationHorizontal) {
        self.contentOffset = CGPointMake(position, self.contentOffset.y);
    } else {
        self.contentOffset = CGPointMake(self.contentOffset.x, position);
    }
}

- (CGFloat)getContentOffsetPosition {
    if (self.orientation == INFOrientationHorizontal) {
        return self.contentOffset.x;
    } else {
        return self.contentOffset.y;
    }
}

- (void)setContentLength:(CGFloat)contentLength {
    if (self.orientation == INFOrientationHorizontal) {
        self.contentSize = CGSizeMake(contentLength, self.scrollViewSize.height);
    } else {
        self.contentSize = CGSizeMake(self.scrollViewSize.width, contentLength);
    }
}

- (CGFloat)getLengthOfViewsInRange:(NSRange)range {
    CGFloat length = 0.0;
    for (NSInteger i = range.location; i < range.location + range.length; i++) {
        length += [self.viewsLayoutInfo[i] getLengthForOrientation:self.orientation];
    }
    return length;
}

- (CGFloat)getLengthOfAllViews {
    NSRange range = NSMakeRange(0, self.viewsLayoutInfo.count);
    return [self getLengthOfViewsInRange:range];
}

- (void)moveViewsInRange:(NSRange)range position:(CGFloat)position  {
    CGFloat groupSize = 0;
    for (NSInteger j = 0; j < range.length; j++) {
        NSInteger i = range.location + j;
        
        CGFloat viewLength = [self.viewsLayoutInfo[i] getLengthForOrientation:self.orientation];
        CGFloat newPosition = position + groupSize + viewLength / 2.0;
        [self.viewsLayoutInfo[i] setPosition:newPosition forOrientation:self.orientation];
        groupSize += viewLength;
    }
}

- (void)shiftViewsWithOffset:(CGFloat)offset {
    for (INFLayoutViewInfo* viewInfo in self.viewsLayoutInfo) {
        CGFloat positionWithShift = [viewInfo getPositionForOrientation:self.orientation] + offset;
        [viewInfo setPosition:positionWithShift forOrientation:self.orientation];
    }
}

@end
