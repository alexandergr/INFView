//
//  INFViewLayoutAttributes.h
//  INFView
//
//  Created by Oleksandr Hrushovyi on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface INFViewLayoutAttributes : NSObject

@property (nonatomic) NSInteger index;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGSize containerSize;

@end
