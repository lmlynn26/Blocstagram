//
//  BLCCropImageViewController.h
//  
//
//  Created by Larry Lynn on 10/20/15.
//
//

#import <UIKit/UIkit.h>
#import "BLCMediaFullScreenViewController.h"

@class BLCCropImageViewController;

@protocol BLCCropImageViewControllerDelegate <NSObject>

- (void) cropControllerFinishedWithImage:(UIImage *)croppedImage;

@end


@interface BLCCropImageViewController : BLCMediaFullScreenViewController

- (instancetype) initWithImage:(UIImage *)sourceImage;

@property (nonatomic, weak) NSObject <BLCCropImageViewControllerDelegate> *delegate;


@end
