//
//  CoverFlowLayout.m
//  Cover Layout
//
//  Created by Adam Goldberg on 2015-10-15.
//  Copyright © 2015 Adam Goldberg. All rights reserved.
//

#import "CoverFlowLayout.h"

@import QuartzCore;

@implementation CoverFlowLayout


-(void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(250, 250);
    
    
}

#define  ZOOM_FACTOR .25

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGRect visibleRegion;
    visibleRegion.origin = self.collectionView.contentOffset;
    visibleRegion.size   = self.collectionView.bounds.size;
 
    
    float collectionViewHalfFrame = self.collectionView.frame.size.width/2.0;
    
    NSArray *newAttributes = [super layoutAttributesForElementsInRect:rect];
    
    // Modify the layout attributes as needed here
    for (UICollectionViewLayoutAttributes *anAttribute in newAttributes) {
        if (CGRectIntersectsRect(anAttribute.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRegion) - anAttribute.center.x;
            CGFloat normalDistance = distance / collectionViewHalfFrame;
            if(ABS(distance) < collectionViewHalfFrame) {
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalDistance));
                CATransform3D rotationTransform = CATransform3DIdentity;
                rotationTransform = CATransform3DMakeRotation(normalDistance * M_2_PI * 0.8, 0.0f, 1.0f, 0.0f);
                CATransform3D zoomTransform = CATransform3DMakeScale(zoom, zoom, 1.0);
                anAttribute.transform3D = CATransform3DConcat(zoomTransform, rotationTransform);
                anAttribute.zIndex = ABS(normalDistance) * 10.0f;
                CGFloat alpha = (1 - ABS(normalDistance)) + 0.1;
                if (alpha > 1.0f) alpha = 1.0f;
                anAttribute.alpha = alpha;
            }
            else {
                anAttribute.alpha = 0.0f;
            }
            CGFloat rotateValue = (1 - ABS(normalDistance)) + 0.1;
            if (rotateValue > 1.0f) {
                rotateValue = 0.0f;
            } else {
                rotateValue = 45;
            }
            anAttribute.transform = CGAffineTransformMakeRotation(rotateValue * (M_PI / 180));
        }
        
        
    }
    
    
    return newAttributes;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}









@end
