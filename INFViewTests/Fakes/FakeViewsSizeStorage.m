//
//  FakeViewsSizeStorage.m
//  INFViewTests
//
//  Created by Oleksandr Hrushovyi on 3/7/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "FakeViewsSizeStorage.h"

@implementation FakeViewsSizeStorage

- (instancetype)initWithCountOfViews:(NSInteger)countOfViews estimatedSize:(CGSize)estimatedSize accurateSize:(CGSize)accurateSize {
    self = [super init];
    if (self) {
        self.countOfViews = countOfViews;
        self.estimatedSize = estimatedSize;
        self.accurateSize = accurateSize;
    }
    return self;
}

- (CGSize) sizeOfViewAtIndex:(NSInteger)index {
    return self.estimatedSize;
}

- (CGSize) accurateSizeOfViewAtIndex:(NSInteger)index {
    return self.accurateSize;
}

@end
