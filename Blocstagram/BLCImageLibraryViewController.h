//
//  BLCImageLibraryViewController.h
//  
//
//  Created by Larry Lynn on 10/20/15.
//
//

#import <UIKit/UIKit.h>

@class BLCImageLibraryViewController;

@protocol BLCImageLibraryViewControllerDelegate <NSObject>

- (void) imageLibraryViewController:(BLCImageLibraryViewController *)imageLibraryViewController didCompleteWithImage:(UIImage *)image;

@end


@interface BLCImageLibraryViewController : UICollectionViewController

@property (nonatomic, weak) NSObject <BLCImageLibraryViewControllerDelegate> *delegate;


@end
