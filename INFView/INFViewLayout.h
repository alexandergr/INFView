//
//  INFViewLayout.h
//  INFView
//
//  Created by Alexander on 2/9/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INFLayoutViewInfo.h"
#import "INFOrientation.h"

@interface INFViewLayout : NSObject

@property (nonatomic) INFOrientation orientation;
@property (nonatomic) CGSize scrollViewSize;
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) CGSize contentSize;
@property (strong, nonatomic) NSArray<INFLayoutViewInfo*>* viewsLayoutInfo;

@property (nonatomic) NSRange leadingViewsRange;
@property (nonatomic) NSRange trailingViewsRange;

@property (nonatomic) BOOL canHaveInfiniteScrolling;

- (CGFloat)getContentOffsetPosition;
- (void)setContentOffsetPosition:(CGFloat)position;

- (void)setContentLength:(CGFloat)contentLength;

- (CGFloat)lengthOfViewsInRange:(NSRange)range;
- (CGFloat)lengthOfAllViews;
- (CGFloat)lengthOfLeadingViews;
- (CGFloat)lengthOfTrailingViews;

- (void)moveViewsInRange:(NSRange)range position:(CGFloat)position;
- (void)shiftViewsWithOffset:(CGFloat)offset;

- (void)setAccurateSize:(CGSize)size forViewAtIndex:(NSInteger)index;

- (NSArray<INFLayoutViewInfo*>*)getViewsInAreaFrom:(CGFloat)startPosition to:(CGFloat)endPosition;
@end
