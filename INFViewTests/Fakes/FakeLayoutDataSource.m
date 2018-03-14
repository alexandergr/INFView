//
//  FakeLayoutDataSource.m
//  INFViewTests
//
//  Created by Oleksandr Hrushovyi on 3/14/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "FakeLayoutDataSource.h"


@implementation FakeLayoutDataSource

- (instancetype)initWithViewsWidth:(NSArray<NSNumber*>*)viewsWidth viewsHeight:(CGFloat)viewsHeight {
    self = [super init];
    if (self) {
        self.viewsWidth = viewsWidth;
        self.viewsHeight = viewsHeight;
    }
    return self;
}

- (NSInteger)numberOfArrangedViews {
    return self.viewsWidth.count;
}

- (CGSize)estimatedSizeForViewAtIndex:(NSInteger)index {
    return CGSizeMake(self.viewsWidth[index].doubleValue, self.viewsHeight);
}

- (CGSize)sizeForViewAtIndex:(NSInteger)index {
    return CGSizeMake(self.viewsWidth[index].doubleValue, self.viewsHeight);
}

@end
