//
//  INFSimpleLayoutStrategy.m
//  INFView
//
//  Created by Alexander on 2/9/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

#import "INFSimpleLayoutStrategy.h"
#import "INFLayoutRuler.h"

@interface INFSimpleLayoutStrategy ()

@property (strong, nonatomic) INFLayoutRuler* ruler;
@property (strong, nonatomic) NSMutableArray<INFViewLayoutAttributes*>* attributes;

@end

@implementation INFSimpleLayoutStrategy

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ruler = [INFLayoutRuler new];
    }
    return self;
}

- (void)setupAttributesAtInitialPositions {
    self.attributes = [NSMutableArray new];
    CGFloat contentSize = 0.0;

    for (NSInteger i = 0; i < [self.ruler countOfArrangedViews]; i++) {
        CGFloat arrangedViewLength = [self.ruler lengthOfArrangedView:i];

        INFViewLayoutAttributes* viewAttributes = [INFViewLayoutAttributes new];
        viewAttributes.index = i;

        [self.ruler viewAttributes:viewAttributes setPosition:(contentSize + arrangedViewLength / 2)];

        [self.attributes addObject:viewAttributes];
        contentSize += arrangedViewLength;
    }
}

- (double)minimalSizeOfSideContent {
    return [self.ruler getLengthOfScrollView] / 2.0;
}

- (NSInteger)countOfLeadingViews {
    NSInteger count = 0;
    NSInteger totalCount = [self.ruler countOfArrangedViews];
    CGFloat requiredSize = [self.ruler getLengthOfScrollView] / 2.0;
    while (count < totalCount && [self.ruler lengthOfArrangedViewsInRange:NSMakeRange(0, count)] < requiredSize) {
        count += 1;
    }
    return count;
}

- (NSInteger)countOfTrailingViews {
    NSInteger count = 0;
    NSInteger totalCount = [self.ruler countOfArrangedViews];
    CGFloat requiredSize = [self minimalSizeOfSideContent];
    while (count < totalCount && [self.ruler lengthOfArrangedViewsInRange:NSMakeRange(totalCount - count, count)] < requiredSize) {
        count += 1;
    }
    return count;
}

- (NSRange) rangeOfLeadingViews {
    NSInteger count = [self countOfLeadingViews];
    NSRange range = NSMakeRange(0, count);
    return range;
}

- (NSRange) rangeOfTrailingViews {
    NSInteger count = [self countOfTrailingViews];
    NSInteger totalCount = [self.ruler countOfArrangedViews];
    NSRange range = NSMakeRange(totalCount - count, count);
    return range;
}

- (CGFloat)lenghtOfLeadingViews {
    NSRange range = [self rangeOfLeadingViews];
    return [self.ruler lengthOfArrangedViewsInRange:range];
}

- (CGFloat)lenghtOfTrailingViews {
    NSRange range = [self rangeOfTrailingViews];
    return [self.ruler lengthOfArrangedViewsInRange:range];
}

- (BOOL)canHaveScrolling {
    CGFloat totalSize = [self.ruler lengthOfAllArrangedViews];
    CGFloat sizeOfLeadingViews = [self lenghtOfLeadingViews];
    CGFloat sizeOfTrailingViews = [self lenghtOfTrailingViews];

    return (sizeOfLeadingViews >= [self minimalSizeOfSideContent])
    && (sizeOfTrailingViews >= [self minimalSizeOfSideContent]) && ((totalSize - sizeOfLeadingViews - sizeOfTrailingViews) >= [self.ruler getLengthOfScrollView]);
}

- (INFViewLayout*)layoutArrangedViewsForContentOffset:(CGPoint)contentOffset {
    INFViewLayout* layout = [INFViewLayout new];
    layout.contentOffset = contentOffset;

    [self setupAttributesAtInitialPositions];

    CGFloat leadingSpacing = 0;
    CGFloat tralingSpacing = 0;

    if ([self canHaveScrolling]) {
        leadingSpacing = [self lenghtOfTrailingViews];
        tralingSpacing = [self lenghtOfLeadingViews];

        for (INFViewLayoutAttributes* viewAttributes in self.attributes) {
            CGFloat positionWithShift = [self.ruler getPosition:viewAttributes] + leadingSpacing;
            [self.ruler viewAttributes:viewAttributes setPosition:positionWithShift];
        }

        CGFloat sizeOfScrollView = [self.ruler getLengthOfScrollView];

        CGFloat contentOffsetPosition = [self.ruler getContentOffsetPositionFromLayout:layout];
        if (contentOffsetPosition == 0) {
            contentOffsetPosition = leadingSpacing;
            [self.ruler layout:layout setContentOffsetToPosition:contentOffsetPosition];

        } else if (contentOffsetPosition <= leadingSpacing / 4.0) {
            contentOffsetPosition = leadingSpacing + ([self.ruler lengthOfAllArrangedViews] - (leadingSpacing - contentOffsetPosition));
            [self.ruler layout:layout setContentOffsetToPosition:contentOffsetPosition];

        } else if (contentOffsetPosition + sizeOfScrollView + (tralingSpacing/4.0) >= leadingSpacing + [self.ruler lengthOfAllArrangedViews] + tralingSpacing) {
            contentOffsetPosition = leadingSpacing + (contentOffsetPosition - ([self.ruler lengthOfAllArrangedViews] + leadingSpacing));
            [self.ruler layout:layout setContentOffsetToPosition:contentOffsetPosition];

        }

        if (contentOffsetPosition + sizeOfScrollView >= leadingSpacing + [self.ruler lengthOfAllArrangedViews]) {
            NSRange range = [self rangeOfLeadingViews];
            [self moveViewsInRange:range toPosition:(leadingSpacing + [self.ruler lengthOfAllArrangedViews])];

        } else if (contentOffsetPosition <= leadingSpacing) {
            NSRange range = [self rangeOfTrailingViews];
            [self moveViewsInRange:range toPosition:0.0];
        }
    }

    layout.viewsAttributes = self.attributes;
    CGFloat contentSize = leadingSpacing + [self.ruler lengthOfAllArrangedViews] + tralingSpacing;
    [self.ruler layout:layout setContentLength:contentSize];

    return layout;
}

- (void)moveViewsInRange:(NSRange)range toPosition:(CGFloat)position {
    CGFloat groupSize = 0;
    for (NSInteger j = 0; j < range.length; j++) {
        NSInteger i = range.location + j;

        CGFloat viewLength = [self.ruler lengthOfArrangedView:i];
        CGFloat newPosition = position + groupSize + viewLength / 2.0;
        INFViewLayoutAttributes* viewAttributes = self.attributes[i];
        [self.ruler viewAttributes:viewAttributes setPosition:newPosition];
        groupSize += viewLength;
    }
}


#pragma mark - INFRuler getters/setters

- (void)setOrientation:(INFOrientation)orientation {
    self.ruler.orientation = orientation;
}

- (INFOrientation)orientation {
    return self.ruler.orientation;
}

- (void) setScrollViewSize:(CGSize)scrollViewSize {
    self.ruler.scrollViewSize = scrollViewSize;
}

- (CGSize) scrollViewSize {
    return self.ruler.scrollViewSize;
}

- (void)setSizesOfArrangedViews:(NSArray<NSValue *> *)sizesOfArrangedViews {
    self.ruler.sizesOfArrangedViews = sizesOfArrangedViews;
}

- (NSArray<NSValue *> *)sizesOfArrangedViews {
    return self.ruler.sizesOfArrangedViews;
}
@end
