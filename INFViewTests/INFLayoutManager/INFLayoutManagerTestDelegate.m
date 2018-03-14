//
//  INFLayoutManagerTestDelegate.m
//  INFViewTests
//
//  Created by Oleksandr Hrushovyi on 3/14/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "INFLayoutManager.h"
#import "FakeLayoutDataSource.h"

typedef void(^DelegateCallback)(NSInteger index);

@interface INFLayoutManagerTestDelegate : XCTestCase <INFLayoutDelegate>

@property (strong, nonatomic) INFLayoutManager* layoutManager;

@property (nonatomic) DelegateCallback willShowCallback;
@property (nonatomic) DelegateCallback didShowCallback;
@property (nonatomic) DelegateCallback willHideCallback;
@property (nonatomic) DelegateCallback didHideCallback;

@end

@implementation INFLayoutManagerTestDelegate

- (void)setUp {
    [super setUp];
    
    self.layoutManager = [INFLayoutManager new];
    self.layoutManager.delegate = self;
    
    self.willShowCallback = ^(NSInteger index) {};
    self.didShowCallback = ^(NSInteger index) {};
    self.willHideCallback = ^(NSInteger index) {};
    self.didHideCallback = ^(NSInteger index) {};
}

- (void)tearDown {
    self.layoutManager = nil;
    
    self.willShowCallback = nil;
    self.didShowCallback = nil;
    self.willHideCallback = nil;
    self.didHideCallback = nil;
    
    [super tearDown];
}

- (void)testInitialAppearance {
    FakeLayoutDataSource* dataSource = [[FakeLayoutDataSource alloc] initWithViewsWidth:@[@50, @50, @50, @50] viewsHeight:100.0];
    
    self.layoutManager.scrollViewSize = CGSizeMake(100.0, 100.0);
    self.layoutManager.dataSource = dataSource;
    
    XCTestExpectation* view1WillAppear = [[XCTestExpectation alloc] initWithDescription:@"view1 will appear"];
    XCTestExpectation* view2WillAppear = [[XCTestExpectation alloc] initWithDescription:@"view2 will appear"];
    XCTestExpectation* extraViewWillAppear = [[XCTestExpectation alloc] initWithDescription:@"extra view will appear"];
    extraViewWillAppear.inverted = YES;
    self.willShowCallback = ^(NSInteger index) {
        if (index == 0) {
            [view1WillAppear fulfill];
        } else if (index == 1) {
            [view2WillAppear fulfill];
        } else {
            [extraViewWillAppear fulfill];
        }
    };
    
    XCTestExpectation* view1DidAppear = [[XCTestExpectation alloc] initWithDescription:@"view1 did appear"];
    XCTestExpectation* view2DidAppear = [[XCTestExpectation alloc] initWithDescription:@"view2 did appear"];
    XCTestExpectation* extraViewDidAppear = [[XCTestExpectation alloc] initWithDescription:@"extra view did appear"];
    extraViewDidAppear.inverted = YES;
    self.didShowCallback = ^(NSInteger index) {
        if (index == 0) {
            [view1DidAppear fulfill];
        } else if (index == 1) {
            [view2DidAppear fulfill];
        } else {
            [extraViewDidAppear fulfill];
        }
    };
    
    XCTestExpectation* extraViewWillDisappear = [[XCTestExpectation alloc] initWithDescription:@"extra view will disappear"];
    extraViewWillDisappear.inverted = YES;
    self.willHideCallback = ^(NSInteger index) {
        [extraViewWillDisappear fulfill];
    };
    
    XCTestExpectation* extraViewDidDisappear = [[XCTestExpectation alloc] initWithDescription:@"extra view did disappear"];
    extraViewDidDisappear.inverted = YES;
    self.didHideCallback = ^(NSInteger index) {
        [extraViewDidDisappear fulfill];
    };
    
    [self.layoutManager arrangeViews];
    
    [self waitForExpectations:@[view1WillAppear, view2WillAppear, extraViewWillAppear, view1DidAppear, view2DidAppear, extraViewDidAppear, extraViewWillDisappear, extraViewDidDisappear] timeout:1.0];
}

- (void)testAppearanceAndDisappearanceAfterShift {
    FakeLayoutDataSource* dataSource = [[FakeLayoutDataSource alloc] initWithViewsWidth:@[@50, @50, @50, @50] viewsHeight:100.0];
    
    self.layoutManager.scrollViewSize = CGSizeMake(100.0, 100.0);
    self.layoutManager.dataSource = dataSource;
    [self.layoutManager arrangeViews];
    
    XCTestExpectation* view3WillAppear = [[XCTestExpectation alloc] initWithDescription:@"view3 will appear"];
    XCTestExpectation* extraViewWillAppear = [[XCTestExpectation alloc] initWithDescription:@"extra view will appear"];
    extraViewWillAppear.inverted = YES;
    self.willShowCallback = ^(NSInteger index) {
        if (index == 2) {
            [view3WillAppear fulfill];
        } else {
            [extraViewWillAppear fulfill];
        }
    };
    
    XCTestExpectation* view3DidAppear = [[XCTestExpectation alloc] initWithDescription:@"view3 did appear"];
    XCTestExpectation* extraViewDidAppear = [[XCTestExpectation alloc] initWithDescription:@"extra view did appear"];
    extraViewDidAppear.inverted = YES;
    self.didShowCallback = ^(NSInteger index) {
        if (index == 2) {
            [view3DidAppear fulfill];
        } else {
            [extraViewDidAppear fulfill];
        }
    };
    
    XCTestExpectation* view1WillDisappear = [[XCTestExpectation alloc] initWithDescription:@"view1 will disappear"];
    XCTestExpectation* extraViewWillDisappear = [[XCTestExpectation alloc] initWithDescription:@"extra view will disappear"];
    extraViewWillDisappear.inverted = YES;
    self.willHideCallback = ^(NSInteger index) {
        if (index == 0) {
            [view1WillDisappear fulfill];
        } else {
            [extraViewWillDisappear fulfill];
        }
    };
    
    XCTestExpectation* view1DidDisappear = [[XCTestExpectation alloc] initWithDescription:@"view1 did disappear"];
    XCTestExpectation* extraViewDidDisappear = [[XCTestExpectation alloc] initWithDescription:@"extra view did disappear"];
    extraViewDidDisappear.inverted = YES;
    self.didHideCallback = ^(NSInteger index) {
        if (index == 0) {
            [view1DidDisappear fulfill];
        } else {
            [extraViewDidDisappear fulfill];
        }
    };
    
    [self.layoutManager updateArrangedViewsForNewContentOffset:CGPointMake(100.0, 0.0)];
    
    [self waitForExpectations:@[view3WillAppear, extraViewWillAppear, view3DidAppear,extraViewDidAppear, view1WillDisappear, extraViewWillDisappear, view1DidDisappear, extraViewDidDisappear] timeout:1.0];
}

#pragma mark - INFLayoutDelegate

- (void)willShowViewAtIndex:(NSInteger)index {
    self.willShowCallback(index);
}

- (void)didShowViewAtIndex:(NSInteger)index {
    self.didShowCallback(index);
}

- (void)willHideViewAtIndex:(NSInteger)index {
    self.willHideCallback(index);
}

- (void)didHideViewAtIndex:(NSInteger)index {
    self.didHideCallback(index);
}
@end
