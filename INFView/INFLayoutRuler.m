//
//  INFLayoutRuler.m
//  INFView
//
//  Created by Alexander on 2/23/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INFLayoutRuler.h"

@implementation INFLayoutRuler

- (CGFloat)getPosition:(INFViewLayoutAttributes*)viewAttributes {
    if (self.orientation == INFOrientationHorizontal) {
        return viewAttributes.center.x;
    } else {
        return viewAttributes.center.y;
    }
}

- (void)viewAttributes:(INFViewLayoutAttributes*)viewAttributes setPosition:(CGFloat)position {
    if (self.orientation == INFOrientationHorizontal) {
        viewAttributes.center = CGPointMake(position, self.scrollViewSize.height / 2.0);
    } else {
        viewAttributes.center = CGPointMake(self.scrollViewSize.width / 2.0, position);
    }
}

- (void)layout:(INFViewLayout*)layout setContentLength:(CGFloat)contentLength {
    if (self.orientation == INFOrientationHorizontal) {
        layout.contentSize = CGSizeMake(contentLength, self.scrollViewSize.height);
    } else {
        layout.contentSize = CGSizeMake(self.scrollViewSize.width, contentLength);
    }
}

- (void)layout:(INFViewLayout*)layout setContentOffsetToPosition:(CGFloat)newPosition {
    if (self.orientation == INFOrientationHorizontal) {
        layout.contentOffset = CGPointMake(newPosition, layout.contentOffset.y);
    } else {
        layout.contentOffset = CGPointMake(layout.contentOffset.x, newPosition);
    }
}

- (CGFloat)getContentOffsetPositionFromLayout:(INFViewLayout*)layout {
    if (self.orientation == INFOrientationHorizontal) {
        return layout.contentOffset.x;
    } else {
        return layout.contentOffset.y;
    }
}

- (CGFloat)getLengthOfScrollView {
    if (self.orientation == INFOrientationHorizontal) {
        return self.scrollViewSize.width;
    } else {
        return self.scrollViewSize.height;
    }
}

- (NSUInteger)countOfArrangedViews {
    return self.sizesOfArrangedViews.count;
}

- (CGFloat)lengthOfArrangedView: (NSInteger)index {
    NSValue* arrangedViewSizeValue = self.sizesOfArrangedViews[index];
    CGSize arrangedViewSize = arrangedViewSizeValue.CGSizeValue;

    if (self.orientation == INFOrientationHorizontal) {
        return arrangedViewSize.width;
    } else {
        return arrangedViewSize.height;
    }
}

- (CGFloat)lengthOfArrangedViewsInRange:(NSRange)range {
    CGFloat length = 0.0;
    for (NSInteger i = range.location; i < range.location + range.length; i++) {
        length += [self lengthOfArrangedView:i];
    }
    return length;
}

- (CGFloat)lengthOfAllArrangedViews {
    NSRange range = NSMakeRange(0, [self countOfArrangedViews]);
    return [self lengthOfArrangedViewsInRange:range];
}

@end
