//
//  ShareUtils.h
//  Blocstagram
//
//  Created by Larry Lynn on 5/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BLCMedia;


@interface ShareUtils : NSObject

+ (UIActivityViewController *)shareItem: (BLCMedia *)mediaItem;


@end
