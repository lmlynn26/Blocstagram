//
//  BLCMediaTableViewCell.m
//  Blocstagram
//
//  Created by Larry Lynn on 4/13/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BLCMediaTableViewCell.h"
#import "BLCMedia.h"
#import "BLCComment.h"
#import "BLCUser.h"
#import "BLCDataSource.h"


//@interface BLCMediaTableViewCell ()

@interface BLCMediaTableViewCell () <UIGestureRecognizerDelegate>


@property (nonatomic, strong) UIImageView *mediaImageView;
@property (nonatomic, strong) UILabel *userNameAndCaptionLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) NSLayoutConstraint *imageHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *usernameAndCaptionLabelHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *commentLabelHeightConstraint;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (nonatomic, strong) UITapGestureRecognizer *tap2GestureRecognizer;


@end

static UIFont *lightFont;
static UIFont *boldFont;
static UIColor *usernameLabelGray;
static UIColor *commentLabelGray;
static UIColor *linkColor;
static NSParagraphStyle *paragraphStyle;

@implementation BLCMediaTableViewCell

+ (void)load {
    lightFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
    boldFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    usernameLabelGray = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1];  /*#eeeee*/
    commentLabelGray = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1];   /*#e5e5e5*/
    linkColor = [UIColor colorWithRed:0.345 green:0.314 blue:0.427 alpha:1];  /*#58506d*/
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.headIndent = 20.0;
    mutableParagraphStyle.firstLineHeadIndent = 20.0;
    mutableParagraphStyle.tailIndent = -20.0;
    mutableParagraphStyle.paragraphSpacingBefore = 5;
    
    paragraphStyle = mutableParagraphStyle;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.mediaImageView = [[UIImageView alloc] init];
        self.mediaImageView.userInteractionEnabled = YES;
        
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        self.tapGestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.tapGestureRecognizer];
        
        self.tap2GestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2Fired:)];
        self.tap2GestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.tap2GestureRecognizer];
        
        self.tap2GestureRecognizer.numberOfTouchesRequired = 2;
        
        
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        self.longPressGestureRecognizer.delegate = self;
        [self.mediaImageView addGestureRecognizer:self.longPressGestureRecognizer];
        
        
        self.userNameAndCaptionLabel = [[UILabel alloc] init];
        self.userNameAndCaptionLabel.numberOfLines = 0;
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.numberOfLines = 0;
        
        for (UIView *view in @[self.mediaImageView, self.userNameAndCaptionLabel, self.commentLabel]) {
            [self.contentView addSubview:view];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_mediaImageView, _userNameAndCaptionLabel, _commentLabel);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mediaImageView]|" options:kNilOptions metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_userNameAndCaptionLabel]|" options:kNilOptions metrics:nil views:viewDictionary]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_commentLabel]|" options:kNilOptions metrics:nil views:viewDictionary]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mediaImageView][_userNameAndCaptionLabel][_commentLabel]" options:kNilOptions metrics:nil views:viewDictionary]];
        
        self.imageHeightConstraint = [NSLayoutConstraint constraintWithItem:_mediaImageView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1
                                                                   constant:400];
        self.usernameAndCaptionLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_userNameAndCaptionLabel
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:nil
                                                                                    attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                                                                     constant:100];
        self.commentLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:_commentLabel
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1
                                                                          constant:100];
        
        [self.contentView addConstraints:@[self.imageHeightConstraint, self.usernameAndCaptionLabelHeightConstraint, self.commentLabelHeightConstraint]];
        
        
        
    }
    
        return self;
    
 }

#pragma mark - Image View

- (void) tapFired:(UITapGestureRecognizer *)sender {
    [self.delegate cell:self didTapImageView:self.mediaImageView];
    
}

- (void) tap2Fired:(UITapGestureRecognizer *)sender {
    [[BLCDataSource sharedInstance] downloadImageForMediaItem:self.mediaItem];
    
}


    - (void) longPressFired:(UILongPressGestureRecognizer *)sender {
        if (sender.state == UIGestureRecognizerStateBegan) {
            [self.delegate cell:self didLongPressImageView:self.mediaImageView];
        }
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.isEditing == NO;
}

    
    - (NSAttributedString *) usernameAndCaptionString {
        CGFloat usernameFontSize = 15;
        
        //Make a string that says "username caption text"
        NSString *baseString = [NSString stringWithFormat:@"%@ %@", self.mediaItem.user.userName, self.mediaItem.caption];
        
        //Make an attributed string, with the "username" bold
        NSMutableAttributedString *mutableUsernameAndCaptionString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : [lightFont fontWithSize:usernameFontSize], NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSRange usernameRange = [baseString rangeOfString:self.mediaItem.user.userName];
        [mutableUsernameAndCaptionString addAttribute:NSFontAttributeName value:[boldFont fontWithSize:usernameFontSize] range:usernameRange];
        [mutableUsernameAndCaptionString addAttribute:NSForegroundColorAttributeName value:linkColor range:usernameRange];
        
        return mutableUsernameAndCaptionString;
        
    }
    
    - (NSAttributedString *) commentString {
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
        
        for (BLCComment *comment in self.mediaItem.comments)  {
            //make a string that says "username comment text" followed by a link break
            NSString *baseString = [NSString stringWithFormat:@"%@ %@\n", comment.from.userName,comment.text];
            
            //Make an attributed string, with the "username" bold
            
            NSMutableAttributedString *oneCommentString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:@{NSFontAttributeName : lightFont, NSParagraphStyleAttributeName : paragraphStyle}];
            
            NSRange usernameRange = [baseString rangeOfString:comment.from.userName];
            [oneCommentString addAttribute:NSFontAttributeName value:boldFont range:usernameRange];
            [oneCommentString addAttribute:NSForegroundColorAttributeName value:linkColor range:usernameRange];
            
            [commentString appendAttributedString:oneCommentString];
        }
        
        return commentString;
        
         }
        
        
