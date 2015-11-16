//
//  BLCDataSource.m
//  Blocstagram
//
//  Created by Larry Lynn on 4/7/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BLCDataSource.h"
#import "BLCUser.h"
#import "BLCMedia.h"
#import "BLCComment.h"
#import "BLCLoginViewController.h"
#import <UICKeyChainStore.h>
#import <AFNetworking/AFNetworking.h>



//@interface BLCDataSource ()

@interface BLCDataSource () {
    NSMutableArray *_mediaItems;
}

//@property (nonatomic, strong) NSArray *mediaItems;

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) BOOL isLoadingOlderItems;
@property (nonatomic, assign) BOOL thereAreNoMoreOlderMessages;

@property (nonatomic, strong) AFHTTPRequestOperationManager *instagramOperationManager;


@end



@implementation BLCDataSource

NSString *const BLCImageFinishedNotification = @"BLCImageFinishedNotification";


+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
//        [self addRandomData];
        
        NSURL *baseURL = [NSURL URLWithString:@"https://api.instagram.com/v1/"];
        self.instagramOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        
        AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
        
        AFImageResponseSerializer *imageSerializer = [AFImageResponseSerializer serializer];
        imageSerializer.imageScale = 1.0;
        
        AFCompoundResponseSerializer *serializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[jsonSerializer, imageSerializer]];
        self.instagramOperationManager.responseSerializer = serializer;
        
        self.accessToken = [UICKeyChainStore stringForKey:@"access token"];

        if (!self.accessToken) {
//        [self registerForAccessTokenNotification];
            [self registerForAccessTokenNotification];
        } else {
//            [self populateDataWithParameters: nil completionHandler:nil];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(mediaItems))];
                NSArray *storedMediaItems = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (storedMediaItems.count > 0) {
                        NSMutableArray *mutableMediaItems = [storedMediaItems mutableCopy];
                        
                        [self willChangeValueForKey:@"mediaItems"];
                        self.mediaItems = mutableMediaItems;
                        for (BLCMedia *mediaItem in mutableMediaItems) {
                                                 [self downloadImageForMediaItem:mediaItem];
                        }
                        [self didChangeValueForKey:@"mediaItems"];
                    } else {
                        [self populateDataWithParameters:nil completionHandler:nil];
                    }
                });
            });
            
        }
    }
    
    return self;
}



- (void) registerForAccessTokenNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:BLCLoginViewControllerDidGetAccessTokenNotification object:nil queue:nil usingBlock:^(NSNotification *note)  {
        self.accessToken = note.object;
        [UICKeyChainStore setString:self.accessToken forKey:@"access token"];
        
        // Got a token, populate the initial data
//        [self populateDataWithParameters:nil];
        [self populateDataWithParameters:nil completionHandler:nil];
        
    }];
}

+ (NSString *) instagramClientID {
    return @"1fa8d99fe69d4f6dbef21a41b5260f3e";
    
}

- (NSString *) pathForFilename:(NSString *) filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:filename];
    return dataPath;
}


- (void) requestNewItemsWithCompletionHandler:(BLCNewItemCompletionBlock) completionHandler {
    
    self.thereAreNoMoreOlderMessages = NO;
    
    if (self.isRefreshing == NO) {
        self.isRefreshing = YES;
//        BLCMedia *media = [[BLCMedia alloc] init];
//        media.user = [self randomUser];
//        media.image = [UIImage imageNamed:@"10.jpg"];
//        media.caption = [self randomSentenceWithMaximumNumberOfWords:7];
//        
//        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
//        [mutableArrayWithKVO insertObject:media atIndex:0];
        
        //  Need to add images here
        
//        self.isRefreshing = NO;
        NSString *minID = [[self.mediaItems firstObject] idNumber];
        NSDictionary *parameters = minID ? @{@"min_id": minID} : @{};
        

        
        [self populateDataWithParameters:parameters completionHandler:^(NSError *error) {
            self.isRefreshing = NO;
            
            if (completionHandler) {
                completionHandler(error);
            }
        }];
        
        
//        if (completionHandler) {
//            completionHandler(nil);
//        }
        
    }
}

