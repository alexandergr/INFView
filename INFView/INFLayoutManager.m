//
//  INFLayoutManager.m
//  INFView
//
//  Created by Oleksandr Hrushovyi on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFLayoutManager.h"
#import "INFSimpleLayoutStrategy.h"

@interface INFLayoutManager() <INFViewsSizeStorage>

@property (nonatomic) BOOL needToMakeLeadingShift;

@end

@implementation INFLayoutManager

- (instancetype) initWithLayoutStrategyType:(INFLayoutStrategyType)layoutStrategyType {
    self = [super init];
    if (self != nil) {
        self.needToMakeLeadingShift = YES;
        if (layoutStrategyType == INFLayoutStrategyTypeSimple) {
            self.layoutStrategy = [INFSimpleLayoutStrategy new];
        }
    }
    return self;
}

- (instancetype) init {
    return [self initWithLayoutStrategyType:INFLayoutStrategyTypeSimple];
}

- (void)arrangeViews {
    self.needToMakeLeadingShift = YES;
    [self updateArrangedViewsForNewContentOffset:CGPointMake(0.0, 0.0)];
}

- (INFViewLayout *)calculateLayoutForContentOffset:(CGPoint)contentOffset {
    self.layoutStrategy.scrollViewSize = self.scrollViewSize;
    self.layoutStrategy.sizesStorage = self;

    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:contentOffset];
    return layout;
}

- (void)updateArrangedViewsForNewContentOffset:(CGPoint)contentOffset {
    INFViewLayout * layout = [self calculateLayoutForContentOffset:contentOffset];
    
    if (self.needToMakeLeadingShift && layout.canHaveInfiniteScrolling) {
        [layout setContentOffsetPosition:layout.lengthOfLeadingViews];
        layout = [self calculateLayoutForContentOffset:layout.contentOffset];
        self.needToMakeLeadingShift = NO;
    }

    [self.layoutTarget updateContentSize:layout.contentSize];
    if (contentOffset.x != layout.contentOffset.x || contentOffset.y != layout.contentOffset.y) {
        [self.layoutTarget updateContentOffset:layout.contentOffset];
    }
    for (INFLayoutViewInfo* viewInfo in layout.viewsLayoutInfo) {
        [self.layoutTarget updateArrangedViewWithLayoutInfo:viewInfo];
    }
}

- (void)setOrientation:(INFOrientation)orientation {
    self.layoutStrategy.orientation = orientation;
}

- (INFOrientation)orientation {
    return self.layoutStrategy.orientation;
}

#pragma mark - INFViewsSizeStorage

- (NSInteger)countOfViews {
    return [self.layoutDataSource numberOfArrangedViews];
}

- (CGSize)sizeOfViewAtIndex:(NSInteger)index {
    return [self.layoutDataSource estimatedSizeForViewAtIndex:index];
}

- (CGSize)accurateSizeOfViewAtIndex:(NSInteger)index{
    return [self.layoutDataSource sizeForViewAtIndex:index];
}

@end
