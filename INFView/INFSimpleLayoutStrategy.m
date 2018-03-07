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
    
    for (NSInteger i = 0; i < self.sizesOfArrangedViews.count; i++) {
        INFLayoutViewInfo* viewInfo = [[INFLayoutViewInfo alloc] initWithIndex:i size:[self.sizesOfArrangedViews[i] CGSizeValue]];
        CGFloat position = [layout getLengthOfAllViews] + [viewInfo getLengthForOrientation:layout.orientation] / 2;
        
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

- (NSInteger)calculateCountOfLeadingViewsInLayout:(INFViewLayout*)layout {
    CGFloat requiredSize = [self lengthOfScrollView] / 2.0;
    NSInteger count = 0;
    while (count < layout.viewsLayoutInfo.count && [layout getLengthOfViewsInRange:NSMakeRange(0, count)] < requiredSize) {
        count += 1;
    }
    return count;
}

- (NSInteger)calculateCountOfTrailingViewsInLayout:(INFViewLayout*)layout {
    CGFloat requiredSize = [self lengthOfScrollView] / 2.0;
    NSInteger count = 0;
    while (count < layout.viewsLayoutInfo.count && [layout getLengthOfViewsInRange:NSMakeRange(layout.viewsLayoutInfo.count - count, count)] < requiredSize) {
        count += 1;
    }
    return count;
}

- (NSRange)rangeOfLeadingViewsInLayout:(INFViewLayout *)layout {
    return NSMakeRange(0, [self calculateCountOfLeadingViewsInLayout:layout]);
}

- (CGFloat)lengthOfLeadingViewsInLayout:(INFViewLayout*)layout {
    return [layout getLengthOfViewsInRange:[self rangeOfLeadingViewsInLayout:layout]];
}

- (NSRange)rangeOfTrainingViewsInLayout:(INFViewLayout *)layout {
    NSInteger numberOfTrailingViews = [self calculateCountOfTrailingViewsInLayout:layout];
    NSRange trailingViewsRange = NSMakeRange(layout.viewsLayoutInfo.count - numberOfTrailingViews, numberOfTrailingViews);
    return trailingViewsRange;
}

- (CGFloat)lengthOfTrailingViewsInLayout:(INFViewLayout*)layout {
    return [layout getLengthOfViewsInRange:[self rangeOfTrainingViewsInLayout:layout]];
}

- (CGFloat)leadingSpacingInLayout:(INFViewLayout*)layout {
    if ([self canHaveScrollingInLayout:layout]) {
        return [self lengthOfTrailingViewsInLayout:layout];
    }
    return 0;
}

- (CGFloat)trailingSpacingInLayout:(INFViewLayout*)layout {
    if ([self canHaveScrollingInLayout:layout]) {
        return [self lengthOfTrailingViewsInLayout:layout];
    }
    return 0;
}

#pragma mark - layout logic

- (BOOL)canHaveScrollingInLayout:(INFViewLayout*)layout {
    CGFloat totalSize = [layout getLengthOfAllViews];
    
    BOOL canHaveScrolling = ([self lengthOfLeadingViewsInLayout:layout] >= [self lengthOfScrollView] / 2.0)
    && ([self lengthOfTrailingViewsInLayout:layout] >= [self lengthOfScrollView] / 2.0)
    && ((totalSize - [self lengthOfTrailingViewsInLayout:layout]) >= [self lengthOfScrollView])
    && ((totalSize - [self lengthOfLeadingViewsInLayout:layout]) >= [self lengthOfScrollView]);
    
    return canHaveScrolling;
}

- (void)adjustContentOffsetInLayout:(INFViewLayout *)layout {
    if (![self canHaveScrollingInLayout:layout]) {
        return;
    }
    
    CGFloat contentOffset = [layout getContentOffsetPosition];
    CGFloat contentLength = [layout getLengthOfAllViews];
    CGFloat leadingSpacing = [self leadingSpacingInLayout:layout];
    CGFloat trailingSpacing = [self trailingSpacingInLayout:layout];
    
    if (contentOffset == 0) {
        [layout setContentOffsetPosition:leadingSpacing];
        
    } else if (contentOffset <= (leadingSpacing * 0.25)) {
        CGFloat newContentOffsetPosition = leadingSpacing + (contentLength - (leadingSpacing - contentOffset));
        [layout setContentOffsetPosition:newContentOffsetPosition];
        
    } else if ((contentOffset + [self lengthOfScrollView]) >= (leadingSpacing + contentLength + (trailingSpacing * 0.75))) {
        CGFloat newContentOffsetPosition = leadingSpacing + (contentOffset - (contentLength + trailingSpacing));
        [layout setContentOffsetPosition:newContentOffsetPosition];
    }
}

- (void)adjustPositionsOfLeadingAndTrailingViewsInLayout:(INFViewLayout *)layout {
    if (![self canHaveScrollingInLayout:layout]) {
        return;
    }
    
    CGFloat contentOffset = [layout getContentOffsetPosition];
    CGFloat leadingSpacing = [self leadingSpacingInLayout:layout];
    CGFloat contentLength = [layout getLengthOfAllViews];
    
    if (contentOffset + [self lengthOfScrollView] >= leadingSpacing + contentLength) {
        CGFloat position = leadingSpacing + [layout getLengthOfAllViews];
        [layout moveViewsInRange:[self rangeOfLeadingViewsInLayout:layout] position:position];
        
    } else if (contentOffset <= leadingSpacing) {
        [layout moveViewsInRange:[self rangeOfTrainingViewsInLayout:layout] position:0];
    }
}

- (INFViewLayout*)layoutArrangedViewsForContentOffset:(CGPoint)contentOffset {
    INFViewLayout* layout = [self createLayout];
    layout.contentOffset = contentOffset;

    if ([self canHaveScrollingInLayout:layout]) {
        [layout shiftViewsWithOffset:[self leadingSpacingInLayout:layout]];
        [self adjustContentOffsetInLayout:layout];
        [self adjustPositionsOfLeadingAndTrailingViewsInLayout:layout];
    }

    CGFloat contentLength = [self leadingSpacingInLayout:layout] + [layout getLengthOfAllViews] + [self trailingSpacingInLayout:layout];
    [layout setContentLength:contentLength];

    return layout;
}

@end
