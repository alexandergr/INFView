//
//  INFLayoutManager.h
//  INFView
//
//  Created by Oleksandr Hrushovyi on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "INFLayoutStrategy.h"

@protocol INFLayoutTarget;
@protocol INFLayoutDataSource;
@protocol INFLayoutDelegate;

@interface INFLayoutManager: NSObject

@property (nonatomic) CGSize scrollViewSize;
@property (nullable, weak, nonatomic) id<INFLayoutTarget> target;
@property (nullable, weak, nonatomic) id<INFLayoutDataSource> dataSource;
@property (nullable, weak, nonatomic) id<INFLayoutDelegate> delegate;
@property (nonnull, strong, nonatomic) id<INFLayoutStrategy> strategy;
@property (nonatomic) INFOrientation orientation;

- (nonnull instancetype)initWithLayoutStrategyType:(INFLayoutStrategyType)layoutStrategyType NS_DESIGNATED_INITIALIZER;
- (void)arrangeViews;
- (void)updateArrangedViewsForNewContentOffset:(CGPoint)contentOffset;

@end

@protocol INFLayoutDataSource
- (NSInteger)numberOfArrangedViews;
- (CGSize)sizeForViewAtIndex:(NSInteger)index;
- (CGSize)estimatedSizeForViewAtIndex:(NSInteger)index;
@end

@protocol INFLayoutTarget
- (void)updateContentSize:(CGSize)contentSize;
- (void)updateContentOffset:(CGPoint)contentOffset;
- (void)updateArrangedViewWithLayoutInfo:(nonnull INFLayoutViewInfo*)viewInfo;
@end

@protocol INFLayoutDelegate
- (void)willShowViewAtIndex:(NSInteger)index;
- (void)didShowViewAtIndex:(NSInteger)index;
- (void)willHideViewAtIndex:(NSInteger)index;
- (void)didHideViewAtIndex:(NSInteger)index;
@end
