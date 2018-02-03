//
//  INFViewLayoutManagerTests.m
//  INFViewTests
//
//  Created by Alexander on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "INFViewLayoutManager.h"

@interface INFViewLayoutManagerTests : XCTestCase <INFViewLayoutManagerDelegate>

@property (nonatomic) NSInteger numberOfItems;

@property (copy, nonatomic) void(^updatedAttributesCallBack)(INFViewLayoutAttributes*);
@property (copy, nonatomic) void(^updatedContentSizeCallBack)(CGSize);
@property (copy, nonatomic) void(^updatedContentOffsetCallBack)(CGPoint);

@end

@implementation INFViewLayoutManagerTests

- (void)setUp {
    [super setUp];
    
    self.updatedAttributesCallBack = ^(INFViewLayoutAttributes* attributes) {
    };
    self.updatedContentSizeCallBack = ^(CGSize contentSize) {
    };
    self.updatedContentOffsetCallBack = ^(CGPoint contentOffset) {
    };
}

- (void)tearDown {
    [super tearDown];
    
    self.updatedAttributesCallBack = nil;
    self.updatedContentSizeCallBack = nil;
    self.updatedContentOffsetCallBack = nil;
}

- (void)testInitialLayout {
    INFViewLayoutManager* layout = [INFViewLayoutManager new];

    layout.delegate = self;
    layout.viewSize = CGSizeMake(100, 100);
    self.numberOfItems = 3;
    
    XCTestExpectation* view1LayoutExpectation = [[XCTestExpectation alloc] initWithDescription:@"view1 layout"];
    XCTestExpectation* view2LayoutExpectation = [[XCTestExpectation alloc] initWithDescription:@"View2 layout"];
    XCTestExpectation* view3LayoutExpextation = [[XCTestExpectation alloc] initWithDescription:@"View3 layout"];
    XCTestExpectation* extraLayoutCallExpextation = [[XCTestExpectation alloc] initWithDescription:@"Extra layout call"];
    extraLayoutCallExpextation.inverted = YES;
   
    self.updatedAttributesCallBack = ^(INFViewLayoutAttributes* attributes) {
        if (attributes.index == 0) {
            if (attributes.center.x == 150 && attributes.center.y == 50) {
                [view1LayoutExpectation fulfill];
            }
        } else if (attributes.index == 1) {
            if (attributes.center.x == 250 && attributes.center.y == 50) {
                [view2LayoutExpectation fulfill];
            }
        } else if (attributes.index == 2) {
            if (attributes.center.x == 350 && attributes.center.y == 50) {
                [view3LayoutExpextation fulfill];
            }
        } else {
            [extraLayoutCallExpextation fulfill];
        }
    };
    
    XCTestExpectation* contentSizeExpextation = [[XCTestExpectation alloc] initWithDescription:@"Content size"];
    self.updatedContentSizeCallBack = ^(CGSize contentSize) {
        if (contentSize.width == 500 && contentSize.height == 100) {
            [contentSizeExpextation fulfill];
        }
    };
    
    [layout arrangeViews];
    [self waitForExpectations:@[view1LayoutExpectation, view2LayoutExpectation, view3LayoutExpextation, extraLayoutCallExpextation, contentSizeExpextation] timeout:1.0];
}

- (void)testNoInfiniteScrolling {
    INFViewLayoutManager* layout = [INFViewLayoutManager new];
    
    layout.delegate = self;
    layout.viewSize = CGSizeMake(100, 100);
    self.numberOfItems = 1;
    
    XCTestExpectation* view1LayoutExpectation = [[XCTestExpectation alloc] initWithDescription:@"view1 layout"];
    XCTestExpectation* extraLayoutCallExpextation = [[XCTestExpectation alloc] initWithDescription:@"Extra layout call"];
    extraLayoutCallExpextation.inverted = YES;
    XCTestExpectation* contentSizeExpextation = [[XCTestExpectation alloc] initWithDescription:@"Content size"];
    
    self.updatedAttributesCallBack = ^(INFViewLayoutAttributes* attributes) {
        if (attributes.index == 0) {
            if (attributes.center.x == 50 && attributes.center.y == 50) {
                [view1LayoutExpectation fulfill];
            }
        } else {
            [extraLayoutCallExpextation fulfill];
        }
    };
    
    self.updatedContentSizeCallBack = ^(CGSize contentSize) {
        if (contentSize.width == 100 && contentSize.height == 100) {
            [contentSizeExpextation fulfill];
        }
    };
    
    [layout arrangeViews];
    
    [self waitForExpectations:@[view1LayoutExpectation, extraLayoutCallExpextation, contentSizeExpextation] timeout:1.0];
}

