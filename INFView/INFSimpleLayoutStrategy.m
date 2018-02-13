//
//  INFSimpleLayoutStrategy.m
//  INFView
//
//  Created by Alexander on 2/9/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFSimpleLayoutStrategy.h"

@implementation INFSimpleLayoutStrategy

- (INFViewLayout *)layoutArrangedViews {
    INFViewLayout* layout = [INFViewLayout new];

    NSMutableArray<INFViewLayoutAttributes*>* viewsAttributes = [NSMutableArray new];
    CGFloat contentSize = 0.0;
    CGFloat scrollViewSize = [self getViewSize];

    for (NSInteger i = 0; i < self.numberOfArrangedViews; i++) {
        CGPoint attributeCenter = [self attributeCenterForPosition:(contentSize + scrollViewSize / 2)];

        INFViewLayoutAttributes* attributes = [INFViewLayoutAttributes new];
        attributes.center = attributeCenter;
        attributes.index = i;
        attributes.containerSize = self.scrollViewSize;

        [viewsAttributes addObject:attributes];
        contentSize += scrollViewSize;
    }

    CGPoint newContentOffset = self.contentOffset;
    if (contentSize >= scrollViewSize * 2.0) {

        for (INFViewLayoutAttributes* attributes in viewsAttributes) {
            CGFloat positionWithShift = [self positionFromAttribureCenter:attributes.center] + scrollViewSize;
            attributes.center = [self attributeCenterForPosition:positionWithShift];
        }

        CGFloat contentOffsetPosition = [self getPositionFromContentOffset];
        if (contentOffsetPosition == 0) {
            contentOffsetPosition = scrollViewSize;
            newContentOffset = [self makeContentOffsetFromPosition:contentOffsetPosition];
        } else if (contentOffsetPosition < scrollViewSize / 2.0) {
            contentOffsetPosition = scrollViewSize + contentSize - contentOffsetPosition;
            newContentOffset = [self makeContentOffsetFromPosition:contentOffsetPosition];
        } else if (contentOffsetPosition > contentSize + scrollViewSize / 2.0) {
            contentOffsetPosition = contentOffsetPosition - contentSize;
            newContentOffset = [self makeContentOffsetFromPosition:contentOffsetPosition];
        }

        INFViewLayoutAttributes* firstItemAttributes = viewsAttributes.firstObject;
        INFViewLayoutAttributes* lastItemAttributes = viewsAttributes.lastObject;

        if (contentOffsetPosition > contentSize - scrollViewSize) {
            CGFloat lastItemPosition = scrollViewSize + contentSize - scrollViewSize / 2.0;
            lastItemAttributes.center = [self attributeCenterForPosition:lastItemPosition];

            CGFloat firstItemPosition = scrollViewSize + contentSize - scrollViewSize / 2.0;
            firstItemAttributes.center = [self attributeCenterForPosition:firstItemPosition];

        } else if (contentOffsetPosition < contentSize * 2.0) {
            CGFloat lastItemPosition = scrollViewSize - scrollViewSize / 2.0;
            lastItemAttributes.center = [self attributeCenterForPosition:lastItemPosition];

            CGFloat firstItemPosition = scrollViewSize + scrollViewSize / 2.0;
            firstItemAttributes.center = [self attributeCenterForPosition:firstItemPosition];
        }

        contentSize += scrollViewSize * 2.0;
    }

    layout.viewsAttributes = viewsAttributes;
    layout.contentSize = [self makeContentSizeForContentLength:contentSize];
    layout.contentOffset = newContentOffset;

    return layout;
}

- (CGFloat)getViewSize {
    if (self.orientation == INFOrientationHorizontal) {
        return self.scrollViewSize.width;
    } else {
        return self.scrollViewSize.height;
    }
}

- (CGFloat)getPositionFromContentOffset {
    if (self.orientation == INFOrientationHorizontal) {
        return self.contentOffset.x;
    } else {
        return self.contentOffset.y;
    }
}

- (CGPoint)makeContentOffsetFromPosition:(CGFloat)newPosition {
    if (self.orientation == INFOrientationHorizontal) {
        return CGPointMake(newPosition, self.contentOffset.y);
    } else {
        return CGPointMake(self.contentOffset.x, newPosition);
    }
}

- (CGPoint)attributeCenterForPosition:(CGFloat)position {
    if (self.orientation == INFOrientationHorizontal) {
        return CGPointMake(position, self.scrollViewSize.height / 2.0);
    } else {
        return CGPointMake(self.scrollViewSize.width / 2.0, position);
    }
}

- (CGFloat)positionFromAttribureCenter:(CGPoint)center {
    if (self.orientation == INFOrientationHorizontal) {
        return center.x;
    } else {
        return center.y;
    }
}

- (CGSize)makeContentSizeForContentLength:(CGFloat)contentLength {
    if (self.orientation == INFOrientationHorizontal) {
        return CGSizeMake(contentLength, self.scrollViewSize.height);
    } else {
        return CGSizeMake(self.scrollViewSize.width, contentLength);
    }
}

@end
