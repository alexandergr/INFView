//
//  ViewController.m
//  INFViewExample
//
//  Created by Alexander on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "ViewController.h"
#import <INFView/INFView.h>

@interface ViewController () <INFScrollViewDataSource>

@property (weak, nonatomic) IBOutlet INFScrollView *horizontalInfScrollView;
@property (weak, nonatomic) IBOutlet INFScrollView *verticalInfScrollView;

@property (strong, nonatomic) NSArray<UIView*>* horizontalyArrangedViews;
@property (strong, nonatomic) NSArray<UIView*>* verticallyArrangedViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.horizontalyArrangedViews = @[
        [self createViewWithColor:UIColor.whiteColor],
        [self createViewWithColor:UIColor.cyanColor],
        [self createViewWithColor:UIColor.blueColor],
        [self createViewWithColor:UIColor.greenColor],
        [self createViewWithColor:UIColor.yellowColor],
        [self createViewWithColor:UIColor.orangeColor],
        [self createViewWithColor:UIColor.magentaColor],
        [self createViewWithColor:UIColor.redColor],
        [self createViewWithColor:UIColor.purpleColor],
        [self createViewWithColor:UIColor.blackColor],
        ];

    self.verticallyArrangedViews = @[
                                     [self createViewWithColor:UIColor.redColor],
                                     [self createViewWithColor:UIColor.greenColor],
                                     [self createViewWithColor:UIColor.blueColor],
                                     [self createViewWithColor:UIColor.yellowColor],
                                     [self createViewWithColor:UIColor.orangeColor],
                                     [self createViewWithColor:UIColor.magentaColor],
                                     [self createViewWithColor:UIColor.cyanColor],
                                     [self createViewWithColor:UIColor.purpleColor],
                                     [self createViewWithColor:UIColor.blackColor],
                                     [self createViewWithColor:UIColor.whiteColor]
                                      ];

    self.horizontalInfScrollView.dataSource = self;

    self.verticalInfScrollView.orientation = INFOrientationVertical;
    self.verticalInfScrollView.dataSource = self;

}
- (UIView*)createViewWithColor:(UIColor*)color {
    CGRect frame = CGRectMake(0, 0, 150, 150);
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

#pragma mark - INFViewDataSource

- (NSInteger)numberOfArrangedViewsInINFScrollView:(INFScrollView *)infView {
    if (infView == self.horizontalInfScrollView) {
        return self.horizontalyArrangedViews.count;
    }
    if (infView == self.verticalInfScrollView) {
        return self.verticallyArrangedViews.count;
    }
    return 0;
}

- (UIView*)infScrollView:(INFScrollView *)infView arrangedViewForIndex:(NSInteger)index {
    if (infView == self.horizontalInfScrollView) {
        return self.horizontalyArrangedViews[index];
    }
    if (infView == self.verticalInfScrollView) {
        return self.verticallyArrangedViews[index];
    }
    return nil;
}

- (CGSize) infScrollView:(INFScrollView *)infView sizeForViewAtIndex:(NSInteger)index {
    if (infView == self.horizontalInfScrollView) {
        return self.horizontalyArrangedViews[index].frame.size;
    }
    if (infView == self.verticalInfScrollView) {
        return self.verticallyArrangedViews[index].frame.size;
    }
    return CGSizeZero;
}

@end
