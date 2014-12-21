//
//  MyCustomCell.m
//  CustomCollectionCell
//
//  Created by Barrett Breshears on 11/14/13.
//  Copyright (c) 2013 Barrett Breshears. All rights reserved.
//

#import "MyCustomCell.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CommonAppManager.h"

@implementation MyCustomCell
@synthesize questionDict;

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
    
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y,[UIScreen mainScreen].bounds.size.width, self.contentView.frame.size.height);
    
    self.contentView.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Texture.png"]];
    
    

    self.isFavorite= NO;
 
    [self.contentView.layer setCornerRadius:20];
    [self.contentView.layer setMasksToBounds:YES];
    [self.contentView.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.contentView.layer setBorderWidth:2];
//
    [self.layer setBorderColor:[UIColor colorWithRed:213.0/255.0f green:210.0/255.0f blue:199.0/255.0f alpha:1.0f].CGColor];
    [self.layer setBorderWidth:1.0f];
    [self.layer setCornerRadius:20.0f];

   // [self performSelectorInBackground:@selector(appLyShadow) withObject:nil];
    
    self.layer.masksToBounds = NO;
   
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
    
    [self.layer setMasksToBounds:NO];
    [self.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.layer setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [self.layer setShadowRadius:8.0];
    [self.layer setShadowOpacity:1.0];
    //[self.layer setShouldRasterize:YES];

}

-(void)appLyShadow
{
    
    
    
}

- (UIImage *)generatePhotoStackWithImage:(UIImage *)image {
    CGSize newSize = CGSizeMake(image.size.width + 70, image.size.height + 70);
    CGRect rect = CGRectMake(25, 25, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, image.scale); {
        CGContextRef context = UIGraphicsGetCurrentContext();
        //Shadow
        CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 10, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f].CGColor);
        
        CGContextBeginTransparencyLayer (context, NULL);
        //Draw
        [image drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        CGContextStrokeRectWithWidth(context, rect, 40);
        CGContextEndTransparencyLayer(context);
    }
    UIImage *result =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

#pragma mark - Accessors

- (void)setTitle:(NSString *)title {
    
    _title = [title copy];
    self.nameLabel.text = self.title;
    
//    //Use any font you want or skip defining it
//    UIFont* font = self.nameLabel.font;
//    
//    //Use any color you want or skip defining it
//    UIColor* textColor = self.nameLabel.textColor;
//    
//    NSDictionary *attrs = @{ NSForegroundColorAttributeName : textColor,
//                             NSFontAttributeName : font,
//                             NSTextEffectAttributeName : NSTextEffectLetterpressStyle};
//    
//    NSAttributedString* attrString = [[NSAttributedString alloc]
//                                      initWithString:title
//                                      attributes:attrs];
//    
//    self.nameLabel.attributedText = attrString;
}

- (void)setColor:(UIColor *)color {
    
    _color = [color copy];
    //self.imageView.tintColor = self.color;
}

-(void)setIsFavorite:(BOOL)isFavorite
{
    _isFavorite = isFavorite;
    
    if (isFavorite) {
        
//        [self.starButton setImage:[UIImage imageNamed:@"star-on.png"] forState:UIControlStateNormal];
        [self.starButton setImage:[[UIImage imageNamed:@"Favourite7.png"] imageWithOverlayColor:[UIColor redColor]] forState:UIControlStateNormal];
    }
    else{
        
//        [self.starButton setImage:[UIImage imageNamed:@"star-off.png"] forState:UIControlStateNormal];
        [self.starButton setImage:[UIImage imageNamed:@"Favourite7.png"] forState:UIControlStateNormal];


    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)starButtonTapped:(id)sender {
    
    NSLog(@"%@ >>>",self.questionDict);
    if ([[self.questionDict objectForKey:IsFavorite] isEqualToString:@"YES"]) {
        
        [self.questionDict setObject:@"NO" forKey:IsFavorite];
        [[CommonAppManager sharedAppManager] deleteFromFav:self.questionDict];
    }
    else{
        
        [self.questionDict setObject:@"YES" forKey:IsFavorite];
        [[CommonAppManager sharedAppManager] saveToFavList:self.questionDict];

    }
    
    [[CommonAppManager sharedAppManager] updateFavValueInMainTable:self.questionDict];
    
    self.isFavorite = !self.isFavorite;
    
    
}
@end
