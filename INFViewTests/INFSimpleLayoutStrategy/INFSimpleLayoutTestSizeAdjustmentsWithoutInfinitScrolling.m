//
//  INFSimpleLayoutTestSizeAdjustmentsWithoutInfinitScrolling.m
//  INFViewTests
//
//  Created by Oleksandr Hrushovyi on 3/13/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "INFSimpleLayoutStrategy.h"
#import "FakeViewsSizeStorage.h"

@interface INFSimpleLayoutTestSizeAdjustmentsWithoutInfinitScrolling : XCTestCase

@property (strong, nonatomic) INFSimpleLayoutStrategy* layoutStrategy;
@property (strong, nonatomic) FakeViewsSizeStorage* viewSizes;

@end

@implementation INFSimpleLayoutTestSizeAdjustmentsWithoutInfinitScrolling

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

- (void)testDoNotHaveInfiniteScrolling {
    self.viewSizes = [[FakeViewsSizeStorage alloc] initWithCountOfViews:3 estimatedSize:CGSizeMake(100.0, 100.0) accurateSize:CGSizeMake(30.0, 100.0)];
    self.layoutStrategy.sizesStorage = self.viewSizes;
    
    INFViewLayout* layout = nil;
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(0.0, 0.0)];
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, 30.0 * 0.5);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, 30.0 * 1.5);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, 30.0 * 2.5);
    XCTAssertEqual(layout.contentOffset.x, 0.0);
    XCTAssertFalse(layout.canHaveInfiniteScrolling);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(10.0, 0.0)];
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, 30.0 * 0.5);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, 30.0 * 1.5);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, 30.0 * 2.5);
    XCTAssertEqual(layout.contentOffset.x, 10.0);
    XCTAssertFalse(layout.canHaveInfiniteScrolling);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(30.0, 0.0)];
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, 30.0 * 0.5);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, 30.0 * 1.5);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, 30.0 * 2.5);
    XCTAssertEqual(layout.contentOffset.x, 30.0);
    XCTAssertFalse(layout.canHaveInfiniteScrolling);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(90.0, 0.0)];
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, 30.0 * 0.5);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, 30.0 * 1.5);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, 30.0 * 2.5);
    XCTAssertEqual(layout.contentOffset.x, 90.0);
    XCTAssertFalse(layout.canHaveInfiniteScrolling);
}

- (void)testDoNotHaveInfiniteScrolling2 {
    self.viewSizes = [[FakeViewsSizeStorage alloc] initWithCountOfViews:5 estimatedSize:CGSizeMake(100.0, 100.0) accurateSize:CGSizeMake(10.0, 100.0)];
    self.layoutStrategy.sizesStorage = self.viewSizes;
    
    INFViewLayout* layout = nil;
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(0.0, 0.0)];
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, 10.0 * 0.5);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, 10.0 * 1.5);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, 10.0 * 2.5);
    XCTAssertEqual(layout.viewsLayoutInfo[3].center.x, 10.0 * 3.5);
    XCTAssertEqual(layout.viewsLayoutInfo[4].center.x, 10.0 * 4.5);
    XCTAssertEqual(layout.contentOffset.x, 0.0);
    XCTAssertFalse(layout.canHaveInfiniteScrolling);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(10.0, 0.0)];
    XCTAssertEqual(layout.contentOffset.x, 10.0);
    XCTAssertFalse(layout.canHaveInfiniteScrolling);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(30.0, 0.0)];
    XCTAssertEqual(layout.contentOffset.x, 30.0);
    XCTAssertFalse(layout.canHaveInfiniteScrolling);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(90.0, 0.0)];
    XCTAssertEqual(layout.contentOffset.x, 90.0);
    XCTAssertFalse(layout.canHaveInfiniteScrolling);
}

- (void)testDoNotHaveInfiniteScrolling3 {
    self.viewSizes = [[FakeViewsSizeStorage alloc] initWithCountOfViews:3 estimatedSize:CGSizeMake(100.0, 100.0) accurateSize:CGSizeMake(49.0, 100.0)];
    self.layoutStrategy.sizesStorage = self.viewSizes;
    
    INFViewLayout* layout = nil;
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(0.0, 0.0)];
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, 49.0 * 0.5);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, 49.0 * 1.5);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, 49.0 * 2.5);

    XCTAssertEqual(layout.contentOffset.x, 0.0);
    XCTAssertFalse(layout.canHaveInfiniteScrolling);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(10.0, 0.0)];
    XCTAssertEqual(layout.contentOffset.x, 10.0);
    XCTAssertFalse(layout.canHaveInfiniteScrolling);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(30.0, 0.0)];
    XCTAssertEqual(layout.contentOffset.x, 30.0);
    XCTAssertFalse(layout.canHaveInfiniteScrolling);
    
    layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(90.0, 0.0)];
    XCTAssertEqual(layout.contentOffset.x, 90.0);
    XCTAssertFalse(layout.canHaveInfiniteScrolling);
}

@end
