//
//  TGLViewController.m
//  TGLStackedViewExample
//
//  Created by Tim Gleue on 07.04.14.
//  Copyright (c) 2014 Tim Gleue ( http://gleue-interactive.com )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "TGLViewController.h"
#import "MyCustomCell.h"
#import "CommonAppManager.h"

@interface UIColor (randomColor)

+ (UIColor *)randomColor;

@end

@implementation UIColor (randomColor)

+ (UIColor *)randomColor {
    
    CGFloat comps[3];
    
    for (int i = 0; i < 3; i++) {
        
        NSUInteger r = arc4random_uniform(256);
        comps[i] = (CGFloat)r/255.f;
    }
    
    return [UIColor colorWithRed:comps[0] green:comps[1] blue:comps[2] alpha:1.0];
}

@end

@interface TGLViewController ()

@property (strong, readonly, nonatomic) NSMutableArray *cards;

@end

@implementation TGLViewController

@synthesize cards = _cards;

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.view.frame = [UIScreen mainScreen].bounds;

    self.collectionView.frame = self.view.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncComplete) name:@"SyncCompleted" object:nil];
    
    // Set to NO to prevent a small number
    // of cards from filling the entire
    // view height evenly and only show
    // their -topReveal amount
    //
    self.stackedLayout.fillHeight = YES;

    // Set to NO to prevent a small number
    // of cards from being scrollable and
    // bounce
    //
    self.stackedLayout.alwaysBounce = YES;
    
    // Set to NO to prevent unexposed
    // items at top and bottom from
    // being selectable
    //
    self.unexposedItemsAreSelectable = YES;
    
    [self.collectionView registerClass:[MyCustomCell class] forCellWithReuseIdentifier:@"CardCell"];

    
    UINib *cellNib = [UINib nibWithNibName:@"MyCustomCell" bundle:nil];
   
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CardCell"];
    

}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

#pragma mark - Accessors

- (NSMutableArray *)cards {

    if (_cards == nil) {
        
        _cards = [NSMutableArray array];
        
        // Adjust the number of cards here
        //
        for (NSInteger i = 1; i < 100; i++) {
            
            NSDictionary *card = @{ @"name" : [NSString stringWithFormat:@"Card #%d", (int)i], @"color" : [UIColor randomColor] };
            
            [_cards addObject:card];
        }
        
    }
    
    return _cards;
}

#pragma mark - Actions

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CollectionViewDataSource protocol

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[CommonAppManager sharedAppManager] questionsArray].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
    
    NSDictionary *card = [[CommonAppManager sharedAppManager] questionsArray][indexPath.item];
    [cell setQuestionDict:card];
    
    if ([[card objectForKey:IsFavorite] isEqualToString:@"YES"]) {
        
        [cell setIsFavorite:YES];
    }
    else{
        
        [cell setIsFavorite:NO];

    }
    
    if (![card[QuestionKey] isKindOfClass:[NSNull class]]) {
        [cell.nameLabel setTextColor:[UIColor randomColor]];
        cell.title = card[QuestionKey];
        cell.countLabel.textColor = [cell.nameLabel textColor];
        
    }
    if (![card[AnswerKey] isKindOfClass:[NSNull class]]) {
        
        cell.answerLabel.textColor = [cell.nameLabel textColor];
        cell.answerLabel.text = card[AnswerKey];

    }
    if (indexPath.row%2 == 0) {
        cell.color = [UIColor grayColor];

    }
    else{
        
        cell.color = [UIColor lightGrayColor];

    }
    
    cell.countLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    
    return cell;
}



#pragma mark - Overloaded methods

- (void)moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    // Update data source when moving cards around
    //
    NSDictionary *card = self.cards[fromIndexPath.item];
    
    [self.cards removeObjectAtIndex:fromIndexPath.item];
    [self.cards insertObject:card atIndex:toIndexPath.item];
}

-(void)syncComplete
{
    
    NSLog(@"%s",__func__);
    
    
    NSLog(@"Levels Array : %@",[[CommonAppManager sharedAppManager] levelsArray]);
    NSLog(@"Filters Array : %@",[[CommonAppManager sharedAppManager] filtersArray]);
    NSLog(@"Questions Array : %@",[[CommonAppManager sharedAppManager] questionsArray]);
    
    [self.collectionView reloadData];
    
}

-(void)filterOrLevelChanged
{
    [[CommonAppManager sharedAppManager] setSelectedFilter:@"CGContext"];
    [[CommonAppManager sharedAppManager] setSelectedLevel:@"Level 1"];
    [[CommonAppManager sharedAppManager] getNewListOfQuestions];
    
}



- (IBAction)syncButtontTapped:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ISSyncSuccess"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[CommonAppManager sharedAppManager] sync];
    
    
}


@end
