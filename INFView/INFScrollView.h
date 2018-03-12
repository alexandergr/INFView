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

@property (nonatomic) id<UITableViewDataSource, UITableViewDelegate> datasource;

-(void)reloadData;

@end

@protocol INFViewDataSource <NSObject>
@required
- (NSInteger)numberOfArrangedViewsInINFScrollView:(INFScrollView*)infScrollView;
- (UIView*)infScrollView:(INFScrollView*)infView arrangedViewForIndex:(NSInteger)index;
@optional
- (CGSize)infScrollView:(INFScrollView*)infView estimatedSizeForViewAtIndex:(NSInteger)index;
- (CGSize)infScrollView:(INFScrollView*)infView sizeForViewAtIndex:(NSInteger)index;
@end
