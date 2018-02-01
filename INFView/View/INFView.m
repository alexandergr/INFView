//
//  INFView.m
//  INFView
//
//  Created by Alexander on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFView.h"

@interface INFView ()

@property (nonatomic, strong) NSMutableArray* arrangedSubViews;
@property (nonatomic, strong) NSMutableArray* arrangedSubViewPositions;
@property (nonatomic) CGFloat maxContentWidth;

@end

@implementation INFView

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

    NSInteger subViewsCount = [self.dataSource numberOfSubViewsInINFView:self];
    self.arrangedSubViews = [NSMutableArray new];
    self.arrangedSubViewPositions = [NSMutableArray new];
    self.maxContentWidth = 0.0;

    for (NSInteger i = 0; i < subViewsCount; i++) {
        CGFloat subViewPosition = self.maxContentWidth;
        CGFloat subViewSpace = [self spaceForSubViewAtIndex:i];

        CGRect subViewRect = CGRectMake(subViewPosition, 0.0, subViewSpace, self.bounds.size.height);
        [self.arrangedSubViewPositions addObject:[NSValue valueWithCGRect:subViewRect]];

        UIView* subView = [self.dataSource infView:self subViewAtIndex:i];
        subView.center = CGPointMake(subViewPosition + (subViewSpace / 2.0), self.bounds.size.height / 2.0);
        [self.arrangedSubViews addObject:subView];
        [self addSubview:subView];

        self.maxContentWidth = subViewPosition + subViewSpace;
    }

    if (self.maxContentWidth >= self.bounds.size.width * 2.0) {
        self.contentSize = CGSizeMake(self.maxContentWidth + self.bounds.size.width * 2.0, self.bounds.size.height);
        if (self.contentOffset.x == 0) {
            self.contentOffset = CGPointMake(self.bounds.size.width, self.contentOffset.y);
        }
        for (UIView* subView in self.arrangedSubViews) {
            subView.center = CGPointMake(subView.center.x + self.bounds.size.width, subView.center.y);
        }
    } else {
        //no infinity is possible
        self.contentSize = CGSizeMake(self.maxContentWidth, self.bounds.size.height);
    }

    [self setNeedsLayout];
}

- (void) layoutSubviews {
    [super layoutSubviews];

    if (self.maxContentWidth >= self.bounds.size.width) {

        if (self.contentOffset.x < self.bounds.size.width / 2.0) {
            self.contentOffset = CGPointMake(self.bounds.size.width + self.maxContentWidth - self.contentOffset.x, self.contentOffset.y);
        } else if (self.contentOffset.x > self.maxContentWidth + self.bounds.size.width / 2.0) {
            self.contentOffset = CGPointMake(self.contentOffset.x - self.maxContentWidth, self.contentOffset.y);
        }

        UIView* firstSubView = self.arrangedSubViews.firstObject;
        NSValue* firstSubViewPositionValue = self.arrangedSubViewPositions.firstObject;
        CGRect firstObjectPosition = firstSubViewPositionValue.CGRectValue;

        UIView* lastSubView = self.arrangedSubViews.lastObject;
        NSValue* lastSubViewPositionValue = self.arrangedSubViewPositions.lastObject;
        CGRect lastObjectPosition = lastSubViewPositionValue.CGRectValue;

        if (self.contentOffset.x >= self.maxContentWidth - self.bounds.size.width) {
            lastSubView.center = CGPointMake(self.bounds.size.width + self.maxContentWidth - lastObjectPosition.size.width / 2.0, lastSubView.center.y);
            firstSubView.center = CGPointMake(self.bounds.size.width + self.maxContentWidth + firstObjectPosition.size.width / 2.0, firstSubView.center.y);
        } else {
            lastSubView.center = CGPointMake(self.bounds.size.width - lastObjectPosition.size.width / 2.0, lastSubView.center.y);
            firstSubView.center = CGPointMake(self.bounds.size.width + firstObjectPosition.size.width / 2.0, firstSubView.center.y);
        }
    }
}

@end
