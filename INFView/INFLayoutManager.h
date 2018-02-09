//
//  INFLayoutManager.h
//  INFView
//
//  Created by Oleksandr Hrushovyi on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "INFViewLayoutAttributes.h"
#import "INFViewOrientation.h"

@protocol INFLayoutTarget;

@interface INFLayoutManager: NSObject

@property (nonatomic) CGSize viewSize;
@property (nonatomic) CGPoint contentOffset;
@property (weak, nonatomic) id<INFLayoutTarget> layoutTarget;

- (void) arrangeViews;
- (void) reArrangeIfNeeded;

@end

@protocol INFLayoutTarget
- (NSInteger)numberOfArrangedViews;
- (void)updateContentSize:(CGSize)contentSize;
- (void)updateContentOffset:(CGPoint)contentOffset;
- (void)setArrangedViewAttributes:(INFViewLayoutAttributes*)attributes;
@end
