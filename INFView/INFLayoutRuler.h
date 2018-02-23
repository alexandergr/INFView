//
//  INFLayoutRuler.h
//  INFView
//
//  Created by Alexander on 2/23/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INFViewLayout.h"
#import "INFOrientation.h"

@interface INFLayoutRuler : NSObject

@property (nonatomic) INFOrientation orientation;
@property (nonatomic) CGSize scrollViewSize;
@property (strong, nonatomic) NSArray<NSValue*>* sizesOfArrangedViews;

- (CGFloat)getPosition:(INFViewLayoutAttributes*)viewAttributes;
- (void)viewAttributes:(INFViewLayoutAttributes*)viewAttributes setPosition:(CGFloat)position;

- (void)layout:(INFViewLayout*)layout setContentLength:(CGFloat)contentLength;
- (void)layout:(INFViewLayout*)layout setContentOffsetToPosition:(CGFloat)newPosition;
- (CGFloat)getContentOffsetPositionFromLayout:(INFViewLayout*)layout;

- (CGFloat)getLengthOfScrollView;

- (NSUInteger)countOfArrangedViews;
- (CGFloat)lengthOfArrangedView: (NSInteger)index;
- (CGFloat)lengthOfArrangedViewsInRange:(NSRange)range;
- (CGFloat)lengthOfAllArrangedViews;

@end

