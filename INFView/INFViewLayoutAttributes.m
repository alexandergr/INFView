//
//  INFViewLayoutAttributes.m
//  INFView
//
//  Created by Oleksandr Hrushovyi on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFViewLayoutAttributes.h"

@implementation INFViewLayoutAttributes

- (CGFloat)getPositionForOrientation:(INFOrientation)orientation {
    if (orientation == INFOrientationHorizontal) {
        return self.center.x;
    } else {
        return self.center.y;
    }
}

- (void)setPosition:(CGFloat)position forOrientation:(INFOrientation)orientation {
    if (orientation == INFOrientationHorizontal) {
        self.center = CGPointMake(position, self.center.y);
    } else {
        self.center = CGPointMake(self.center.x, position);
    }
}

@end
