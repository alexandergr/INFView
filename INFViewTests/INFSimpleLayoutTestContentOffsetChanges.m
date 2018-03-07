//
//  INFSimpleLayoutTestContentOffsetChanges.m
//  INFViewTests
//
//  Created by Oleksandr Hrushovyi on 2/27/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "INFSimpleLayoutStrategy.h"

@interface INFSimpleLayoutTestContentOffsetChanges : XCTestCase

@property (strong, nonatomic) INFSimpleLayoutStrategy* layoutStrategy;

@end

@implementation INFSimpleLayoutTestContentOffsetChanges

- (void)setUp {
    [super setUp];
    
    self.layoutStrategy = [INFSimpleLayoutStrategy new];
    self.layoutStrategy.scrollViewSize = CGSizeMake(100.0, 100.0);
    self.layoutStrategy.sizesOfArrangedViews = @[@(CGSizeMake(100.0, 100.0)), @(CGSizeMake(100.0, 100.0)), @(CGSizeMake(100.0, 100.0))];
    self.layoutStrategy.orientation = INFOrientationHorizontal;
}

- (void)tearDown {
    self.layoutStrategy = nil;
    
    [super tearDown];
}

- (void) checkViewsAtLeftSideState:(INFViewLayout*)layout {
    XCTAssertEqual(layout.viewsLayoutInfo.count, 3);
    
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, 150.0);
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.y, 50.0);
    
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, 250.0);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.y, 50.0);
    
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, 50.0);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.y, 50.0);
}

- (void) checkViewsAtNormalOrderState:(INFViewLayout*)layout {
    XCTAssertEqual(layout.viewsLayoutInfo.count, 3);
    
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, 150.0);
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.y, 50.0);
    
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, 250.0);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.y, 50.0);
    
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, 350.0);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.y, 50.0);
}

- (void) checkViewsAtRightSideState:(INFViewLayout*)layout {
    XCTAssertEqual(layout.viewsLayoutInfo.count, 3);
    
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, 450.0);
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.y, 50.0);
    
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, 250.0);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.y, 50.0);
    
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, 350.0);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.y, 50.0);
}

- (void)testLayoutForInitialPosition {
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(0.0, 0.0)];
    
    XCTAssertEqual(layout.contentOffset.x, 100.0);
    XCTAssertEqual(layout.contentOffset.y, 0.0);
    
    [self checkViewsAtLeftSideState:layout];
}

- (void)testLayoutBeforeLeftViewState {
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(101.0, 0.0)];
    
    XCTAssertEqual(layout.contentOffset.x, 101.0);
    XCTAssertEqual(layout.contentOffset.y, 0.0);
    
    [self checkViewsAtNormalOrderState:layout];
}

- (void)testLayoutAtLeftViewState{
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(99.0, 0.0)];
    
    XCTAssertEqual(layout.contentOffset.x, 99.0);
    XCTAssertEqual(layout.contentOffset.y, 0.0);
    
    [self checkViewsAtLeftSideState:layout];
}

- (void)testLayoutBeforeLeftJump {
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(26.0, 0.0)];
    
    XCTAssertEqual(layout.contentOffset.x, 26.0);
    XCTAssertEqual(layout.contentOffset.y, 0.0);
    
    [self checkViewsAtLeftSideState:layout];
}

- (void)testLayoutAtLeftJump {
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(25.0, 0.0)];
    
    XCTAssertEqual(layout.contentOffset.x, 325.0);
    XCTAssertEqual(layout.contentOffset.y, 0.0);
    
    [self checkViewsAtRightSideState:layout];
}

- (void)testLayoutBeforeRightState {
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(299.0, 0.0)];
    
    XCTAssertEqual(layout.contentOffset.x, 299.0);
    XCTAssertEqual(layout.contentOffset.y, 0.0);
    
    [self checkViewsAtNormalOrderState:layout];
}

- (void)testLayoutAtRightState {
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(300.0, 0.0)];
    
    XCTAssertEqual(layout.contentOffset.x, 300.0);
    XCTAssertEqual(layout.contentOffset.y, 0.0);
    
    [self checkViewsAtRightSideState:layout];
}

- (void)testLayoutBeforeRightJump {
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(374.0, 0.0)];
    
    XCTAssertEqual(layout.contentOffset.x, 374.0);
    XCTAssertEqual(layout.contentOffset.y, 0.0);
    
    [self checkViewsAtRightSideState:layout];
}

- (void)testLayoutAtRightJump {
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(375.0, 0.0)];
    
    XCTAssertEqual(layout.contentOffset.x, 75.0);
    XCTAssertEqual(layout.contentOffset.y, 0.0);
    
    [self checkViewsAtLeftSideState:layout];
}

@end
