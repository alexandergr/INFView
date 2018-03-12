//
//  INFSimpleLayoutTestMinimalScrollConditions.m
//  INFViewTests
//
//  Created by Oleksandr Hrushovyi on 3/13/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "INFSimpleLayoutStrategy.h"
#import "FakeViewsSizeStorage.h"

@interface INFSimpleLayoutTestMinimalScrollConditions : XCTestCase

@property (strong, nonatomic) INFSimpleLayoutStrategy* layoutStrategy;
@property (strong, nonatomic) FakeViewsSizeStorage* viewSizes;

@end

@implementation INFSimpleLayoutTestMinimalScrollConditions

- (void)setUp {
    [super setUp];
    
    self.layoutStrategy = [INFSimpleLayoutStrategy new];
    self.layoutStrategy.scrollViewSize = CGSizeMake(100.0, 100.0);
    
    self.layoutStrategy.orientation = INFOrientationHorizontal;
}

- (void)tearDown {
    self.layoutStrategy = nil;
    self.viewSizes = nil;
    
    [super tearDown];
}

- (void)testDoHaveInfiniteScrolling {
    self.viewSizes = [[FakeViewsSizeStorage alloc] initWithCountOfViews:3 estimatedSize:CGSizeMake(10.0, 100.0) accurateSize:CGSizeMake(50.0, 100.0)];
    self.layoutStrategy.sizesStorage = self.viewSizes;
    
    INFViewLayout* layout = nil;
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(0.0, 0.0)];
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, 50.0 * 4.5);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, 50.0 * 2.5);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, 50.0 * 3.5);
    XCTAssertEqual(layout.contentOffset.x, 150.0);
    XCTAssertTrue(layout.canHaveInfiniteScrolling);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(75.0, 0.0)];
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, 50.0 * 1.5);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, 50.0 * 2.5);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, 50.0 * 3.5);
    XCTAssertEqual(layout.contentOffset.x, 75.0);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(-1.0, 0.0)];
    XCTAssertEqual(layout.contentOffset.x, 149.0);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(200.0, 0.0)];
    XCTAssertEqual(layout.contentOffset.x, 50.0);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(201.0, 0.0)];
    XCTAssertEqual(layout.contentOffset.x, 51.0);
    
}


@end
