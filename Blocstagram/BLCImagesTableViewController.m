//
//  BLCImagesTableViewController.m
//  Blocstagram
//
//  Created by Larry Lynn on 3/4/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BLCImagesTableViewController.h"
#import "BLCDataSource.h"
#import "BLCMedia.h"
#import "BLCUser.h"
#import "BLCComment.h"
#import "BLCMediaTableViewCell.h"



@interface BLCImagesTableViewController ()

@end

@implementation BLCImagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    for (int i = 1; i <= 10; i++) {
//        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
//        UIImage *image = [UIImage imageNamed:imageName];
//        if (image) {
//            [self.images addObject:image];
//        }
//    }
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"imageCell"];
    
    [[BLCDataSource sharedInstance] addObserver:self forKeyPath:@"mediaItems" options:0 context:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlDidFire:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerClass:[BLCMediaTableViewCell class] forCellReuseIdentifier:@"mediaCell"];
    
    
}

- (void) refreshControlDidFire:(UIRefreshControl *) sender {
    [[BLCDataSource sharedInstance] requestNewItemsWithCompletionHandler:^(NSError *error) {
        [sender endRefreshing];
    }];
    
}

- (void) infiniteScrollIfNecessary {
    NSIndexPath *bottomIndexPath = [[self.tableView indexPathsForVisibleRows] lastObject];
    
    if (bottomIndexPath && bottomIndexPath.row == [BLCDataSource sharedInstance].mediaItems.count - 1) {
        
        [[BLCDataSource sharedInstance] requestOldItemsWithCompletionHandler:nil];
    
    }
    NSLog(@"cough");
}

#pragma mark  - UIScrollViewDelegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self infiniteScrollIfNecessary];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self infiniteScrollIfNecessary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc  {
    [[BLCDataSource sharedInstance] removeObserver:self forKeyPath:@"mediaItems"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return self.images.count;
    return [self items].count;
    
}

- (id)initWithStyle:(UITableViewStyle)style  {
    self = [super initWithStyle:style];
    if (self) {
        // custom initialization
        //        self.images = [NSMutableArray array];
    }
    return self;
    
}


- (NSMutableArray *) items {
    return [BLCDataSource sharedInstance].mediaItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    //    static NSInteger imageViewTag = 1234;
    //    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:imageViewTag];
    //
    //    if ( !imageView) {
    //        //This is a new cell, it doesn't have an image yet
    //        imageView = [[UIImageView alloc] init];
    //        imageView.contentMode = UIViewContentModeScaleToFill;
    //
    //        imageView.frame = cell.contentView.bounds;
    //        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //
    //        imageView.tag = imageViewTag;
    //        [cell.contentView addSubview:imageView];
    //    }
    //
    //    UIImage *image = self.images[indexPath.row];
    //    imageView.image = image;
    //
    //    BLCMedia *item = [self items] [indexPath.row];
    //    imageView.image = item.image;
    BLCMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
    cell.mediaItem = [BLCDataSource sharedInstance].mediaItems[indexPath.row];
    
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UIImage *image = self.images[indexPath.row];
    BLCMedia *item = [self items] [indexPath.row];
    //UIImage *image = item.image;
    
    //    return (CGRectGetWidth(self.view.frame) / image.size.width) * image.size.height;
    // return 300 + (image.size.height / image.size.width * CGRectGetWidth(self.view.frame));
    return [BLCMediaTableViewCell heightForMediaItem:item width:CGRectGetWidth(self.view.frame)];
    
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[self items] removeObjectAtIndex:indexPath.row];
        //[[self item] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */






- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context  {
    if (object == [BLCDataSource sharedInstance] && [keyPath isEqualToString:@"mediaItems"]) {
        // We know mediaItems changed.  Let's see what kind of change it is.
        int kindOfChange = [change[NSKeyValueChangeKindKey] intValue];
        
        if (kindOfChange == NSKeyValueChangeSetting) {
            //someone set a brand new images array
            [self.tableView reloadData];
        }else if (kindOfChange == NSKeyValueChangeInsertion  ||
                  kindOfChange == NSKeyValueChangeRemoval ||
                  kindOfChange == NSKeyValueChangeReplacement)  {
            //we have an incremental change:  inserted, deleted, or replaced images
            
            //Get a list of the index (or indices) that changed
            NSIndexSet *indexSetOfChanges = change[NSKeyValueChangeIndexesKey];
            
            //Convert this ISIndexSet to an NSArray of NSIndexPaths (which is what the table view animation methods require
            NSMutableArray *indexPathsThatChanged = [NSMutableArray array];
            [indexSetOfChanges enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [indexPathsThatChanged addObject:newIndexPath];
            }];
            
            // Call 'beginUpdates' to tell the table view we're about to make changes
            [self.tableView beginUpdates];
            
            // Tell the table view what the changes are
            if (kindOfChange == NSKeyValueChangeInsertion) {
                [self.tableView insertRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (kindOfChange == NSKeyValueChangeRemoval) {
                [self.tableView deleteRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            } else if (kindOfChange == NSKeyValueChangeReplacement) {
                [self.tableView reloadRowsAtIndexPaths:indexPathsThatChanged withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            // Tell the table view that we're done telling it about changes, and to completer the animation
            [self.tableView endUpdates];
            
        
       }
    }
}


@end