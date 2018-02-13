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

@end

@implementation INFSimpleLayoutTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitialLayout {
    INFSimpleLayoutStrategy* layoutStrategy = [INFSimpleLayoutStrategy new];
    layoutStrategy.scrollViewSize = CGSizeMake(100.0, 120.0);
    layoutStrategy.numberOfArrangedViews = 4;
    layoutStrategy.contentOffset = CGPointMake(0.0, 0.0);
    layoutStrategy.orientation = INFOrientationHorizontal;
    INFViewLayout* layout = [layoutStrategy layoutArrangedViews];

    XCTAssertEqual(layout.contentSize.width, 600.0);
    XCTAssertEqual(layout.contentSize.height, 120.0);
    XCTAssertEqual(layout.viewsAttributes.count, 4);
    XCTAssertEqual(layout.contentOffset.x, 100.0);
    XCTAssertEqual(layout.contentOffset.y, 0.0);

    XCTAssertEqual(layout.viewsAttributes[0].center.x, 150.0);
    XCTAssertEqual(layout.viewsAttributes[0].center.y, 60.0);

    XCTAssertEqual(layout.viewsAttributes[1].center.x, 250.0);
    XCTAssertEqual(layout.viewsAttributes[0].center.y, 60.0);

    XCTAssertEqual(layout.viewsAttributes[2].center.x, 350.0);
    XCTAssertEqual(layout.viewsAttributes[0].center.y, 60.0);

    XCTAssertEqual(layout.viewsAttributes[3].center.x, 50.0);
    XCTAssertEqual(layout.viewsAttributes[0].center.y, 60.0);
}

- (void)testVerticalLayout {
    INFSimpleLayoutStrategy* layoutStrategy = [INFSimpleLayoutStrategy new];
    layoutStrategy.scrollViewSize = CGSizeMake(100.0, 120.0);
    layoutStrategy.numberOfArrangedViews = 4;
    layoutStrategy.contentOffset = CGPointMake(0.0, 0.0);
    layoutStrategy.orientation = INFOrientationVertical;
    INFViewLayout* layout = [layoutStrategy layoutArrangedViews];

    XCTAssertEqual(layout.contentSize.width, 100.0);
    XCTAssertEqual(layout.contentSize.height, 720.0);
    XCTAssertEqual(layout.viewsAttributes.count, 4);
    XCTAssertEqual(layout.contentOffset.x, 0.0);

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