- (void) requestOldItemsWithCompletionHandler:(BLCNewItemCompletionBlock)completionHandler {
//    if (self.isLoadingOlderItems == NO) {
     if (self.isLoadingOlderItems == NO && self.thereAreNoMoreOlderMessages == NO) {
        self.isLoadingOlderItems = YES;
//        BLCMedia *media = [[BLCMedia alloc] init];
//        media.user = [self randomUser];
//        media.image = [UIImage imageNamed:@"1.jpg"];
//        media.caption = [self randomSentenceWithMaximumNumberOfWords:7];
//        
//        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
//        [mutableArrayWithKVO addObject:media];
        
        // Need to add images here
         
         NSString *maxID = [[self.mediaItems lastObject] idNumber];
         NSDictionary *parameters = @{@"max_id": maxID};
        
//        self.isLoadingOlderItems = NO;
//        
//        if (completionHandler) {
//            completionHandler(nil);
//        }
         
         [self populateDataWithParameters:parameters completionHandler:^(NSError *error) {
             self.isLoadingOlderItems = NO;
             
             if (completionHandler) {
                 completionHandler(error);
             }
         }];
    }
}

//  - (void) populateDataWithParameters:(NSDictionary *)parameters {
 - (void) populateDataWithParameters:(NSDictionary *)parameters completionHandler:(BLCNewItemCompletionBlock)completionHandler {
     
    if (self.accessToken) {
        // only try to get the data if there's an access token
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            //do the network request in the background, so the UI doesn't lock up
//            
//            NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://api.instagram.com/v1/users/self/feed?access_token=%@", self.accessToken];
//            
//            for (NSString *parameterName in parameters) {
//                // for example, if dictionary contains {count: 50}, append '&count=50' to the URL
//                [urlString appendFormat:@"&%@=%@", parameterName, parameters[parameterName]];
//            }
//            
//            NSURL *url = [NSURL URLWithString:urlString];
//            
//            if (url) {
//                NSURLRequest *request = [NSURLRequest requestWithURL:url];
//                
//                NSURLResponse *response;
//                NSError *webError;
//                NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&webError];
//                
//                NSError *jsonError;
//                NSDictionary *feedDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
//
//                if (feedDictionary) {
//                
//                if (responseData) {
//                    NSError *jsonError;
//                    NSDictionary *feedDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
//                    
//                    if (feedDictionary) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            // done networking, go back on the main thread
//                            [self parseDataFromFeedDictionary:feedDictionary fromRequestWithParameters:parameters];
//                            if (completionHandler) {
//                                completionHandler(nil);
//                            }
//                        });
//                    } else if (completionHandler) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            completionHandler(jsonError);
//                        });
//                    }
//                } else if (completionHandler) {
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        // done networking, go back on the main thread
//                        [self parseDataFromFeedDictionary:feedDictionary fromRequestWithParameters:parameters];
//                        
//                        completionHandler(webError);
//                        
//                    });
//                }
//            }
//        });
        
        NSMutableDictionary *mutableParameters = [@{@"access_token": self.accessToken} mutableCopy];
        
        [mutableParameters addEntriesFromDictionary:parameters];
        
        [self.instagramOperationManager GET:@"users/self/feed"
                                 parameters:mutableParameters
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                            [self parseDataFromFeedDictionary:responseObject fromRequestWithParameters:parameters];
                                            
                                            if (completionHandler) {
                                                completionHandler(nil);
                                            }
                                        }
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        if (completionHandler) {
                                            completionHandler(error);
                                        }
                                    }];
    }
}

- (void) parseDataFromFeedDictionary:(NSDictionary *) feedDictionary fromRequestWithParameters:(NSDictionary *)parameters {
//NSLog(@"%@", feedDictionary);
    
    NSArray *mediaArray = feedDictionary[@"data"];
    
    NSMutableArray *tmpMediaItems = [NSMutableArray array];
    
    for (NSDictionary *mediaDictionary in mediaArray) {
        BLCMedia *mediaItem = [[BLCMedia alloc] initWithDictionary:mediaDictionary];
        
        if (mediaItem) {
            [tmpMediaItems addObject:mediaItem];
                     [self downloadImageForMediaItem:mediaItem];
        }
    }
    
//    [self willChangeValueForKey:@"mediaItems"];
//    self.mediaItems = tmpMediaItems;
//    [self didChangeValueForKey:@"mediaItems"];
  
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    
    if (parameters[@"min_id"]) {
        // This was a pull-to-refresh request
        
        NSRange rangeOfIndexes = NSMakeRange(0, tmpMediaItems.count);
        NSIndexSet *indexSetOfNewObjects = [NSIndexSet indexSetWithIndexesInRange:rangeOfIndexes];
        
        [mutableArrayWithKVO insertObjects:tmpMediaItems atIndexes:indexSetOfNewObjects];
        
    } else if (parameters[@"max_id"]) {
        // This was an infinite scroll request
        
        if (tmpMediaItems.count == 0) {
            // disable infinite scroll, since there are no more older messages
            self.thereAreNoMoreOlderMessages = YES;
        }
        
        [mutableArrayWithKVO addObjectsFromArray:tmpMediaItems];
        
    } else {
        [self willChangeValueForKey:@"mediaItems"];
        self.mediaItems = tmpMediaItems;
        [self didChangeValueForKey:@"mediaItems"];
    }
    
    if (tmpMediaItems.count > 0) {
        // Write the changes to disk
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSUInteger numberOfItemsToSave = MIN(self.mediaItems.count, 50);
            NSArray *mediaItemsToSave = [self.mediaItems subarrayWithRange:NSMakeRange(0, numberOfItemsToSave)];
            
            NSString *fullPath = [self pathForFilename:NSStringFromSelector(@selector(mediaItems))];
            NSData *mediaItemData = [NSKeyedArchiver archivedDataWithRootObject:mediaItemsToSave];
            
            NSError *dataError;
            BOOL wroteSuccessfully = [mediaItemData writeToFile:fullPath options:NSDataWritingAtomic | NSDataWritingFileProtectionCompleteUnlessOpen error:&dataError];
            
            if (!wroteSuccessfully) {
                NSLog(@"Couldn't write file: %@", dataError);
            }
        });
        
    }
    
    
}

