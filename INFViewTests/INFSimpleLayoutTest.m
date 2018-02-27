//
//  INFSimpleLayoutTest.m
//  INFViewTests
//
//  Created by Alexander on 2/9/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "INFSimpleLayoutStrategy.h"

@interface INFSimpleLayoutTest : XCTestCase

@property (strong, nonatomic) INFSimpleLayoutStrategy* layoutStrategy;

@end

@implementation INFSimpleLayoutTest

- (void)setUp {
    [super setUp];
    
    self.layoutStrategy = [INFSimpleLayoutStrategy new];
}

- (void)tearDown {
    self.layoutStrategy = nil;
    
    [super tearDown];
}

- (void)testInitialLayout {
    self.layoutStrategy.scrollViewSize = CGSizeMake(100.0, 120.0);
    self.layoutStrategy.sizesOfArrangedViews = @[@(CGSizeMake(100.0, 100.0)), @(CGSizeMake(100.0, 100.0)), @(CGSizeMake(100.0, 100.0)), @(CGSizeMake(100.0, 100.0))];
    self.layoutStrategy.orientation = INFOrientationHorizontal;
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(0.0, 0.0)];

    XCTAssertEqual(layout.contentSize.width, 600.0);
    XCTAssertEqual(layout.contentSize.height, 120.0);
    XCTAssertEqual(layout.viewsAttributes.count, 4);
    XCTAssertEqual(layout.contentOffset.x, 100.0);
    XCTAssertEqual(layout.contentOffset.y, 0.0);

    XCTAssertEqual(layout.viewsAttributes[0].center.x, 150.0);
    XCTAssertEqual(layout.viewsAttributes[0].center.y, 60.0);

    XCTAssertEqual(layout.viewsAttributes[1].center.x, 250.0);
    XCTAssertEqual(layout.viewsAttributes[1].center.y, 60.0);

    XCTAssertEqual(layout.viewsAttributes[2].center.x, 350.0);
    XCTAssertEqual(layout.viewsAttributes[1].center.y, 60.0);

    XCTAssertEqual(layout.viewsAttributes[3].center.x, 50.0);
    XCTAssertEqual(layout.viewsAttributes[3].center.y, 60.0);
}

- (void)testVerticalLayout {
    self.layoutStrategy.scrollViewSize = CGSizeMake(100.0, 120.0);
    self.layoutStrategy.sizesOfArrangedViews = @[@(CGSizeMake(100.0, 120.0)), @(CGSizeMake(100.0, 120.0)), @(CGSizeMake(100.0, 120.0)), @(CGSizeMake(100.0, 120.0))];
    self.layoutStrategy.orientation = INFOrientationVertical;
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(0.0, 0.0)];

    XCTAssertEqual(layout.contentSize.width, 100.0);
    XCTAssertEqual(layout.contentSize.height, 720.0);
    XCTAssertEqual(layout.viewsAttributes.count, 4);
    XCTAssertEqual(layout.contentOffset.x, 0.0);
    XCTAssertEqual(layout.contentOffset.y, 120.0);

    XCTAssertEqual(layout.viewsAttributes[0].center.x, 50.0);
    XCTAssertEqual(layout.viewsAttributes[0].center.y, 180.0);

    XCTAssertEqual(layout.viewsAttributes[1].center.x, 50.0);
    XCTAssertEqual(layout.viewsAttributes[1].center.y, 300.0);

    XCTAssertEqual(layout.viewsAttributes[2].center.x, 50.0);
    XCTAssertEqual(layout.viewsAttributes[2].center.y, 420.0);

    XCTAssertEqual(layout.viewsAttributes[3].center.x, 50.0);
    XCTAssertEqual(layout.viewsAttributes[3].center.y, 60.0);
}

@end
