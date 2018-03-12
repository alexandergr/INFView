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

- (CGFloat)lengthOfViewsInRange:(NSRange)range {
    CGFloat length = 0.0;
    for (NSInteger i = range.location; i < range.location + range.length; i++) {
        length += [self.viewsLayoutInfo[i] getLengthForOrientation:self.orientation];
    }
    return length;
}

- (CGFloat)lengthOfAllViews {
    NSRange range = NSMakeRange(0, self.viewsLayoutInfo.count);
    return [self lengthOfViewsInRange:range];
}

- (CGFloat)lengthOfLeadingViews {
    return [self lengthOfViewsInRange:self.leadingViewsRange];
}

- (CGFloat)lengthOfTrailingViews {
    return [self lengthOfViewsInRange:self.trailingViewsRange];
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

- (void)setAccurateSize:(CGSize)size forViewAtIndex:(NSInteger)index {
    CGFloat oldLength = [self.viewsLayoutInfo[index] getLengthForOrientation:self.orientation];
    self.viewsLayoutInfo[index].size = size;
    CGFloat newLength = [self.viewsLayoutInfo[index] getLengthForOrientation:self.orientation];
    CGFloat lengthDiff = newLength - oldLength;

    if (lengthDiff == 0) {
        return;
    }
    
    CGFloat contentOffsetPosition = [self getContentOffsetPosition];
    CGFloat viewStartPosition = [self.viewsLayoutInfo[index] getPositionForOrientation:self.orientation] - oldLength / 2.0;
    CGFloat viewEndPosition = [self.viewsLayoutInfo[index] getPositionForOrientation:self.orientation] + oldLength / 2.0;
    if (contentOffsetPosition > viewEndPosition) {
        [self setContentOffsetPosition:contentOffsetPosition + lengthDiff];
    } else if (contentOffsetPosition >= viewStartPosition) {
        CGFloat percentOfShift = (contentOffsetPosition - viewStartPosition) / oldLength;
        [self setContentOffsetPosition:contentOffsetPosition + lengthDiff * percentOfShift];
    }
    
    [self updateContentSizeWithLengthDiff:lengthDiff];
    
    [self.viewsLayoutInfo[index] shiftPosition:(lengthDiff / 2.0) forOrientation:self.orientation];
    for (NSInteger i = index + 1; i < self.viewsLayoutInfo.count; i++) {
        [self.viewsLayoutInfo[i] shiftPosition:lengthDiff forOrientation:self.orientation];
    }
}

- (void)updateContentSizeWithLengthDiff:(CGFloat)lengthDiff {
    if (self.orientation == INFOrientationHorizontal) {
        self.contentSize = CGSizeMake(self.contentSize.width + lengthDiff, self.contentSize.height);
    } else {
        self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height + lengthDiff);
    }
}

- (NSArray<INFLayoutViewInfo*>*)getViewsInAreaFrom:(CGFloat)startPosition to:(CGFloat)endPosition {
    NSMutableArray<INFLayoutViewInfo*>* views = [NSMutableArray new];
    
    for (INFLayoutViewInfo* viewInfo in self.viewsLayoutInfo) {
        CGFloat viewPosition = [viewInfo getPositionForOrientation:self.orientation];
        CGFloat viewLength = [viewInfo getLengthForOrientation:self.orientation];
        CGFloat viewStart = viewPosition - viewLength / 2.0;
        CGFloat viewEnd = viewPosition + viewLength / 2.0;
        
        if (
            ((viewStart >= startPosition) && (viewStart < endPosition))
            ||
            ((viewEnd > startPosition) && (viewEnd <= endPosition))
            ) {
            [views addObject:viewInfo];
        }
    }
    
    return views;
}

@end
