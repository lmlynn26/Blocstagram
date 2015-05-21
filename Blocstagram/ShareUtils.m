//
//  ShareUtils.m
//  Blocstagram
//
//  Created by Larry Lynn on 5/21/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "ShareUtils.h"
#import "BLCMedia.h"

@implementation ShareUtils

+ (UIActivityViewController *)shareItem: (BLCMedia *)mediaItem {
    
    NSMutableArray *itemsToShare = [NSMutableArray array];
    
    if (mediaItem.caption.length > 0) {
        [itemsToShare addObject:mediaItem.caption];
    }
    
    if (mediaItem.image) {
        [itemsToShare addObject:mediaItem.image];
    }
    
    if (itemsToShare.count > 0) {
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        return activityVC;
    }
    return nil;
    
}


@end
