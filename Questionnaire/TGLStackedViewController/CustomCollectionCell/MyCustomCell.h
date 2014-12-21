//
//  MyCustomCell.h
//  CustomCollectionCell
//
//  Created by Barrett Breshears on 11/14/13.
//  Copyright (c) 2013 Barrett Breshears. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+renderImageWithColour.h"

@interface MyCustomCell : UICollectionViewCell{
    
    
    
    
}

@property (nonatomic)BOOL isFavorite;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) UIColor *color;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *answerTextField;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (assign, nonatomic) NSMutableDictionary *questionDict;

- (IBAction)starButtonTapped:(id)sender;
@end
