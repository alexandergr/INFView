//
//  INFSimpleLayoutStrategy.h
//  INFView
//
//  Created by Alexander on 2/9/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INFLayoutStrategy.h"
#import "INFOrientation.h"

@interface INFSimpleLayoutStrategy : NSObject<INFLayoutStrategy>

@property (nonatomic) INFOrientation orientation;
@property (nonatomic) CGSize scrollViewSize;
@property (weak, nonatomic) id<INFViewsSizeStorage> sizesStorage;

- (INFViewLayout*)layoutArrangedViewsForContentOffset:(CGPoint)contentOffset;
@end
