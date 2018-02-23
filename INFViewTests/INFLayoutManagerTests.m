//
//  INFLayoutManagerTests.m
//  INFViewTests
//
//  Created by Alexander on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "INFLayoutManager.h"

@interface INFLayoutManagerTests : XCTestCase <INFLayoutTarget, INFLayoutDataSource>

@property (nonatomic) NSInteger numberOfItems;
@property (nonatomic) CGSize viewSize;

@property (copy, nonatomic) void(^updateAttributesCallBack)(INFViewLayoutAttributes*);
@property (copy, nonatomic) void(^updateContentSizeCallBack)(CGSize);
@property (copy, nonatomic) void(^updateContentOffsetCallBack)(CGPoint);

@end

@implementation INFLayoutManagerTests

- (void)setUp {
    [super setUp];
    
    self.updateAttributesCallBack = ^(INFViewLayoutAttributes* attributes) {
    };
    self.updateContentSizeCallBack = ^(CGSize contentSize) {
    };
    self.updateContentOffsetCallBack = ^(CGPoint contentOffset) {
    };
}

- (void)tearDown {
    [super tearDown];
    
    self.updateAttributesCallBack = nil;
    self.updateContentSizeCallBack = nil;
    self.updateContentOffsetCallBack = nil;
}

- (void)testInitialLayout {
    INFLayoutManager* layoutManager = [INFLayoutManager new];

    layoutManager.layoutTarget = self;
    layoutManager.layoutDataSource = self;
    layoutManager.scrollViewSize = CGSizeMake(100, 100);
    self.viewSize = layoutManager.scrollViewSize;
    self.numberOfItems = 3;
    
    XCTestExpectation* view1LayoutExpectation = [[XCTestExpectation alloc] initWithDescription:@"view1 layout"];
    XCTestExpectation* view2LayoutExpectation = [[XCTestExpectation alloc] initWithDescription:@"View2 layout"];
    XCTestExpectation* view3LayoutExpextation = [[XCTestExpectation alloc] initWithDescription:@"View3 layout"];
    XCTestExpectation* extraLayoutCallExpextation = [[XCTestExpectation alloc] initWithDescription:@"Extra layout call"];
    extraLayoutCallExpextation.inverted = YES;
   
    self.updateAttributesCallBack = ^(INFViewLayoutAttributes* attributes) {
        if (attributes.index == 0) {
            if (attributes.center.x == 150 && attributes.center.y == 50) {
                [view1LayoutExpectation fulfill];
            }
        } else if (attributes.index == 1) {
            if (attributes.center.x == 250 && attributes.center.y == 50) {
                [view2LayoutExpectation fulfill];
            }
        } else if (attributes.index == 2) {
            if (attributes.center.x == 50 && attributes.center.y == 50) {
                [view3LayoutExpextation fulfill];
            }
        } else {
            [extraLayoutCallExpextation fulfill];
        }
    };
    
    XCTestExpectation* contentSizeExpextation = [[XCTestExpectation alloc] initWithDescription:@"Content size"];
    self.updateContentSizeCallBack = ^(CGSize contentSize) {
        if (contentSize.width == 500 && contentSize.height == 100) {
            [contentSizeExpextation fulfill];
        }
    };
    
    [layoutManager arrangeViews];
    [self waitForExpectations:@[view1LayoutExpectation, view2LayoutExpectation, view3LayoutExpextation, extraLayoutCallExpextation, contentSizeExpextation] timeout:1.0];
}

- (void)testNoInfiniteScrolling {
    INFLayoutManager* layoutManager = [INFLayoutManager new];
    
    layoutManager.layoutTarget = self;
    layoutManager.layoutDataSource = self;
    layoutManager.scrollViewSize = CGSizeMake(100, 100);
    self.viewSize = layoutManager.scrollViewSize;
    self.numberOfItems = 1;
    
    XCTestExpectation* view1LayoutExpectation = [[XCTestExpectation alloc] initWithDescription:@"view1 layout"];
    XCTestExpectation* extraLayoutCallExpextation = [[XCTestExpectation alloc] initWithDescription:@"Extra layout call"];
    extraLayoutCallExpextation.inverted = YES;
    XCTestExpectation* contentSizeExpextation = [[XCTestExpectation alloc] initWithDescription:@"Content size"];
    
    self.updateAttributesCallBack = ^(INFViewLayoutAttributes* attributes) {
        if (attributes.index == 0) {
            if (attributes.center.x == 50 && attributes.center.y == 50) {
                [view1LayoutExpectation fulfill];
            }
        } else {
            [extraLayoutCallExpextation fulfill];
        }
    };
    
    self.updateContentSizeCallBack = ^(CGSize contentSize) {
        if (contentSize.width == 100 && contentSize.height == 100) {
            [contentSizeExpextation fulfill];
        }
    };
    
    [layoutManager arrangeViews];
    
    [self waitForExpectations:@[view1LayoutExpectation, extraLayoutCallExpextation, contentSizeExpextation] timeout:1.0];
}

