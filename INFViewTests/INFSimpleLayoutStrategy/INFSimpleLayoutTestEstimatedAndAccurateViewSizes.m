//
//  INFSimpleLayoutTestEstimatedAndAccurateViewSizes.m
//  INFViewTests
//
//  Created by Oleksandr Hrushovyi on 3/7/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "INFSimpleLayoutStrategy.h"
#import "FakeViewsSizeStorage.h"

@interface INFSimpleLayoutTestEstimatedAndAccurateViewSizes : XCTestCase

@property (nonatomic) CGSize estimatedSize;
@property (nonatomic) CGSize accurateSize;

@property (strong, nonatomic) INFSimpleLayoutStrategy* layoutStrategy;
@property (strong, nonatomic) FakeViewsSizeStorage* viewSizes;

@end

@implementation INFSimpleLayoutTestEstimatedAndAccurateViewSizes

- (void)setUp {
    [super setUp];
    
    self.estimatedSize = CGSizeMake(100.0, 100.0);
    self.accurateSize = CGSizeMake(50.0, 50.0);
    
    self.viewSizes = [[FakeViewsSizeStorage alloc] initWithCountOfViews:6
                                                          estimatedSize:self.estimatedSize
                                                           accurateSize:self.accurateSize
                      ];
    
    self.layoutStrategy = [INFSimpleLayoutStrategy new];
    self.layoutStrategy.scrollViewSize = CGSizeMake(100.0, 100.0);
    self.layoutStrategy.sizesStorage = self.viewSizes;
    self.layoutStrategy.orientation = INFOrientationHorizontal;
}

- (void)tearDown {
    self.layoutStrategy = nil;
    self.viewSizes = nil;
    
    [super tearDown];
}

- (void)testInitialLayoutState {
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(0.0, 0.0)];
    
    XCTAssertEqual(layout.viewsLayoutInfo[0].size.width, self.accurateSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[1].size.width, self.accurateSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[2].size.width, self.estimatedSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[3].size.width, self.estimatedSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[4].size.width, self.accurateSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[5].size.width, self.accurateSize.width);
    
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, self.accurateSize.width * 5.5 + self.estimatedSize.width * 2);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, self.accurateSize.width * 2.5);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, self.accurateSize.width * 3 + self.estimatedSize.width * 0.5);
    XCTAssertEqual(layout.viewsLayoutInfo[3].center.x, self.accurateSize.width * 3 + self.estimatedSize.width * 1.5);
    XCTAssertEqual(layout.viewsLayoutInfo[4].center.x, self.accurateSize.width * 3.5 + self.estimatedSize.width * 2);
    XCTAssertEqual(layout.viewsLayoutInfo[5].center.x, self.accurateSize.width * 4.5 + self.estimatedSize.width * 2);
    
    XCTAssertEqual(layout.contentOffset.x, 400);
    XCTAssertEqual(layout.contentOffset.y, 0);
    
    XCTAssertEqual(layout.contentSize.width, 500);
    XCTAssertEqual(layout.contentSize.height, 100);
}

- (void)testPositiveShiftInMiddle {
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(74, 0.0)];
    
    XCTAssertEqual(layout.viewsLayoutInfo[0].size.width, self.accurateSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[1].size.width, self.accurateSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[2].size.width, self.accurateSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[3].size.width, self.accurateSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[4].size.width, self.estimatedSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[5].size.width, self.accurateSize.width);
    
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, self.accurateSize.width * 1.5);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, self.accurateSize.width * 2.5);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, self.accurateSize.width * 3.5);
    XCTAssertEqual(layout.viewsLayoutInfo[3].center.x, self.accurateSize.width * 4.5);
    XCTAssertEqual(layout.viewsLayoutInfo[4].center.x, self.accurateSize.width * 5 + self.estimatedSize.width * 0.5);
    XCTAssertEqual(layout.viewsLayoutInfo[5].center.x, self.accurateSize.width * 5.5 + self.estimatedSize.width * 1.0);
    
    XCTAssertEqual(layout.contentOffset.x, 74);
    XCTAssertEqual(layout.contentOffset.y, 0);
    
    XCTAssertEqual(layout.contentSize.width, 450);
    XCTAssertEqual(layout.contentSize.height, 100);
}

- (void)testLeftShiftBeforeJump {
    INFViewLayout* layout = [self.layoutStrategy layoutArrangedViewsForContentOffset:CGPointMake(1.0, 0.0)];
    
    XCTAssertEqual(layout.viewsLayoutInfo[0].size.width, self.accurateSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[1].size.width, self.accurateSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[2].size.width, self.accurateSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[3].size.width, self.estimatedSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[4].size.width, self.accurateSize.width);
    XCTAssertEqual(layout.viewsLayoutInfo[5].size.width, self.accurateSize.width);
    
    XCTAssertEqual(layout.viewsLayoutInfo[5].center.x, self.accurateSize.width * 0.5);
    XCTAssertEqual(layout.viewsLayoutInfo[0].center.x, self.accurateSize.width * 1.5);
    XCTAssertEqual(layout.viewsLayoutInfo[1].center.x, self.accurateSize.width * 2.5);
    XCTAssertEqual(layout.viewsLayoutInfo[2].center.x, self.accurateSize.width * 3.5);
    XCTAssertEqual(layout.viewsLayoutInfo[3].center.x, self.accurateSize.width * 4 + self.estimatedSize.width * 0.5);
    XCTAssertEqual(layout.viewsLayoutInfo[4].center.x, self.accurateSize.width * 4.5 + self.estimatedSize.width * 1.0);
    
    XCTAssertEqual(layout.contentOffset.x, 1.0);
    XCTAssertEqual(layout.contentOffset.y, 0.0);
    
    XCTAssertEqual(layout.contentSize.width, 450);
    XCTAssertEqual(layout.contentSize.height, 100);
}

@end
