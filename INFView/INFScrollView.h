//
//  INFScrollView.h
//  INFView
//
//  Created by Alexander on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INFOrientation.h"

@protocol INFViewDataSource;

@interface INFScrollView : UIScrollView

@property (weak, nonatomic) id<INFViewDataSource> dataSource;
@property (nonatomic) INFOrientation orientation;

-(void)reloadData;

@end

@protocol INFViewDataSource
@required
- (NSInteger)numberOfSubViewsInINFView:(INFScrollView*)infView;
- (UIView*)infView:(INFScrollView*)infView subViewAtIndex:(NSInteger)index;

@end
