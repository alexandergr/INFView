//
//  INFLayoutViewInfo.m
//  INFView
//
//  Created by Oleksandr Hrushovyi on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFLayoutViewInfo.h"

@implementation INFLayoutViewInfo

- (instancetype)initWithIndex:(NSInteger)index size:(CGSize)size {
    self = [super init];
    if (self) {
        self.index = index;
        self.center = CGPointZero;
        self.size = size;
    }
    return self;
}

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

- (void)shiftPosition:(CGFloat)shift forOrientation:(INFOrientation)orientation {
    if (orientation == INFOrientationHorizontal) {
        self.center = CGPointMake(self.center.x + shift, self.center.y);
    } else {
        self.center = CGPointMake(self.center.x, self.center.y + shift);
    }
}

- (CGFloat)getLengthForOrientation:(INFOrientation)orientation {
    if (orientation == INFOrientationHorizontal) {
        return self.size.width;
    } else {
        return self.size.height;
    }
}

@end