-(void)testOffsetChangesOnScrolling{
    INFViewLayoutManager* layout = [INFViewLayoutManager new];
    layout.viewSize = CGSizeMake(100, 100);
    self.numberOfItems = 3;
    layout.delegate = self;
    [layout arrangeViews];
    
    XCTestExpectation* shiftFromZero = [[XCTestExpectation alloc] initWithDescription:@"shift from zero"];
    self.updatedContentOffsetCallBack = ^(CGPoint contentOffset) {
        if (contentOffset.x == 400) {
            [shiftFromZero fulfill];
        }
    };
    layout.contentOffset = CGPointMake(0, 0);
    [self waitForExpectations:@[shiftFromZero] timeout:1.0];
    
    XCTestExpectation* backToInitialPosition = [[XCTestExpectation alloc] initWithDescription:@"back to initial position"];
    self.updatedContentOffsetCallBack = ^(CGPoint contentOffset) {
        if (contentOffset.x == 100) {
            [backToInitialPosition fulfill];
        }
    };
    layout.contentOffset = CGPointMake(400, 0);
    [self waitForExpectations:@[backToInitialPosition] timeout:1.0];
    
    XCTestExpectation* scrollAtBeginOffset = [[XCTestExpectation alloc] initWithDescription:@"scroll at begin - no offset changes"];
    scrollAtBeginOffset.inverted = YES;
    self.updatedContentOffsetCallBack = ^(CGPoint contentOffset) {
        [scrollAtBeginOffset fulfill];
    };
    layout.contentOffset = CGPointMake(170, 0);
    [self waitForExpectations:@[scrollAtBeginOffset] timeout:1.0];
    
    XCTestExpectation* scrollAtMiddleOffset = [[XCTestExpectation alloc] initWithDescription:@"scroll at middle - no offset changes"];
    scrollAtMiddleOffset.inverted = YES;
    self.updatedContentOffsetCallBack = ^(CGPoint contentOffset) {
        [scrollAtMiddleOffset fulfill];
    };
    layout.contentOffset = CGPointMake(300, 0);
    [self waitForExpectations:@[scrollAtMiddleOffset] timeout:1.0];
    
    XCTestExpectation* scrollAtEndOffset = [[XCTestExpectation alloc] initWithDescription:@"scroll at end - back to initial position"];
    self.updatedContentOffsetCallBack = ^(CGPoint contentOffset) {
        if (contentOffset.x == 55) {
            [scrollAtEndOffset fulfill];
        }
    };
    layout.contentOffset = CGPointMake(355, 0);
    [self waitForExpectations:@[scrollAtEndOffset] timeout:0];
}


#pragma mark - INFViewLayoutManagerDelegate

- (NSInteger)numberOfItemsInInfViewLayoutManager:(INFViewLayoutManager *)layout {
    return self.numberOfItems;
}

- (void)infViewLayoutManager:(INFViewLayoutManager *)layout updatedAttributes:(INFViewLayoutAttributes *)attributes {
    self.updatedAttributesCallBack(attributes);
}

- (void)infViewLayoutManager:(INFViewLayoutManager *)layout updatedContentSize:(CGSize)contentSize {
    self.updatedContentSizeCallBack(contentSize);
}

- (void)infViewLayoutManager:(INFViewLayoutManager *)layout updatedContentOffset:(CGPoint)contentOffset {
    self.updatedContentOffsetCallBack(contentOffset);
}

@end
