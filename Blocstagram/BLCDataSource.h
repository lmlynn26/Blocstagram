//
//  BLCDataSource.h
//  Blocstagram
//
//  Created by Larry Lynn on 4/7/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLCMedia;

@interface BLCDataSource : NSObject

+ (instancetype) sharedInstance;
@property (nonatomic, strong) NSMutableArray *mediaItems;

- (void) deleteMediaItem:(BLCMedia *)item;

@end
