//
//  INFSimpleLayoutStrategy.m
//  INFView
//
//  Created by Alexander on 2/9/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFSimpleLayoutStrategy.h"

@interface INFSimpleLayoutStrategy ()

@end

@implementation INFSimpleLayoutStrategy

- (INFViewLayout*)createLayout {
    INFViewLayout* layout = [INFViewLayout new];
    layout.orientation = self.orientation;
    layout.scrollViewSize = self.scrollViewSize;
    
    NSMutableArray<INFLayoutViewInfo*>* viewsLayoutInfo = [NSMutableArray new];
    
    for (NSInteger i = 0; i < self.sizesStorage.countOfViews; i++) {
        INFLayoutViewInfo* viewInfo = [[INFLayoutViewInfo alloc] initWithIndex:i size:[self.sizesStorage sizeOfViewAtIndex:i]];
        CGFloat position = [layout lengthOfAllViews] + [viewInfo getLengthForOrientation:layout.orientation] / 2;
        
        [viewsLayoutInfo addObject:viewInfo];
        layout.viewsLayoutInfo = viewsLayoutInfo;
        [viewInfo setPosition:position forOrientation:self.orientation];
        
        if (self.orientation == INFOrientationHorizontal) {
            [viewInfo setPosition:(self.scrollViewSize.height / 2) forOrientation:INFOrientationVertical];
        } else {
            [viewInfo setPosition:(self.scrollViewSize.width / 2) forOrientation:INFOrientationHorizontal];
        }
    }
    
    return layout;
}

- (CGFloat)lengthOfScrollView {
    if (self.orientation == INFOrientationHorizontal) {
        return self.scrollViewSize.width;
    } else {
        return self.scrollViewSize.height;
    }
}

#pragma mark - leading/trailing views calculations

- (void)calculateCountOfLeadingViewsInLayout:(INFViewLayout*)layout {
    CGFloat requiredSize = [self lengthOfScrollView] / 2.0;
    NSInteger i = 0;
    while (YES) {
        if (i >= self.sizesStorage.countOfViews) {
            break;
        }
        [layout setAccurateSize:[self.sizesStorage accurateSizeOfViewAtIndex:i] forViewAtIndex:i];
        i += 1;
        if ([layout lengthOfViewsInRange: NSMakeRange(0, i)] >= requiredSize) {
            break;
        }
    }

    layout.leadingViewsRange = NSMakeRange(0, i);
}

- (NSInteger)calculateCountOfTrailingViewsInLayout:(INFViewLayout*)layout {
    CGFloat requiredSize = [self lengthOfScrollView] / 2.0;
    NSInteger count = 0;
    while (YES) {
        if (count >= layout.viewsLayoutInfo.count) {
            break;
        }
        count += 1;
        NSInteger index = layout.viewsLayoutInfo.count - count;
        CGSize accurateSize = [self.sizesStorage accurateSizeOfViewAtIndex:index];
        [layout setAccurateSize:accurateSize forViewAtIndex:index];
        
        if ([layout lengthOfViewsInRange:NSMakeRange(layout.viewsLayoutInfo.count - count, count)] >= requiredSize) {
            break;
        }
    }
    
    layout.trailingViewsRange = NSMakeRange(layout.viewsLayoutInfo.count - count, count);
    return count;
}

- (CGFloat)leadingSpacingInLayout:(INFViewLayout*)layout {
    if ([self canHaveScrollingInLayout:layout]) {
        return [layout lengthOfTrailingViews];
    }
    return 0;
}

- (CGFloat)trailingSpacingInLayout:(INFViewLayout*)layout {
    if ([self canHaveScrollingInLayout:layout]) {
        return [layout lengthOfTrailingViews];
    }
    return 0;
}

#pragma mark - layout logic

- (BOOL)canHaveScrollingInLayout:(INFViewLayout*)layout {
    CGFloat totalSize = [layout lengthOfAllViews];
    
    BOOL canHaveScrolling = ([layout lengthOfLeadingViews] >= [self lengthOfScrollView] / 2.0)
    && ([layout lengthOfTrailingViews] >= [self lengthOfScrollView] / 2.0)
    && ((totalSize - [layout lengthOfTrailingViews]) >= [self lengthOfScrollView])
    && ((totalSize - [layout lengthOfLeadingViews]) >= [self lengthOfScrollView]);
    
    return canHaveScrolling;
}

- (CGFloat)calculateAdjustedContentOffsetPositionForLayout:(INFViewLayout *)layout {
    if (![self canHaveScrollingInLayout:layout]) {
        return [layout getContentOffsetPosition];
    }
    
    CGFloat contentOffset = [layout getContentOffsetPosition];
    CGFloat contentLength = [layout lengthOfAllViews];
    CGFloat leadingSpacing = [self leadingSpacingInLayout:layout];
    CGFloat trailingSpacing = [self trailingSpacingInLayout:layout];
    
    if (contentOffset <= 0) {
        CGFloat newContentOffsetPosition = leadingSpacing + (contentLength - (leadingSpacing - contentOffset));
        return newContentOffsetPosition;
        
    } else if ((contentOffset + [self lengthOfScrollView]) >= (leadingSpacing + contentLength + (trailingSpacing))) {
        CGFloat newContentOffsetPosition = leadingSpacing + (contentOffset - (contentLength + trailingSpacing));
        return newContentOffsetPosition;
    }
    
    return [layout getContentOffsetPosition];
}

