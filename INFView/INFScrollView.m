//
//  INFScrollView.m
//  INFView
//
//  Created by Alexander on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFScrollView.h"
#import "INFLayoutManager.h"

@interface INFScrollView () <INFLayoutTarget, INFLayoutDataSource>

@property (strong, nonatomic) NSMutableArray* arrangedViews;

@property (strong, nonatomic) INFLayoutManager* layoutManager;

@end

@implementation INFScrollView

- (void)setDataSource:(id<INFViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData {
    for (UIView* subView in self.arrangedViews) {
        [subView removeFromSuperview];
    }

    NSInteger numberOfArrangedSubViews = [self.dataSource numberOfArrangedViewsInINFScrollView:self];
    self.arrangedViews = [NSMutableArray new];
    for (NSInteger i = 0; i < numberOfArrangedSubViews; i++) {
        UIView* subView = [self.dataSource infScrollView:self arrangedViewForIndex:i];
        [self.arrangedViews addObject:subView];
        [self addSubview:subView];
    }
    
    self.layoutManager = [INFLayoutManager new];
    self.layoutManager.orientation = self.orientation;
    self.layoutManager.scrollViewSize = self.bounds.size;
    self.layoutManager.layoutDataSource = self;
    self.layoutManager.layoutTarget = self;
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

#pragma mark - INFViewLayoutMangerDelegate

- (NSInteger)numberOfArrangedViews {
    return self.numberOfArrangedSubViews;
}

- (void)updateContentSize:(CGSize)contentSize {
    self.contentSize = contentSize;
}

- (void)updateContentOffset:(CGPoint)contentOffset {
    self.contentOffset = contentOffset;
}

- (void)updateArrangedViewWithLayoutInfo:(INFLayoutViewInfo *)viewInfo{
    UIView* subView = self.arrangedViews[viewInfo.index];
    subView.center = viewInfo.center;
}

#pragma mark - INFViewLayoutDataSource

- (NSInteger)numberOfArrangedSubViews {
    return self.arrangedViews.count;
}

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

@end
