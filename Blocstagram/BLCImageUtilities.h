//
//  BLCImageUtilities.h
//  
//
//  Created by Larry Lynn on 10/5/15.
//
//

#import <UIKit/UIKit.h>

//@interface BLCImageUtilities : UIImage

@interface UIImage (BLCImageUtilities)


- (UIImage *) imageWithFixedOrientation;
- (UIImage *) imageResizedToMatchAspectRatioOfSize:(CGSize)size;
- (UIImage *) imageCroppedToRect:(CGRect)cropRect;
- (UIImage *) imageByScalingToSize:(CGSize)size andCroppingWithRect:(CGRect)rect;


@end