- (void)moveLeadingAndTrailingViewsAccourdingToContentOffsetInLayout:(INFViewLayout *)layout {
    if (![self canHaveScrollingInLayout:layout]) {
        return;
    }
    
    CGFloat contentOffset = [layout getContentOffsetPosition];
    CGFloat leadingSpacing = [self leadingSpacingInLayout:layout];
    CGFloat contentLength = [layout lengthOfAllViews];
    
    if (contentOffset + [self lengthOfScrollView] >= leadingSpacing + contentLength) {
        CGFloat position = leadingSpacing + [layout lengthOfAllViews];
        [layout moveViewsInRange:layout.leadingViewsRange position:position];
        
    } else if (contentOffset <= leadingSpacing) {
        [layout moveViewsInRange:layout.trailingViewsRange position:0];
    }
}

- (INFViewLayout*)layoutArrangedViewsForContentOffset:(CGPoint)contentOffset {
    INFViewLayout* layout = [self createLayout];
    
    [self calculateCountOfLeadingViewsInLayout:layout];
    [self calculateCountOfTrailingViewsInLayout:layout];
    [self loadAccurateSizesOfViewsInLayout:layout forViewAreaStartingFrom:0 to:[self lengthOfScrollView]];
    
    layout.contentOffset = contentOffset;
    
    [layout shiftViewsWithOffset:[self leadingSpacingInLayout:layout]];
    [self loadAccurateSizesOfViewsInVisibleAreaOfLayout:layout];
    [layout setContentOffsetPosition:[self calculateAdjustedContentOffsetPositionForLayout:layout]];
    [self moveLeadingAndTrailingViewsAccourdingToContentOffsetInLayout:layout];

    CGFloat contentLength = [self leadingSpacingInLayout:layout] + [layout lengthOfAllViews] + [self trailingSpacingInLayout:layout];
    [layout setContentLength:contentLength];
    
    layout.canHaveInfiniteScrolling = [self canHaveScrollingInLayout:layout];

    return layout;
}

- (void)loadAccurateSizesOfViewsInLayout:(INFViewLayout*)layout forViewAreaStartingFrom:(CGFloat)startPosition to:(CGFloat)endPosition {
    NSArray<INFLayoutViewInfo*>* previousViews = nil;
    NSArray<INFLayoutViewInfo*>* views = nil;
    
    while (previousViews == nil || previousViews.count != views.count) {
        previousViews = views;
        views = [layout getViewsInAreaFrom:startPosition to:endPosition];
        for (INFLayoutViewInfo* viewInfo in views) {
            CGSize accurateSize = [self.sizesStorage accurateSizeOfViewAtIndex:viewInfo.index];
            [layout setAccurateSize:accurateSize forViewAtIndex:viewInfo.index];
        }
    }
}

- (void)loadAccurateSizesOfViewsInVisibleAreaOfLayout:(INFViewLayout*)layout {
    CGFloat originalContentLength = 0;
    CGFloat currentContentLength = [layout lengthOfAllViews];
    
    CGFloat areaSize = [self lengthOfScrollView];
    CGFloat areaExtent = [self lengthOfScrollView] * 0.5;
    
    while (originalContentLength != currentContentLength) {
        originalContentLength = currentContentLength;
        
        CGFloat contentOffsetPosition = [self calculateAdjustedContentOffsetPositionForLayout:layout];
        
        CGFloat areaStartPosition = contentOffsetPosition - areaExtent;
        CGFloat areaEndPosition = contentOffsetPosition + areaSize + areaExtent;
        
        CGFloat minPossiblePosition = [layout lengthOfLeadingViews];
        CGFloat maxPossiblePosition = [layout lengthOfLeadingViews] + [layout lengthOfAllViews];
        
        CGFloat startPosition = MAX(minPossiblePosition, areaStartPosition);
        CGFloat endPosition = MIN(maxPossiblePosition, areaEndPosition);
        
        [self loadAccurateSizesOfViewsInLayout:layout forViewAreaStartingFrom:startPosition to:endPosition];
        
        if (startPosition > areaStartPosition) {
            CGFloat rigthSideAreaStart = maxPossiblePosition - (startPosition - areaStartPosition);
            [self loadAccurateSizesOfViewsInLayout:layout forViewAreaStartingFrom:rigthSideAreaStart to:maxPossiblePosition];
        }
        if (endPosition < areaEndPosition) {
            CGFloat leftSizeAreaEnd = minPossiblePosition + (endPosition - areaEndPosition);
            [self loadAccurateSizesOfViewsInLayout:layout forViewAreaStartingFrom:minPossiblePosition to:leftSizeAreaEnd];
        }
        
        currentContentLength = [layout lengthOfAllViews];
    }
}

@end
