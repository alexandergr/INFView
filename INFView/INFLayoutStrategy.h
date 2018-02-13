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

@protocol INFLayoutStrategy
@property (nonatomic) CGSize scrollViewSize;
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) NSInteger numberOfArrangedViews;
@property (nonatomic) INFOrientation orientation;
- (INFViewLayout*)layoutArrangedViews;
@end

