//
//  FaceLayoutDataSource.h
//  INFViewTests
//
//  Created by Oleksandr Hrushovyi on 3/14/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INFLayoutManager.h"

@interface FakeLayoutDataSource : NSObject <INFLayoutDataSource>

@property (strong, nonatomic) NSArray<NSNumber*>* viewsWidth;
@property (nonatomic) CGFloat viewsHeight;

- (instancetype)initWithViewsWidth:(NSArray<NSNumber*>*)viewsWidth viewsHeight:(CGFloat)viewsHeight;

@end
