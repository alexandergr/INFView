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

@interface INFLayoutManager: NSObject

@property (nonatomic) CGSize scrollViewSize;
@property (weak, nonatomic) id<INFLayoutTarget> layoutTarget;
@property (weak, nonatomic) id<INFLayoutDataSource> layoutDataSource;
@property (strong, nonatomic) id<INFLayoutStrategy> layoutStrategy;
@property (nonatomic) INFOrientation orientation;

- (instancetype)initWithLayoutStrategyType:(INFLayoutStrategyType)layoutStrategyType NS_DESIGNATED_INITIALIZER;
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
- (void)updateArrangedViewWithLayoutInfo:(INFLayoutViewInfo*)viewInfo;
@end
