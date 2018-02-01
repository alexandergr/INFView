//
//  INFScrollView.m
//  INFView
//
//  Created by Alexander on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFScrollView.h"
#import "INFViewLayoutManager.h"

@interface INFScrollView () <INFViewLayoutManagerDelegate>

@property (nonatomic) NSInteger numberOfArrangedSubViews;
@property (strong, nonatomic) NSMutableArray* arrangedSubViews;

@property (strong, nonatomic) INFViewLayoutManager* layoutManager;

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
    for (UIView* subView in self.arrangedSubViews) {
        [subView removeFromSuperview];
    }

    self.numberOfArrangedSubViews = [self.dataSource numberOfSubViewsInINFView:self];
    self.arrangedSubViews = [NSMutableArray new];

    for (NSInteger i = 0; i < self.numberOfArrangedSubViews; i++) {
        UIView* subView = [self.dataSource infView:self subViewAtIndex:i];
        [self.arrangedSubViews addObject:subView];
        [self addSubview:subView];
    }
    
    self.layoutManager = [INFViewLayoutManager new];
    self.layoutManager.viewSize = self.bounds.size;
    self.layoutManager.delegate = self;
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

- (NSInteger)numberOfItemsInInfViewLayoutManager:(INFViewLayoutManager*)layout {
    return self.numberOfArrangedSubViews;
}

- (void)infViewLayoutManager:(INFViewLayoutManager *)layout updatedContentSize:(CGSize)contentSize {
    self.contentSize = contentSize;
}

- (void)infViewLayoutManager:(INFViewLayoutManager *)layout updatedContentOffset:(CGPoint)contentOffset {
    self.contentOffset = contentOffset;
}

- (void)infViewLayoutManager:(INFViewLayoutManager *)layout updatedAttributes:(INFViewLayoutAttributes *)attributes {
    UIView* subView = self.arrangedSubViews[attributes.index];
    subView.center = attributes.center;
}

@end
