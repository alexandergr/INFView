//
//  INFViewLayoutManager.h
//  INFView
//
//  Created by Oleksandr Hrushovyi on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "INFViewLayoutAttributes.h"
#import "INFViewOrientation.h"

@protocol INFViewLayoutManagerDelegate;

@interface INFViewLayoutManager : NSObject

@property (nonatomic) CGSize viewSize;
@property (nonatomic) CGPoint contentOffset;
@property (weak, nonatomic) id<INFViewLayoutManagerDelegate> delegate;

- (void) arrangeViews;
- (void) reArrangeIfNeeded;

@end

@protocol INFViewLayoutManagerDelegate
- (NSInteger) numberOfItemsInInfViewLayoutManager:(INFViewLayoutManager*)layout;
- (void) infViewLayoutManager:(INFViewLayoutManager*)layout updatedContentSize:(CGSize)contentSize;
- (void) infViewLayoutManager:(INFViewLayoutManager*)layout updatedContentOffset:(CGPoint)contentOffset;
- (void) infViewLayoutManager:(INFViewLayoutManager*)layout updatedAttributes:(INFViewLayoutAttributes*)attributes;
@end
