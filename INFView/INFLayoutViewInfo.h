//
//  INFViewLayoutInfo.h
//  INFView
//
//  Created by Oleksandr Hrushovyi on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "INFOrientation.h"

@interface INFLayoutViewInfo : NSObject

@property (nonatomic) NSInteger index;
@property (nonatomic) CGPoint center;
@property (nonatomic) CGSize size;

- (instancetype)initWithIndex:(NSInteger)index size:(CGSize)size;

- (CGFloat)getPositionForOrientation:(INFOrientation)orientation;
- (void)setPosition:(CGFloat)position forOrientation:(INFOrientation)orientation;
- (CGFloat)getLengthForOrientation:(INFOrientation)orientation;

@end
