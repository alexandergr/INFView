//
//  INFViewLayoutViewSizeChanges.m
//  INFViewTests
//
//  Created by Oleksandr Hrushovyi on 3/13/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "INFViewLayout.h"

@interface INFViewLayoutViewSizeChanges : XCTestCase

@property (strong, nonatomic) INFViewLayout* layout;

@end

@implementation INFViewLayoutViewSizeChanges

- (void)setUp {
    [super setUp];
    
    self.layout = [INFViewLayout new];
    self.layout.orientation = INFOrientationHorizontal;
    
    NSMutableArray<INFLayoutViewInfo*>* viewsLayoutInfo = [NSMutableArray new];
    CGFloat viewPosition = 0;
    for (NSInteger i = 0; i < 5; i++) {
        INFLayoutViewInfo* viewInfo = [[INFLayoutViewInfo alloc] initWithIndex:i size:CGSizeMake(100.0, 100.0)];
        [viewInfo setPosition:(viewPosition + [viewInfo getLengthForOrientation:self.layout.orientation] / 2.0) forOrientation:self.layout.orientation];
        [viewsLayoutInfo addObject:viewInfo];
        viewPosition += [viewInfo getLengthForOrientation:self.layout.orientation];
    }
    self.layout.contentSize = CGSizeMake(viewPosition, 100);
    self.layout.viewsLayoutInfo = viewsLayoutInfo;
    self.layout.leadingViewsRange = NSMakeRange(0, 1);
    self.layout.trailingViewsRange = NSMakeRange(4, 1);
}

- (void)tearDown {
    self.layout = nil;
    
    [super tearDown];
}

- (void) testInitialLayoutState {
    XCTAssertEqual(self.layout.contentSize.width, 500.0);
    XCTAssertEqual([self.layout lengthOfAllViews], 500.0);
    XCTAssertEqual([self.layout lengthOfLeadingViews], 100.0);
    XCTAssertEqual([self.layout lengthOfTrailingViews], 100.0);
    
    XCTAssertEqual(self.layout.viewsLayoutInfo[0].center.x, 050.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[1].center.x, 150.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[2].center.x, 250.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[3].center.x, 350.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[4].center.x, 450.0);
}

- (void)testContentSizeChanges {
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:1];
    XCTAssertEqual(self.layout.contentSize.width, 450.0);
    
    [self.layout setAccurateSize:CGSizeMake(100.0, 100.0) forViewAtIndex:2];
    XCTAssertEqual(self.layout.contentSize.width, 450.0);
    XCTAssertEqual([self.layout lengthOfAllViews], 450.0);
}

- (void)testLeadingViewsSizeChanges {
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:0];
    XCTAssertEqual([self.layout lengthOfLeadingViews], 50.0);
    XCTAssertEqual([self.layout lengthOfAllViews], 450.0);
}

- (void)testTrailingViewsSizeChanges {
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:4];
    XCTAssertEqual([self.layout lengthOfTrailingViews], 50.0);
    XCTAssertEqual([self.layout lengthOfAllViews], 450.0);
}

- (void)testContentOffsetDoesNotChange {
    [self.layout setContentOffsetPosition:0.0];
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:0];
    XCTAssertEqual([self.layout getContentOffsetPosition], 0.0);
    
    [self.layout setContentOffsetPosition:150.0];
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:2];
    XCTAssertEqual([self.layout getContentOffsetPosition], 150.0);
    
    [self.layout setContentOffsetPosition:200.0];
    [self.layout setAccurateSize:CGSizeMake(200.0, 100.0) forViewAtIndex:3];
    XCTAssertEqual([self.layout getContentOffsetPosition], 200.0);
}

- (void)testContentOffsetChangesAccourdingToSizeChanges {
    [self.layout setContentOffsetPosition:100.0];
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:0];
    XCTAssertEqual([self.layout getContentOffsetPosition], 50.0);
    
    [self.layout setContentOffsetPosition:250.0];
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:2];
    XCTAssertEqual([self.layout getContentOffsetPosition], 200.0);
    
    [self.layout setContentOffsetPosition:300.0];
    [self.layout setAccurateSize:CGSizeMake(200.0, 100.0) forViewAtIndex:3];
    XCTAssertEqual([self.layout getContentOffsetPosition], 400.0);
}

- (void)testContentOffsetChangesInCaseLocatedInsizeOfView {
    [self.layout setContentOffsetPosition:10.0];
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:0];
    XCTAssertEqual([self.layout getContentOffsetPosition], 5.0);
    
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:1];
    
    [self.layout setContentOffsetPosition:190.0];
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:2];
    XCTAssertEqual([self.layout getContentOffsetPosition], 145.0);
}

- (void)testItemsPositionForSizeChanges {
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:0];
    XCTAssertEqual(self.layout.viewsLayoutInfo[0].center.x, 025.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[1].center.x, 100.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[2].center.x, 200.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[3].center.x, 300.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[4].center.x, 400.0);
    
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:2];
    XCTAssertEqual(self.layout.viewsLayoutInfo[0].center.x, 025.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[1].center.x, 100.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[2].center.x, 175.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[3].center.x, 250.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[4].center.x, 350.0);
    
    [self.layout setAccurateSize:CGSizeMake(200.0, 100.0) forViewAtIndex:3];
    XCTAssertEqual(self.layout.viewsLayoutInfo[0].center.x, 025.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[1].center.x, 100.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[2].center.x, 175.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[3].center.x, 300.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[4].center.x, 450.0);
}

- (void)testItemsPositionForSizeChangesAfterShiftOfAllViews {
    [self.layout shiftViewsWithOffset:1000];
    
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:0];
    XCTAssertEqual(self.layout.viewsLayoutInfo[0].center.x, 1025.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[1].center.x, 1100.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[2].center.x, 1200.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[3].center.x, 1300.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[4].center.x, 1400.0);
    
    [self.layout setAccurateSize:CGSizeMake(50.0, 50.0) forViewAtIndex:2];
    XCTAssertEqual(self.layout.viewsLayoutInfo[0].center.x, 1025.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[1].center.x, 1100.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[2].center.x, 1175.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[3].center.x, 1250.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[4].center.x, 1350.0);
    
    [self.layout setAccurateSize:CGSizeMake(200.0, 100.0) forViewAtIndex:3];
    XCTAssertEqual(self.layout.viewsLayoutInfo[0].center.x, 1025.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[1].center.x, 1100.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[2].center.x, 1175.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[3].center.x, 1300.0);
    XCTAssertEqual(self.layout.viewsLayoutInfo[4].center.x, 1450.0);
}
@end
