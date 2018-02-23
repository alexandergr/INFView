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

- (NSUInteger)countOfArrangedViews {
    return self.sizesOfArrangedViews.count;
}

- (void)setupAttributesAtInitialPositions {
    self.attributes = [NSMutableArray new];
    CGFloat contentSize = 0.0;

    for (NSInteger i = 0; i < [self countOfArrangedViews]; i++) {
        CGFloat arrangedViewSize = [self sizeOfArrangedView:i];

        CGPoint attributeCenter = [self centerForPosition:(contentSize + arrangedViewSize / 2)];

        INFViewLayoutAttributes* viewAttributes = [INFViewLayoutAttributes new];
        viewAttributes.center = attributeCenter;
        viewAttributes.index = i;

        [self.attributes addObject:viewAttributes];
        contentSize += arrangedViewSize;
    }
}

- (CGFloat)sizeOfViewsInRange:(NSRange)range {
    CGFloat size = 0.0;
    for (NSInteger i = range.location; i < range.location + range.length; i++) {
        size += [self sizeOfArrangedView:i];
    }
    return size;
}

- (CGFloat)getSizeOfAllViews {
    NSRange range = NSMakeRange(0, [self countOfArrangedViews]);
    return [self sizeOfViewsInRange:range];
}

- (NSInteger)numberOfLeadingViews {
    NSInteger count = 0;
    NSInteger totalCount = [self countOfArrangedViews];
    CGFloat requiredSize = [self sizeOfScrollView] / 2.0;
    while (count < totalCount && [self sizeOfViewsInRange:NSMakeRange(0, count)] < requiredSize) {
        count += 1;
    }
    return count;
}

- (CGFloat)getSizeOfLeadingViews {
    return [self sizeOfViewsInRange:NSMakeRange(0, [self numberOfLeadingViews])];
}

- (double)minimalSizeOfSideContent {
    return [self sizeOfScrollView] / 2.0;
}

- (NSInteger)countOfTrailingViews {
    NSInteger count = 0;
    NSInteger totalCount = [self countOfArrangedViews];
    CGFloat requiredSize = [self minimalSizeOfSideContent];
    while (count < totalCount && [self sizeOfViewsInRange:NSMakeRange(totalCount - count, count)] < requiredSize) {
        count += 1;
    }
    return count;
}

- (CGFloat)getSizeOfTrailingViews {
    NSInteger countOfTrailingViews = [self countOfTrailingViews];
    NSInteger totalCount = [self countOfArrangedViews];
    return [self sizeOfViewsInRange:NSMakeRange(totalCount - countOfTrailingViews, countOfTrailingViews)];
}

- (BOOL)canHaveScrolling {
    CGFloat totalSize = [self getSizeOfAllViews];
    CGFloat sizeOfLeadingViews = [self getSizeOfLeadingViews];
    CGFloat sizeOfTrailingViews = [self getSizeOfTrailingViews];

    return (sizeOfLeadingViews >= [self minimalSizeOfSideContent])
    && (sizeOfTrailingViews >= [self minimalSizeOfSideContent]) && ((totalSize - sizeOfLeadingViews - sizeOfTrailingViews) >= [self sizeOfScrollView]);
}

