//
//  INFScrollView.m
//  INFView
//
//  Created by Alexander on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFScrollView.h"
#import "INFLayoutManager.h"

@interface INFScrollView () <INFLayoutTarget>

@property (nonatomic) NSInteger numberOfArrangedSubViews;
@property (strong, nonatomic) NSMutableArray* arrangedViews;

@property (strong, nonatomic) INFLayoutManager* layoutManager;

@end

@implementation INFScrollView

- (void)setDataSource:(id<INFViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

- (CGFloat)spaceForSubViewAtIndex:(NSInteger)index {
    return self.frame.size.width;
}

- (void)reloadData {
    for (UIView* subView in self.arrangedViews) {
        [subView removeFromSuperview];
    }

    self.numberOfArrangedSubViews = [self.dataSource numberOfSubViewsInINFView:self];
    self.arrangedViews = [NSMutableArray new];

    for (NSInteger i = 0; i < self.numberOfArrangedSubViews; i++) {
        UIView* subView = [self.dataSource infView:self subViewAtIndex:i];
        [self.arrangedViews addObject:subView];
        [self addSubview:subView];
    }
    
    self.layoutManager = [INFLayoutManager new];
    self.layoutManager.viewSize = self.bounds.size;
    self.layoutManager.layoutTarget = self;
    [self.layoutManager arrangeViews];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.layoutManager.viewSize = bounds.size;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.layoutManager reArrangeIfNeeded];
    self.layoutManager.contentOffset = self.contentOffset;
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

- (void)setArrangedViewAttributes:(INFViewLayoutAttributes *)attributes {
    UIView* subView = self.arrangedViews[attributes.index];
    subView.center = attributes.center;
}

@end
