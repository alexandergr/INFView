//
//  INFViewLayout.h
//  INFView
//
//  Created by Alexander on 2/9/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INFViewLayoutAttributes.h"

@interface INFViewLayout : NSObject

@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) CGSize contentSize;
@property (strong, nonatomic) NSArray<INFViewLayoutAttributes*>* viewsAttributes;

@end
