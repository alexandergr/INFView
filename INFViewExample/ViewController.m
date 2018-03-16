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

@property (strong, nonatomic) NSArray<UIColor*>* horizontalyArrangedColors;
@property (strong, nonatomic) NSArray<UIColor*>* verticallyArrangedColors;
@property (nonatomic) CGSize colorViewSize;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorViewSize = CGSizeMake(150, 150);

    self.horizontalyArrangedColors = @[
        UIColor.whiteColor,
        UIColor.cyanColor,
        UIColor.blueColor,
        UIColor.greenColor,
        UIColor.yellowColor,
        UIColor.orangeColor,
        UIColor.magentaColor,
        UIColor.redColor,
        UIColor.purpleColor,
        UIColor.blackColor,
    ];

    self.verticallyArrangedColors = @[
        UIColor.redColor,
        UIColor.greenColor,
        UIColor.blueColor,
        UIColor.yellowColor,
        UIColor.orangeColor,
        UIColor.magentaColor,
        UIColor.cyanColor,
        UIColor.purpleColor,
        UIColor.blackColor,
        UIColor.whiteColor
    ];

    self.horizontalInfScrollView.dataSource = self;

    self.verticalInfScrollView.orientation = INFOrientationVertical;
    self.verticalInfScrollView.dataSource = self;

}
- (UIView*)createViewWithColor:(UIColor*)color {
    CGRect frame = CGRectMake(0, 0, self.colorViewSize.width, self.colorViewSize.height);
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

#pragma mark - INFViewDataSource

- (NSInteger)numberOfArrangedViewsInINFScrollView:(INFScrollView *)infView {
    if (infView == self.horizontalInfScrollView) {
        return self.horizontalyArrangedColors.count;
    }
    if (infView == self.verticalInfScrollView) {
        return self.verticallyArrangedColors.count;
    }
    return 0;
}

- (UIView*)infScrollView:(INFScrollView *)infView arrangedViewForIndex:(NSInteger)index {
    if (infView == self.horizontalInfScrollView) {
        return [self createViewWithColor:self.horizontalyArrangedColors[index]];
    }
    if (infView == self.verticalInfScrollView) {
        return [self createViewWithColor:self.verticallyArrangedColors[index]];
    }
    return nil;
}

- (CGSize) infScrollView:(INFScrollView *)infView sizeForViewAtIndex:(NSInteger)index {
    return self.colorViewSize;
}

@end
