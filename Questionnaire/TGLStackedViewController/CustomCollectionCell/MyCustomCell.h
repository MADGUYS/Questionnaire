//
//  MyCustomCell.h
//  CustomCollectionCell
//
//  Created by Barrett Breshears on 11/14/13.
//  Copyright (c) 2013 Barrett Breshears. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomCell : UICollectionViewCell

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) UIColor *color;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@end
