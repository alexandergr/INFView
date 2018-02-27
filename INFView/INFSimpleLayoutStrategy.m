//
//  INFSimpleLayoutStrategy.m
//  INFView
//
//  Created by Alexander on 2/9/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFSimpleLayoutStrategy.h"

@interface INFSimpleLayoutStrategy ()

@property (strong, nonatomic) NSMutableArray<INFViewLayoutAttributes*>* attributes;

@end

@implementation INFSimpleLayoutStrategy

- (NSInteger)countOfLeadingViews {
    NSInteger count = 0;
    NSInteger totalCount = [self countOfArrangedViews];
    CGFloat requiredSize;
    if (self.orientation == INFOrientationHorizontal) {
        requiredSize = self.scrollViewSize.width / 2.0;
    } else {
        requiredSize = self.scrollViewSize.height / 2.0;
    }
    while (count < totalCount && [self lengthOfArrangedViewsInRange:NSMakeRange(0, count)] < requiredSize) {
        count += 1;
    }
    return count;
}

- (NSInteger)countOfTrailingViews {
    NSInteger count = 0;
    NSInteger totalCount = [self countOfArrangedViews];
    CGFloat requiredSize;
    if (self.orientation == INFOrientationHorizontal) {
        requiredSize = self.scrollViewSize.width / 2.0;
    } else {
        requiredSize = self.scrollViewSize.height / 2.0;
    }
    while (count < totalCount && [self lengthOfArrangedViewsInRange:NSMakeRange(totalCount - count, count)] < requiredSize) {
        count += 1;
    }
    return count;
}

- (INFViewLayout*)layoutArrangedViewsForContentOffset:(CGPoint)contentOffset {
    INFViewLayout* layout = [INFViewLayout new];
    layout.contentOffset = contentOffset;

    self.attributes = [NSMutableArray new];
    CGFloat contentLength = 0.0;
    
    for (NSInteger i = 0; i < [self countOfArrangedViews]; i++) {
        CGFloat arrangedViewLength = [self lengthOfArrangedView:i];
        
        INFViewLayoutAttributes* viewAttributes = [INFViewLayoutAttributes new];
        viewAttributes.index = i;
        
        [viewAttributes setPosition:(contentLength + arrangedViewLength / 2) forOrientation:self.orientation];
        if (self.orientation == INFOrientationHorizontal) {
            [viewAttributes setPosition:(self.scrollViewSize.height / 2) forOrientation:INFOrientationVertical];
        } else {
            [viewAttributes setPosition:(self.scrollViewSize.width / 2) forOrientation:INFOrientationHorizontal];
        }
        
        [self.attributes addObject:viewAttributes];
        contentLength += arrangedViewLength;
    }

    CGFloat leadingSpacing = 0;
    CGFloat tralingSpacing = 0;

    CGFloat totalSize = [self lengthOfAllArrangedViews];
    
    NSRange leadingViewsRange = NSMakeRange(0, [self countOfLeadingViews]);
    CGFloat lengthOfLeadingViews = [self lengthOfArrangedViewsInRange:leadingViewsRange];
    
    NSRange trailingViewsRange = NSMakeRange([self countOfArrangedViews] - [self countOfTrailingViews], [self countOfTrailingViews]);
    CGFloat lengthOfTrailingViews = [self lengthOfArrangedViewsInRange:trailingViewsRange];
    
    CGFloat lengthOfScrollView;
    if (self.orientation == INFOrientationHorizontal) {
        lengthOfScrollView = self.scrollViewSize.width;
    } else {
        lengthOfScrollView = self.scrollViewSize.height;
    }
    
    BOOL canHaveScrolling = (lengthOfLeadingViews >= lengthOfScrollView / 2.0)
    && (lengthOfTrailingViews >= lengthOfScrollView / 2.0) && ((totalSize - lengthOfTrailingViews) >= lengthOfScrollView) && ((totalSize - lengthOfLeadingViews) >= lengthOfScrollView);
    
    if (canHaveScrolling) {
        leadingSpacing = lengthOfTrailingViews;
        tralingSpacing = lengthOfLeadingViews;

        for (INFViewLayoutAttributes* viewAttributes in self.attributes) {
            CGFloat positionWithShift = [viewAttributes getPositionForOrientation:self.orientation] + leadingSpacing;
            [viewAttributes setPosition:positionWithShift forOrientation:self.orientation];
        }

        if ([layout getContentOffsetPositionForOrientation:self.orientation] == 0) {
            [layout setContentOffsetPosition:leadingSpacing forOrientation:self.orientation];

        } else if ([layout getContentOffsetPositionForOrientation:self.orientation] <= leadingSpacing / 4.0) {
            CGFloat newContentOffsetPosition = leadingSpacing + ([self lengthOfAllArrangedViews] - (leadingSpacing - [layout getContentOffsetPositionForOrientation:self.orientation]));
            [layout setContentOffsetPosition:newContentOffsetPosition forOrientation:self.orientation];

        } else if ([layout getContentOffsetPositionForOrientation:self.orientation] + lengthOfScrollView >= leadingSpacing + [self lengthOfAllArrangedViews] + (tralingSpacing * 0.75)) {
            CGFloat newContentOffsetPosition = leadingSpacing + ([layout getContentOffsetPositionForOrientation:self.orientation] - ([self lengthOfAllArrangedViews] + leadingSpacing));
            [layout setContentOffsetPosition:newContentOffsetPosition forOrientation:self.orientation];
        }

        if ([layout getContentOffsetPositionForOrientation:self.orientation] + lengthOfScrollView >= leadingSpacing + [self lengthOfAllArrangedViews]) {
            NSRange range = NSMakeRange(0, [self countOfLeadingViews]);
            CGFloat position = leadingSpacing + [self lengthOfAllArrangedViews];
            CGFloat groupSize = 0;
            for (NSInteger j = 0; j < range.length; j++) {
                NSInteger i = range.location + j;
                
                CGFloat viewLength = [self lengthOfArrangedView:i];
                CGFloat newPosition = position + groupSize + viewLength / 2.0;
                INFViewLayoutAttributes* viewAttributes = self.attributes[i];
                [viewAttributes setPosition:newPosition forOrientation:self.orientation];
                groupSize += viewLength;
            }

        } else if ([layout getContentOffsetPositionForOrientation:self.orientation] <= leadingSpacing) {
            NSRange range = NSMakeRange([self countOfArrangedViews] - [self countOfTrailingViews], [self countOfTrailingViews]);
            CGFloat position = 0.0;
            CGFloat groupSize = 0;
            for (NSInteger j = 0; j < range.length; j++) {
                NSInteger i = range.location + j;
                
                CGFloat viewLength = [self lengthOfArrangedView:i];
                CGFloat newPosition = position + groupSize + viewLength / 2.0;
                INFViewLayoutAttributes* viewAttributes = self.attributes[i];
                [viewAttributes setPosition:newPosition forOrientation:self.orientation];
                groupSize += viewLength;
            }
        }
    }

    layout.viewsAttributes = self.attributes;
    contentLength = leadingSpacing + [self lengthOfAllArrangedViews] + tralingSpacing;
    
    [layout setContentLength:contentLength forOrientation:self.orientation];
    if (self.orientation == INFOrientationVertical) {
        [layout setContentLength:self.scrollViewSize.width forOrientation:INFOrientationHorizontal];
    } else {
        [layout setContentLength:self.scrollViewSize.height forOrientation:INFOrientationVertical];
    }

    return layout;
}

#pragma mark - View sizes calculations
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
