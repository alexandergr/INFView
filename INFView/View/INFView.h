//
//  INFView.h
//  INFView
//
//  Created by Alexander on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol INFViewDataSource;

@interface INFView : UIScrollView

@property (nonatomic, weak) id<INFViewDataSource> dataSource;

-(void)reloadData;

@end

@protocol INFViewDataSource
@required
- (NSInteger) numberOfSubViewsInINFView:(INFView*)infView;
- (UIView*) infView:(INFView*)infView subViewAtIndex:(NSInteger)index;

@end
