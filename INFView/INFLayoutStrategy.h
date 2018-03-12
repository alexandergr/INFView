//
//  INFLayoutStrategy.h
//  INFView
//
//  Created by Alexander on 2/9/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "INFViewLayout.h"
#import "INFOrientation.h"

typedef enum : NSUInteger {
    INFLayoutStrategyTypeSimple,
} INFLayoutStrategyType;

@protocol INFViewsSizeStorage
- (NSInteger)countOfViews;
- (CGSize)sizeOfViewAtIndex:(NSInteger)index;
- (CGSize)accurateSizeOfViewAtIndex:(NSInteger)index;
@end

@protocol INFLayoutStrategy

@property (nonatomic) INFOrientation orientation;
@property (nonatomic) CGSize scrollViewSize;
@property (weak, nonatomic) id<INFViewsSizeStorage> sizesStorage;

- (INFViewLayout*)layoutArrangedViewsForContentOffset:(CGPoint)contentOffset;
@end

