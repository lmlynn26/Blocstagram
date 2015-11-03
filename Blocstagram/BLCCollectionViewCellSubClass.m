//
//  BLCCollectionViewCellSubClass.m
//  
//
//  Created by Larry Lynn on 10/30/15.
//
//

#import "BLCCollectionViewCellSubClass.h"

@interface BLCCollectionViewCellSubClass ()

//@property (strong, nonatomic) UIImageView *filterImageView;
//@property (strong, nonatomic) UIImage *filterImage;
//@property (strong, nonatomic) UILabel *filterLabel;


@end

@implementation BLCCollectionViewCellSubClass

#pragma mark - UICollectionView delegate and data source


- (instancetype) initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self){
        
        static NSInteger imageViewTag = 1000;
        static NSInteger labelTag = 1001;
        
        self.filterImageView = (UIImageView *)[self.contentView viewWithTag:imageViewTag];
        self.filterLabel = (UILabel *)[self.contentView viewWithTag:labelTag];
        
        //        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.filterCollectionView.collectionViewLayout;
        CGFloat filterImageViewEdgeSize = 48;
        
        if (!self.filterImageView) {
            self.filterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, filterImageViewEdgeSize, filterImageViewEdgeSize)];
            self.filterImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.filterImageView.tag = imageViewTag;
            self.filterImageView.clipsToBounds = YES;
            
            [self.contentView addSubview:self.filterImageView];
        }
        
        if (!self.filterLabel) {
            self.filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, filterImageViewEdgeSize, filterImageViewEdgeSize, 20)];
            self.filterLabel.tag = labelTag;
            self.filterLabel.textAlignment = NSTextAlignmentCenter;
            self.filterLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:10];
            [self.contentView addSubview:self.filterLabel];
        }
        
        //        thumbnail.image = self.filterImages[indexPath.row];
        //        label.text = self.filterTitles[indexPath.row];
        
    }
    
    return self;
}

@end
