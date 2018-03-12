//
//  FakeViewsSizeStorage.h
//  INFViewTests
//
//  Created by Oleksandr Hrushovyi on 3/7/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INFLayoutStrategy.h"

@interface FakeViewsSizeStorage : NSObject <INFViewsSizeStorage>

@property (nonatomic) NSInteger countOfViews;
@property (nonatomic) CGSize estimatedSize;
@property (nonatomic) CGSize accurateSize;

- (instancetype)initWithCountOfViews:(NSInteger)countOfViews estimatedSize:(CGSize)estimatedSize accurateSize:(CGSize)accurateSize;

@end
