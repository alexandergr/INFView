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

@interface INFLayoutManager: NSObject

@property (nonatomic) CGSize scrollViewSize;
@property (weak, nonatomic) id<INFLayoutTarget> layoutTarget;
@property (strong, nonatomic) id<INFLayoutStrategy> layoutStrategy;
@property (nonatomic) INFOrientation orientation;

- (instancetype)initWithLayoutStrategyType:(INFLayoutStrategyType)layoutStrategyType NS_DESIGNATED_INITIALIZER;
- (void)arrangeViews;
- (void)updateArrangedViewsForNewContentOffset:(CGPoint)contentOffset;

@end

@protocol INFLayoutTarget
- (NSInteger)numberOfArrangedViews;
- (void)updateContentSize:(CGSize)contentSize;
- (void)updateContentOffset:(CGPoint)contentOffset;
- (void)setArrangedViewAttributes:(INFViewLayoutAttributes*)attributes;
@end