-(void)testOffsetChangesOnScrolling{
    INFLayoutManager* layoutManager = [INFLayoutManager new];
    layoutManager.scrollViewSize = CGSizeMake(100, 100);
    self.viewSize = layoutManager.scrollViewSize;
    self.numberOfItems = 3;
    layoutManager.layoutTarget = self;
    layoutManager.layoutDataSource = self;
    [layoutManager arrangeViews];
    
    XCTestExpectation* shiftFromZero = [[XCTestExpectation alloc] initWithDescription:@"shift from zero"];
    self.updateContentOffsetCallBack = ^(CGPoint contentOffset) {
        if (contentOffset.x == 100) {
            [shiftFromZero fulfill];
        }
    };
    [layoutManager updateArrangedViewsForNewContentOffset:CGPointMake(0, 0)];
    [self waitForExpectations:@[shiftFromZero] timeout:1.0];
    
    XCTestExpectation* backToInitialPosition = [[XCTestExpectation alloc] initWithDescription:@"back to initial position"];
    self.updateContentOffsetCallBack = ^(CGPoint contentOffset) {
        if (contentOffset.x == 100) {
            [backToInitialPosition fulfill];
        }
    };
    [layoutManager updateArrangedViewsForNewContentOffset:CGPointMake(400, 0)];
    [self waitForExpectations:@[backToInitialPosition] timeout:1.0];
    
    XCTestExpectation* scrollAtBeginOffset = [[XCTestExpectation alloc] initWithDescription:@"scroll at begin - no offset changes"];
    scrollAtBeginOffset.inverted = YES;
    self.updateContentOffsetCallBack = ^(CGPoint contentOffset) {
        [scrollAtBeginOffset fulfill];
    };
    [layoutManager updateArrangedViewsForNewContentOffset:CGPointMake(170, 0)];
    [self waitForExpectations:@[scrollAtBeginOffset] timeout:1.0];
    
    XCTestExpectation* scrollAtMiddleOffset = [[XCTestExpectation alloc] initWithDescription:@"scroll at middle - no offset changes"];
    scrollAtMiddleOffset.inverted = YES;
    self.updateContentOffsetCallBack = ^(CGPoint contentOffset) {
        [scrollAtMiddleOffset fulfill];
    };
    [layoutManager updateArrangedViewsForNewContentOffset:CGPointMake(300, 0)];
    [self waitForExpectations:@[scrollAtMiddleOffset] timeout:1.0];
    
    XCTestExpectation* scrollAtEndOffset = [[XCTestExpectation alloc] initWithDescription:@"scroll at end - back to initial position"];
    self.updateContentOffsetCallBack = ^(CGPoint contentOffset) {
        if (contentOffset.x == 55) {
            [scrollAtEndOffset fulfill];
        }
    };
    [layoutManager updateArrangedViewsForNewContentOffset:CGPointMake(355, 0)];
    [self waitForExpectations:@[scrollAtEndOffset] timeout:0];
}


#pragma mark - INFLayoutTarget

- (void)setArrangedViewAttributes:(INFViewLayoutAttributes *)attributes {
    self.updateAttributesCallBack(attributes);
}

- (void)updateContentSize:(CGSize)contentSize {
    self.updateContentSizeCallBack(contentSize);
}

- (void)updateContentOffset:(CGPoint)contentOffset {
    self.updateContentOffsetCallBack(contentOffset);
}

#pragma mark - INFLayoutDataSource

- (NSInteger) numberOfArrangedViews {
    return self.numberOfItems;
}

- (CGSize) sizeForViewAtIndex:(NSInteger)index {
    return self.viewSize;
}

@end
