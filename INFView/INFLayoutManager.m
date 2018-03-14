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
@property (nullable, strong, nonatomic) INFViewLayout* currentLayout;

@end

@implementation INFLayoutManager

- (instancetype) initWithLayoutStrategyType:(INFLayoutStrategyType)layoutStrategyType {
    self = [super init];
    if (self != nil) {
        self.needToMakeLeadingShift = YES;
        if (layoutStrategyType == INFLayoutStrategyTypeSimple) {
            self.strategy = [INFSimpleLayoutStrategy new];
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
    self.strategy.scrollViewSize = self.scrollViewSize;
    self.strategy.sizesStorage = self;

    INFViewLayout* layout = [self.strategy layoutArrangedViewsForContentOffset:contentOffset];
    return layout;
}

- (void)updateArrangedViewsForNewContentOffset:(CGPoint)contentOffset {
    INFViewLayout * layout = [self calculateLayoutForContentOffset:contentOffset];
    
    if (self.needToMakeLeadingShift && layout.canHaveInfiniteScrolling) {
        [layout setContentOffsetPosition:layout.lengthOfLeadingViews];
        layout = [self calculateLayoutForContentOffset:layout.contentOffset];
        self.needToMakeLeadingShift = NO;
    }
    
    NSArray<INFLayoutViewInfo*>* appearingViews = nil;
    NSArray<INFLayoutViewInfo*>* disappearingViews = nil;
    if (self.delegate) {
        appearingViews = [self findAppearingViewsInLayout:layout oldLayout:self.currentLayout];
        disappearingViews = [self findDisappearingViewsInLayout:layout oldLayout:self.currentLayout];
    }
    for (INFLayoutViewInfo* viewInfo in appearingViews) {
        [self.delegate willShowViewAtIndex:viewInfo.index];
    }
    for (INFLayoutViewInfo* viewInfo in disappearingViews) {
        [self.delegate willHideViewAtIndex:viewInfo.index];
    }

    [self.target updateContentSize:layout.contentSize];
    if (contentOffset.x != layout.contentOffset.x || contentOffset.y != layout.contentOffset.y) {
        [self.target updateContentOffset:layout.contentOffset];
    }
    for (INFLayoutViewInfo* viewInfo in layout.viewsLayoutInfo) {
        [self.target updateArrangedViewWithLayoutInfo:viewInfo];
    }
    
    for (INFLayoutViewInfo* viewInfo in appearingViews) {
        [self.delegate didShowViewAtIndex:viewInfo.index];
    }
    for (INFLayoutViewInfo* viewInfo in disappearingViews) {
        [self.delegate didHideViewAtIndex:viewInfo.index];
    }
    
    self.currentLayout = layout;
}

- (void)setOrientation:(INFOrientation)orientation {
    self.strategy.orientation = orientation;
}

- (INFOrientation)orientation {
    return self.strategy.orientation;
}

- (NSArray<INFLayoutViewInfo*>*)findAppearingViewsInLayout:(INFViewLayout*)layout oldLayout:(INFViewLayout*)oldLayout {
    NSMutableArray<INFLayoutViewInfo*>* addedViews = [NSMutableArray new];
    
    NSArray<INFLayoutViewInfo*>* newViews = [layout getViewsInVisibleArea];
    NSArray<INFLayoutViewInfo*>* oldViews = [oldLayout getViewsInVisibleArea];
    
    for (NSInteger i = 0; i < newViews.count; i++) {
        BOOL haveViewInOldLayout = NO;
        
        for (NSInteger j = 0; j < oldViews.count; j++) {
            if (oldViews[j].index == newViews[i].index) {
                haveViewInOldLayout = YES;
                break;
            }
        }
        
        if (!haveViewInOldLayout) {
            [addedViews addObject:newViews[i]];
        }
    }
    
    return addedViews;
}

- (NSArray<INFLayoutViewInfo*>*)findDisappearingViewsInLayout:(INFViewLayout*)layout oldLayout:(INFViewLayout*)oldLayout {
    NSMutableArray<INFLayoutViewInfo*>* removedViews = [NSMutableArray new];
    
    NSArray<INFLayoutViewInfo*>* newViews = [layout getViewsInVisibleArea];
    NSArray<INFLayoutViewInfo*>* oldViews = [oldLayout getViewsInVisibleArea];
    
    for (NSInteger i = 0; i < oldViews.count; i++) {
        BOOL haveViewInNewLayout = NO;
        
        for (NSInteger j = 0; j < newViews.count; j++) {
            if (newViews[j].index == oldViews[i].index) {
                haveViewInNewLayout = YES;
                break;
            }
        }
        
        if (!haveViewInNewLayout) {
            [removedViews addObject:oldViews[i]];
        }
    }
    
    return removedViews;
}

#pragma mark - INFViewsSizeStorage

- (NSInteger)countOfViews {
    return [self.dataSource numberOfArrangedViews];
}

- (CGSize)sizeOfViewAtIndex:(NSInteger)index {
    return [self.dataSource estimatedSizeForViewAtIndex:index];
}

- (CGSize)accurateSizeOfViewAtIndex:(NSInteger)index{
    return [self.dataSource sizeForViewAtIndex:index];
}

@end
