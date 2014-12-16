//
//  MyCustomCell.m
//  CustomCollectionCell
//
//  Created by Barrett Breshears on 11/14/13.
//  Copyright (c) 2013 Barrett Breshears. All rights reserved.
//

#import "MyCustomCell.h"

@implementation MyCustomCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIImage *image = [[UIImage imageNamed:@"Background"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    
    self.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.imageView.tintColor = self.color;
    
    self.nameLabel.text = self.title;
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title {
    
    _title = [title copy];
    self.nameLabel.text = self.title;
}

- (void)setColor:(UIColor *)color {
    
    _color = [color copy];
    self.imageView.tintColor = self.color;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
