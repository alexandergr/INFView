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
@property (strong, nonatomic) NSMutableDictionary<NSNumber*, NSValue*>* accurateSizes;

@end

@implementation INFLayoutManager

- (instancetype) initWithLayoutStrategyType:(INFLayoutStrategyType)layoutStrategyType {
    self = [super init];
    if (self != nil) {
        self.accurateSizes = [NSMutableDictionary new];
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
    self.accurateSizes = [NSMutableDictionary new];
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
    NSArray<INFLayoutViewInfo*>* newViews = [layout getViewsInVisibleArea];
    NSArray<INFLayoutViewInfo*>* oldViews = [oldLayout getViewsInVisibleArea];
    
    return [self getViewsFormViewsArray:newViews nonContainedIn:oldViews];
}

- (NSArray<INFLayoutViewInfo*>*)findDisappearingViewsInLayout:(INFViewLayout*)layout oldLayout:(INFViewLayout*)oldLayout {
    NSArray<INFLayoutViewInfo*>* newViews = [layout getViewsInVisibleArea];
    NSArray<INFLayoutViewInfo*>* oldViews = [oldLayout getViewsInVisibleArea];
    
    return [self getViewsFormViewsArray:oldViews nonContainedIn:newViews];
}

- (NSArray<INFLayoutViewInfo*>*)getViewsFormViewsArray:(NSArray<INFLayoutViewInfo*>*)views nonContainedIn:(NSArray<INFLayoutViewInfo*>*)otherArray {
    NSMutableArray<INFLayoutViewInfo*>* result = [NSMutableArray new];
    NSMutableDictionary<NSNumber*, INFLayoutViewInfo*>* otherDict = [NSMutableDictionary new];
    
    for (INFLayoutViewInfo* info in otherArray) {
        otherDict[@(info.index)] = info;
    }
    
    for (INFLayoutViewInfo* info in views) {
        if (otherDict[@(info.index)] == nil) {
            [result addObject:info];
        }
    }
    
    return result;
}

#pragma mark - INFViewsSizeStorage
- (NSValue*)getCachedAccurateSizeForIndex:(NSInteger)index {
    return self.accurateSizes[@(index)];
}

- (void)cacheAccurateSize:(CGSize)accurateSize forIndex:(NSInteger)index {
    self.accurateSizes[@(index)] = @(accurateSize);
}

- (NSInteger)countOfViews {
    return [self.dataSource numberOfArrangedViews];
}

- (CGSize)sizeOfViewAtIndex:(NSInteger)index {
    NSValue* cachedSize = [self getCachedAccurateSizeForIndex:index];
    if (cachedSize) {
        return cachedSize.CGSizeValue;
    }
    return [self.dataSource estimatedSizeForViewAtIndex:index];
}

- (CGSize)accurateSizeOfViewAtIndex:(NSInteger)index{
    NSValue* cachedSize = [self getCachedAccurateSizeForIndex:index];
    if (cachedSize) {
        return cachedSize.CGSizeValue;
    }

    CGSize accurateSize = [self.dataSource sizeForViewAtIndex:index];
    [self cacheAccurateSize:accurateSize forIndex:index];

    return accurateSize;
}

@end
