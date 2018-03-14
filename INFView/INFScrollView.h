//
//  INFScrollView.h
//  INFView
//
//  Created by Alexander on 2/1/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INFOrientation.h"

@protocol INFScrollViewDataSource;
@protocol INFScrollViewDelegate;

@interface INFScrollView : UIScrollView

@property (weak, nonatomic, nullable) id<INFScrollViewDataSource> dataSource;
@property (weak, nonatomic, nullable) id<INFScrollViewDelegate, UIScrollViewDelegate> delegate;
@property (nonatomic) INFOrientation orientation;

-(void)reloadData;

@end

@protocol INFScrollViewDataSource <NSObject>
@required
- (NSInteger)numberOfArrangedViewsInINFScrollView:(nonnull INFScrollView*)scrollView;
- (nonnull UIView*)infScrollView:(nonnull INFScrollView*)infView arrangedViewForIndex:(NSInteger)index;
@optional
- (CGSize)infScrollView:(nonnull INFScrollView*)scrollView estimatedSizeForViewAtIndex:(NSInteger)index;
- (CGSize)infScrollView:(nonnull INFScrollView*)scrollView sizeForViewAtIndex:(NSInteger)index;
@end

@protocol INFScrollViewDelegate <NSObject>
@optional
- (void)infScrollView:(nonnull INFScrollView*)scrollView willShowViewAtIndex:(NSInteger)index;
- (void)infScrollView:(nonnull INFScrollView*)scrollView didShowViewAtIndex:(NSInteger)index;
- (void)infScrollView:(nonnull INFScrollView*)scrollView willHideViewAtIndex:(NSInteger)index;
- (void)infScrollView:(nonnull INFScrollView*)scrollView didHideViewAtIndex:(NSInteger)index;
@end