#pragma mark - Liking Media Items

- (void) toggleLikeOnMediaItem:(BLCMedia *)mediaItem withCompletionHandler:(void (^)(void))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"media/%@/likes", mediaItem.idNumber];
    NSDictionary *parameters = @{@"access_token": self.accessToken};
    
    if (mediaItem.likeState == LikeStateNotLiked) {
        
        mediaItem.likeState = LikeStateLiking;
        
        [self.instagramOperationManager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            mediaItem.likeState = LikeStateLiked;
            
            if (completionHandler) {
                completionHandler();
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            mediaItem.likeState = LikeStateNotLiked;
            
            if (completionHandler) {
                completionHandler();
            }
        }];
        
    } else if (mediaItem.likeState == LikeStateLiked) {
        
        mediaItem.likeState = LikeStateUnliking;
        
        [self.instagramOperationManager DELETE:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            mediaItem.likeState = LikeStateNotLiked;
            
            if (completionHandler) {
                completionHandler();
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            mediaItem.likeState = LikeStateLiked;
            
            if (completionHandler) {
                completionHandler();
            }
        }];
    }
}

- (void) downloadImageForMediaItem:(BLCMedia *)mediaItem {
    if (mediaItem.mediaURL && !mediaItem.image) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSURLRequest *request = [NSURLRequest requestWithURL:mediaItem.mediaURL];
//            
//            NSURLResponse *response;
//            NSError *error;
//            NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//            
//            if (imageData) {
//                UIImage *image = [UIImage imageWithData:imageData];
//                
//                if (image) {
//                    mediaItem.image = image;
//                    
//                  dispatch_async(dispatch_get_main_queue(), ^{
//                        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
//                        NSUInteger index = [mutableArrayWithKVO indexOfObject:mediaItem];
//                        [mutableArrayWithKVO replaceObjectAtIndex:index withObject:mediaItem];
//                    });
//                }
//            } else {
//                NSLog(@"Error downloading image: %@", error);
//            }
//        });
        
        [self.instagramOperationManager GET:mediaItem.mediaURL.absoluteString
                                 parameters:nil
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        if ([responseObject isKindOfClass:[UIImage class]]) {
                                            mediaItem.image = responseObject;
                                            NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
                                            NSUInteger index = [mutableArrayWithKVO indexOfObject:mediaItem];
                                            if (index < mutableArrayWithKVO.count) {
                                                
                                                [mutableArrayWithKVO replaceObjectAtIndex:index withObject:mediaItem];
                                            }
                                        }
                                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        NSLog(@"Error downloading image: %@", error);
                                    }];
    }
}

