//
//  INFScrollView.m
//  INFView
//
//  Created by Alexander on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFScrollView.h"
#import "INFLayoutManager.h"

@interface INFScrollView () <INFLayoutTarget, INFLayoutDataSource, INFLayoutDelegate>

@property (strong, nonatomic) INFLayoutManager* layoutManager;

@property (strong, nonatomic) NSMutableDictionary<NSNumber*, UIView*>* visibleViews;
@property (strong, nonatomic) NSMutableDictionary<NSNumber*, UIView*>* viewCache;

@end

@implementation INFScrollView

@dynamic delegate;

- (void)setDataSource:(id<INFScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData {
    for (NSNumber* key in self.visibleViews) {
        UIView* subView = self.visibleViews[key];
        [subView removeFromSuperview];
    }

    self.visibleViews = [NSMutableDictionary new];
    self.viewCache = [NSMutableDictionary new];
    
    self.layoutManager = [INFLayoutManager new];
    self.layoutManager.orientation = self.orientation;
    self.layoutManager.scrollViewSize = self.bounds.size;
    self.layoutManager.dataSource = self;
    self.layoutManager.target = self;
    self.layoutManager.delegate = self;
    [self.layoutManager arrangeViews];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.layoutManager.scrollViewSize = bounds.size;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.layoutManager updateArrangedViewsForNewContentOffset:self.contentOffset];
}

#pragma mark - arranged views management
- (UIView*)getArrangedViewForIndex:(NSInteger)index {
    if (self.viewCache[@(index)] == nil) {
        self.viewCache[@(index)] = [self.dataSource infScrollView:self arrangedViewForIndex:index];
        
    }
    return self.viewCache[@(index)];
}

- (void)displayArrangedViewForIndex:(NSInteger)index {
    UIView* arrangedView = [self getArrangedViewForIndex:index];
    [self addSubview:arrangedView];
    self.visibleViews[@(index)] = arrangedView;
}

- (void)hideArrangedViewForIndex:(NSInteger)index {
    UIView* arrangedView = self.visibleViews[@(index)];
    [arrangedView removeFromSuperview];
    [self.visibleViews removeObjectForKey:@(index)];
}

#pragma mark - INFViewLayoutMangerDelegate

- (NSInteger)numberOfArrangedViews {
    return [self.dataSource numberOfArrangedViewsInINFScrollView:self];
}

- (void)updateContentSize:(CGSize)contentSize {
    self.contentSize = contentSize;
}

- (void)updateContentOffset:(CGPoint)contentOffset {
    self.contentOffset = contentOffset;
}

- (void)updateArrangedViewWithLayoutInfo:(INFLayoutViewInfo *)viewInfo{
    UIView* subView = self.visibleViews[@(viewInfo.index)];
    subView.center = viewInfo.center;
}

#pragma mark - INFViewLayoutDataSource

- (CGSize)sizeForViewAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(infScrollView:sizeForViewAtIndex:)]) {
        return [self.dataSource infScrollView:self sizeForViewAtIndex:index];
    }
    return self.bounds.size;
}

- (CGSize)estimatedSizeForViewAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(infScrollView:estimatedSizeForViewAtIndex:)]) {
        return [self.dataSource infScrollView:self estimatedSizeForViewAtIndex:index];
    }
    return [self sizeForViewAtIndex:index];
}

#pragma mark - INFScrollViewDelegate

- (void)willShowViewAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(infScrollView:willShowViewAtIndex:)]) {
        [self.delegate infScrollView:self willShowViewAtIndex:index];
    }
    [self displayArrangedViewForIndex:index];
}

- (void)didShowViewAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(infScrollView:didShowViewAtIndex:)]) {
        [self.delegate infScrollView:self didShowViewAtIndex:index];
    }
}

- (void)willHideViewAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(infScrollView:willHideViewAtIndex:)]) {
        [self.delegate infScrollView:self willHideViewAtIndex:index];
    }
}

- (void)didHideViewAtIndex:(NSInteger)index {
    [self hideArrangedViewForIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(infScrollView:didHideViewAtIndex:)]) {
        [self.delegate infScrollView:self didHideViewAtIndex:index];
    }
}

@end
