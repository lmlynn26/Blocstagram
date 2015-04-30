//
//  BLCMedia.h
//  Blocstagram
//
//  Created by Larry Lynn on 4/7/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@class BLCUser;

@interface BLCMedia : NSObject

@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) BLCUser *user;
@property (nonatomic, strong) NSURL *mediaURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSArray *comments;

- (instancetype) initWithDictionary:(NSDictionary *)mediaDictionary;


@end