//- (void) addRandomData {
//    NSMutableArray *randomMediaItems = [NSMutableArray array];
//    
//    for (int i = 1; i <= 10; i++) {
//        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
//        UIImage *image = [UIImage imageNamed:imageName];
//        
//        if (image) {
//            BLCMedia *media = [[BLCMedia alloc] init];
//            media.user = [self randomUser];
//            media.image = image;
//            
//            NSUInteger commentCount = arc4random_uniform(10);
//            NSMutableArray *randomComments = [NSMutableArray array];
//            
//            for (int i = 0; i <= commentCount; i++) {
//                BLCComment *randomComment = [self randomComment];
//                [randomComments addObject:randomComment];
//                
//            }
//            media.comments = randomComments;
//            
//            [randomMediaItems addObject:media];
//    }
//        
//    }
//        self.mediaItems = randomMediaItems;
//}
//
//- (BLCUser *) randomUser {
//    BLCUser *user = [[BLCUser alloc] init];
//    
//    user.userName = [self randomStringOfLength:arc4random_uniform(10)];
//    
//    NSString *firstName = [self randomStringOfLength:arc4random_uniform(7)];
//    NSString *lastName = [self randomStringOfLength:arc4random_uniform(12)];
//    user.fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
//    
//    return user;
//    
//}
//
//- (BLCComment *) randomComment {
//    BLCComment *comment = [[BLCComment alloc] init];
//    
//    comment.from = [self randomUser];
//    
//    NSUInteger wordCount = arc4random_uniform(20);
//    
//    NSMutableString *randomSentence = [[NSMutableString alloc] init];
//    
//    for (int i = 1; i <= wordCount; i++)  {
//        NSString *randomWord = [self randomStringOfLength:arc4random_uniform(12)];
//        [randomSentence appendFormat:@"%@ ", randomWord];
//        
//    }
//    
//    comment.text = randomSentence;
//    
//    return comment;
//}

//- (NSString *) randomSentenceWithMaximumNumberOfWords:(NSUInteger) numberOfWords {
//    NSUInteger wordCount = arc4random_uniform(20);
//
//    NSMutableString *randomSentence = [[NSMutableString alloc] init];
//
//    for (int i  = 0; i <= wordCount; i++) {
//        NSString *randomWord = [self randomStringOfLength:arc4random_uniform(12)];
//        if (randomWord.length > 0) {
//            [randomSentence appendFormat:@"%@ ", randomWord];
//        }
//    }
//
//    return randomSentence;
//}

//
//- (NSString *) randomStringOfLength:(NSUInteger) len {
//    NSString *alphabet = @"abcdefghijklmnopqrstuvwxyz";
//    
//    NSMutableString *s = [NSMutableString string];
//    for (NSUInteger i = 0U; i < len; i++) {
//        u_int32_t r = arc4random_uniform((u_int32_t)[alphabet length]);
//        unichar c = [alphabet characterAtIndex:r];
//        [s appendFormat:@"%C", c];
//    }
//    
//    return [NSString stringWithString:s];
//}
#pragma mark - Comments

- (void) commentOnMediaItem:(BLCMedia *)mediaItem withCommentText:(NSString *)commentText {
    if (!commentText || commentText.length == 0) {
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"media/%@/comments", mediaItem.idNumber];
    NSDictionary *parameters = @{@"access_token": self.accessToken, @"text": commentText};
    
    [self.instagramOperationManager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        mediaItem.temporaryComment = nil;
        
        NSString *refreshMediaUrlString = [NSString stringWithFormat:@"media/%@", mediaItem.idNumber];
        NSDictionary *parameters = @{@"access_token": self.accessToken};
        [self.instagramOperationManager GET:refreshMediaUrlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            BLCMedia *newMediaItem = [[BLCMedia alloc] initWithDictionary:responseObject];
            NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
            NSUInteger index = [mutableArrayWithKVO indexOfObject:mediaItem];
            [mutableArrayWithKVO replaceObjectAtIndex:index withObject:newMediaItem];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self reloadMediaItem:mediaItem];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"Response: %@", operation.responseString);
        [self reloadMediaItem:mediaItem];
    }];
}

- (void) reloadMediaItem:(BLCMedia *)mediaItem {
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    NSUInteger index = [mutableArrayWithKVO indexOfObject:mediaItem];
    [mutableArrayWithKVO replaceObjectAtIndex:index withObject:mediaItem];
}


#pragma mark - Key/Value Observing

- (NSUInteger) countOfMediaItems {
    return self.mediaItems.count;
    
}
- (id) objectInMediaItemsAtIndex:(NSUInteger) index {
    return [self.mediaItems objectAtIndex:index];
}

- (NSArray *) mediaItemsAtIndexes:(NSIndexSet *)indexes {
    return [self.mediaItems objectsAtIndexes:indexes];
}

- (void) insertObject:(BLCMedia *)object inMediaItemsAtIndex:(NSUInteger)index {
    [_mediaItems insertObject:object atIndex:index];
}

- (void) removeObjectFromMediaItemsAtIndex:(NSUInteger)index {
    [_mediaItems removeObjectAtIndex:index];
    
}

- (void) replaceObjectInMediaItemsAtIndex:(NSUInteger)index withObject:(id)object {
    [_mediaItems replaceObjectAtIndex:index withObject:object];
}

- (void) deleteMediaItem:(BLCMedia *)item {
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    [mutableArrayWithKVO removeObject:item];
}


@end
