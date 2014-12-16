//
//  SOInsetLabel.h
//
//  Created by Joseph Hankin on 11/2/12.
//  From code posted by Rob Mayoff.
//  http://stackoverflow.com/questions/8467141/ios-how-to-achieve-emboss-effect-for-the-text-on-uilabel

//  Copyright (c) 2012 Joseph Hankin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOInsetLabel : UILabel

@property (nonatomic, strong) UIColor *upwardShadowColor;
@property (nonatomic, readwrite) CGSize upwardShadowOffset;

@end