//        - (CGSize) sizeOfString:(NSAttributedString *)string {
//            CGSize maxSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds) -40, 0.0);
//            CGRect sizeRect = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//            sizeRect.size.height += 20;
//            sizeRect = CGRectIntegral(sizeRect);
//            return sizeRect.size;
//       
//    }

    
    - (void) layoutSubviews {
        [super layoutSubviews];
        
//        CGFloat imageHeight = self.mediaItem.image.size.height / self.mediaItem.image.size.width * CGRectGetWidth(self.contentView.bounds);
//        self.mediaImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), imageHeight);
//        
//        CGSize sizeOfUsernameAndCaptionLabel = [self sizeOfString:self.userNameAndCaptionLabel.attributedText];
//        self.userNameAndCaptionLabel.frame = CGRectMake(0, CGRectGetMaxY(self.mediaImageView.frame), CGRectGetWidth(self.contentView.bounds), sizeOfUsernameAndCaptionLabel.height);
//        
//        CGSize sizeOfCommentLabel = [self sizeOfString:self.commentLabel.attributedText];
//        self.commentLabel.frame = CGRectMake(0, CGRectGetMaxY(self.userNameAndCaptionLabel.frame), CGRectGetWidth(self.bounds), sizeOfCommentLabel.height);
        
        //Before Layout, calculate the intrinsic size of the labels (the size they want to be), and add 20 to the height
        CGSize maxSize = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
        CGSize usernameLabelSize = [self.userNameAndCaptionLabel sizeThatFits:maxSize];
        CGSize commentLabelSize = [self.commentLabel sizeThatFits:maxSize];
        
        self.usernameAndCaptionLabelHeightConstraint.constant = usernameLabelSize.height + 20;
        self.commentLabelHeightConstraint.constant = commentLabelSize.height + 20;
        
                if (_mediaItem.image) {
                    self.imageHeightConstraint.constant = self.mediaItem.image.size.height / self.mediaItem.image.size.width * CGRectGetWidth(self.contentView.bounds);
                } else {
                    self.imageHeightConstraint.constant = 400;
                }

        
        
        // Hide the line between cells
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGRectGetWidth(self.bounds));
        
    }
    
    - (void) setMediaItem:(BLCMedia *)mediaItem  {
        _mediaItem = mediaItem;
        self.mediaImageView.image = _mediaItem.image;
        self.userNameAndCaptionLabel.attributedText = [self usernameAndCaptionString];
        self.commentLabel.attributedText = [self commentString];
        
//        self.imageHeightConstraint.constant = self.mediaItem.image.size.height / self.mediaItem.image.size.width *CGRectGetWidth(self.contentView.bounds);
//        if (_mediaItem.image) {
//            self.imageHeightConstraint.constant = self.mediaItem.image.size.height / self.mediaItem.image.size.width * CGRectGetWidth(self.contentView.bounds);
//        } else {
//            self.imageHeightConstraint.constant = 0;
//        }
        
    }

 + (CGFloat) heightForMediaItem:(BLCMedia *)mediaItem width:(CGFloat)width {
    // Make a cell
    BLCMediaTableViewCell *layoutCell = [[BLCMediaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    
    // Set it to the given width, and the maximum possible height
//    layoutCell.frame = CGRectMake(0, 0, width, CGFLOAT_MAX);
    
    // Give it the media item
    layoutCell.mediaItem = mediaItem;
    
    // Make it adjust the image view and labels
//    [layoutCell layoutSubviews];
     
     layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame));
     
     // The height will be wherever the bottom of the comments label is
     [layoutCell setNeedsLayout];
     [layoutCell layoutIfNeeded];
    
    // The height will be wherever the bottom of the comments label is
    return CGRectGetMaxY(layoutCell.commentLabel.frame);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:NO animated:animated];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
      [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}



@end