- (INFViewLayout *)layoutArrangedViews {
    INFViewLayout* layout = [INFViewLayout new];

    [self setupAttributesAtInitialPositions];

    CGPoint newContentOffset = self.contentOffset;
    CGFloat sizeOfScrollView = [self sizeOfScrollView];

    NSInteger leadingViewsCount = [self numberOfLeadingViews];
    NSInteger tralingViewsCount = [self countOfTrailingViews];

    NSInteger centerViewsCount = 0;
    CGFloat centerViewsSize = 0;
    while (self.sizesOfArrangedViews.count > (leadingViewsCount + tralingViewsCount + centerViewsCount)) {
        NSInteger index = leadingViewsCount + centerViewsCount;
        centerViewsCount += 1;
        centerViewsSize += [self sizeOfArrangedView:index];
    }

    CGFloat contentSize = [self getSizeOfAllViews];

    if ([self canHaveScrolling]) {

        CGFloat leadingSpacing = [self getSizeOfTrailingViews];
        CGFloat tralingSpacing = [self getSizeOfLeadingViews];

        for (INFViewLayoutAttributes* viewAttributes in self.attributes) {
            CGFloat positionWithShift = [self positionFromCenter:viewAttributes.center] + leadingSpacing;
            viewAttributes.center = [self centerForPosition:positionWithShift];
        }

        CGFloat contentOffsetPosition = [self positionFromContentOffset];
        if (contentOffsetPosition == 0) {
            contentOffsetPosition = leadingSpacing;
            newContentOffset = [self contentOffsetFromPosition:contentOffsetPosition];

        } else if (contentOffsetPosition < leadingSpacing / 4.0) {
            contentOffsetPosition = leadingSpacing + ([self getSizeOfAllViews] - (leadingSpacing - contentOffsetPosition));
            newContentOffset = [self contentOffsetFromPosition:contentOffsetPosition];

        } else if (contentOffsetPosition + sizeOfScrollView + (tralingSpacing/4.0) > leadingSpacing + [self getSizeOfAllViews] + tralingSpacing) {
            contentOffsetPosition = leadingSpacing + (contentOffsetPosition - ([self getSizeOfAllViews] + leadingSpacing));
            newContentOffset = [self contentOffsetFromPosition:contentOffsetPosition];

        }

        if (contentOffsetPosition + sizeOfScrollView >= leadingSpacing + [self getSizeOfAllViews]) {
            NSRange range = [self getLeadingViewsRange:leadingViewsCount];
            [self moveViewsInRange:range toPosition:(leadingSpacing + [self getSizeOfAllViews])];

//            CGFloat lastItemPosition = sizeOfScrollView + contentSize - sizeOfScrollView / 2.0;
//            lastItemAttributes.center = [self centerForPosition:lastItemPosition];
//
//            CGFloat firstItemPosition = sizeOfScrollView + contentSize - sizeOfScrollView / 2.0;
//            firstItemAttributes.center = [self centerForPosition:firstItemPosition];
//
        } else if (contentOffsetPosition <= leadingSpacing) {
            NSRange range = [self getTrailingViewsRange:tralingViewsCount];
            [self moveViewsInRange:range toPosition:0.0];

//            CGFloat lastItemPosition = sizeOfScrollView - sizeOfScrollView / 2.0;
//            lastItemAttributes.center = [self centerForPosition:lastItemPosition];
//
//            CGFloat firstItemPosition = sizeOfScrollView + sizeOfScrollView / 2.0;
//            firstItemAttributes.center = [self centerForPosition:firstItemPosition];
        }

        contentSize += leadingSpacing + tralingSpacing;
    }

    layout.viewsAttributes = self.attributes;
    layout.contentSize = [self contentSizeForContentLength:contentSize];
    layout.contentOffset = newContentOffset;

    return layout;
}

- (NSRange) getLeadingViewsRange:(NSInteger)count {
    NSRange range = NSMakeRange(0, count);
    return range;
}

- (NSRange) getTrailingViewsRange:(NSInteger)count {
    NSRange range = NSMakeRange(self.attributes.count - count, count);
    return range;
}

- (void) moveViewsInRange:(NSRange)range toPosition:(CGFloat)position {
    CGFloat groupSize = 0;
    for (NSInteger j = 0; j < range.length; j++) {
        NSInteger i = range.location + j;

        CGFloat viewSize = [self sizeOfArrangedView:i];
        CGFloat newPosition = position + groupSize + viewSize / 2.0;
        INFViewLayoutAttributes* viewAttributes = self.attributes[i];
        viewAttributes.center = [self centerForPosition:newPosition];
        groupSize += viewSize;
    }
}

- (CGFloat)sizeOfScrollView {
    if (self.orientation == INFOrientationHorizontal) {
        return self.scrollViewSize.width;
    } else {
        return self.scrollViewSize.height;
    }
}

- (CGFloat)sizeOfArrangedView: (NSInteger)index {
    NSValue* arrangedViewSizeValue = self.sizesOfArrangedViews[index];
    CGSize arrangedViewSize = arrangedViewSizeValue.CGSizeValue;

    if (self.orientation == INFOrientationHorizontal) {
        return arrangedViewSize.width;
    } else {
        return arrangedViewSize.height;
    }
}

- (CGFloat)positionFromContentOffset {
    if (self.orientation == INFOrientationHorizontal) {
        return self.contentOffset.x;
    } else {
        return self.contentOffset.y;
    }
}

- (CGPoint)contentOffsetFromPosition:(CGFloat)newPosition {
    if (self.orientation == INFOrientationHorizontal) {
        return CGPointMake(newPosition, self.contentOffset.y);
    } else {
        return CGPointMake(self.contentOffset.x, newPosition);
    }
}

- (CGPoint)centerForPosition:(CGFloat)position {
    if (self.orientation == INFOrientationHorizontal) {
        return CGPointMake(position, self.scrollViewSize.height / 2.0);
    } else {
        return CGPointMake(self.scrollViewSize.width / 2.0, position);
    }
}

- (CGFloat)positionFromCenter:(CGPoint)center {
    if (self.orientation == INFOrientationHorizontal) {
        return center.x;
    } else {
        return center.y;
    }
}

- (CGSize)contentSizeForContentLength:(CGFloat)contentLength {
    if (self.orientation == INFOrientationHorizontal) {
        return CGSizeMake(contentLength, self.scrollViewSize.height);
    } else {
        return CGSizeMake(self.scrollViewSize.width, contentLength);
    }
}

@end
