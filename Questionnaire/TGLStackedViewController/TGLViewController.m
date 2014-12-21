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
    
    
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    
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
    
    self.collectionView.scrollsToTop = YES;
    
    [self.collectionView registerClass:[MyCustomCell class] forCellWithReuseIdentifier:@"CardCell"];
    
    ADBannerView *bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0,self.collectionView.superview.frame.size.height - 50,self.collectionView.superview.frame.size.width, 50)];
    
    [self.collectionView.superview addSubview:bannerView];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.165 green:0.122 blue:0.122 alpha:1.000]];

    [self.collectionView setScrollsToTop:YES];
    
    UINib *cellNib = [UINib nibWithNibName:@"MyCustomCell" bundle:nil];
   
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CardCell"];
        self.arrBrandColors = [self brandColors];
    
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
        [cell.nameLabel setTextColor:self.arrBrandColors[arc4random_uniform(self.arrBrandColors.count)]];
        cell.title = card[QuestionKey];
        
    }
    if (![card[AnswerKey] isKindOfClass:[NSNull class]]) {
        
        cell.answerTextField.textColor = [UIColor colorWithRed:0.165 green:0.122 blue:0.122 alpha:1.000];
        cell.answerTextField.text = card[AnswerKey];

    }
    if (indexPath.row%2 == 0) {
        cell.color = [UIColor grayColor];

    }
    else{
        cell.color = [UIColor lightGrayColor];
    }
    
    cell.countLabel.textColor = [UIColor colorWithRed:0.165 green:0.122 blue:0.122 alpha:1.000];
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
    if ([[CommonAppManager sharedAppManager] questionsArray].count) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];

    }
    if (self.exposedItemIndexPath) {
        
        [self setExposedItemIndexPath:nil];
        
    }
    
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


#pragma mark

-(NSArray *)brandColors {
    return @[[UIColor Fourormat],
             [UIColor FiveHundredPX],
             [UIColor AboutMeBlue],
             [UIColor AboutMeYellow],
             [UIColor Addvocate],
             [UIColor Adobe],
             [UIColor Aim],
             [UIColor Amazon],
             [UIColor Android],
             [UIColor Asana],
             [UIColor Atlassian],
             [UIColor Behance],
             [UIColor bitly],
             [UIColor Blogger],
             [UIColor Carbonmade],
             [UIColor Cheddar],
             [UIColor CocaCola],
             [UIColor CodeSchool],
             [UIColor Delicious],
             [UIColor Dell],
             [UIColor Designmoo],
             [UIColor Deviantart],
             [UIColor DesignerNews],
             [UIColor Dewalt],
             [UIColor DisqusBlue],
             [UIColor DisqusOrange],
             [UIColor Dribbble],
             [UIColor Dropbox],
             [UIColor Drupal],
             [UIColor Dunked],
             [UIColor eBay],
             [UIColor Ember],
             [UIColor Engadget],
             [UIColor Envato],
             [UIColor Etsy],
             [UIColor Evernote],
             [UIColor Fab],
             [UIColor Facebook],
             [UIColor Firefox],
             [UIColor FlickrBlue],
             [UIColor FlickrPink],
             [UIColor Forrst],
             [UIColor Foursquare],
             [UIColor Garmin],
             [UIColor GetGlue],
             [UIColor Gimmebar],
             [UIColor GitHub],
             [UIColor GoogleBlue],
             [UIColor GoogleGreen],
             [UIColor GoogleRed],
             [UIColor GoogleYellow],
             [UIColor GooglePlus],
             [UIColor Grooveshark],
             [UIColor Groupon],
             [UIColor HackerNews],
             [UIColor HelloWallet],
             [UIColor HerokuLight],
             [UIColor HerokuDark],
             [UIColor HootSuite],
             [UIColor Houzz],
             [UIColor HP],
             [UIColor HTML5],
             [UIColor Hulu],
             [UIColor IBM],
             [UIColor IKEA],
             [UIColor IMDb],
             [UIColor Instagram],
             [UIColor Instapaper],
             [UIColor Intel],
             [UIColor Intuit],
             [UIColor Kickstarter],
             [UIColor kippt],
             [UIColor Kodery],
             [UIColor LastFM],
             [UIColor LinkedIn],
             [UIColor Livestream],
             [UIColor Lumo],
             [UIColor MakitaRed],
             [UIColor MakitaBlue],
             [UIColor Mixpanel],
             [UIColor Meetup],
             [UIColor Netflix],
             [UIColor Nokia],
             [UIColor NVIDIA],
             [UIColor Odnoklassniki],
             [UIColor Opera],
             [UIColor Path],
             [UIColor PayPalDark],
             [UIColor PayPalLight],
             [UIColor Pinboard],
             [UIColor Pinterest],
             [UIColor PlayStation],
             [UIColor Pocket],
             [UIColor Prezi],
             [UIColor Pusha],
             [UIColor Quora],
             [UIColor QuoteFm],
             [UIColor Rdio],
             [UIColor Readability],
             [UIColor RedHat],
             [UIColor RedditBlue],
             [UIColor RedditOrange],
             [UIColor Resource],
             [UIColor Rockpack],
             [UIColor Roon],
             [UIColor RSS],
             [UIColor Salesforce],
             [UIColor Samsung],
             [UIColor Shopify],
             [UIColor Skype],
             [UIColor SmashingMagazine],
             [UIColor Snagajob],
             [UIColor Softonic],
             [UIColor SoundCloud],
             [UIColor SpaceBox],
             [UIColor Spotify],
             [UIColor Sprint],
             [UIColor Squarespace],
             [UIColor StackOverflow],
             [UIColor Staples],
             [UIColor StatusChart],
             [UIColor Stripe],
             [UIColor StudyBlue],
             [UIColor StumbleUpon],
             [UIColor TMobile],
             [UIColor Technorati],
             [UIColor TheNextWeb],
             [UIColor Treehouse],
             [UIColor Trello],
             [UIColor Trulia],
             [UIColor Tumblr],
             [UIColor TwitchTv],
             [UIColor Twitter],
             [UIColor Typekit],
             [UIColor TYPO3],
             [UIColor Ubuntu],
             [UIColor Ustream],
             [UIColor Verizon],
             [UIColor Vimeo],
             [UIColor Vine],
             [UIColor Virb],
             [UIColor VirginMedia],
             [UIColor VKontakte],
             [UIColor Wooga],
             [UIColor WordPressBlue],
             [UIColor WordPressOrange],
             [UIColor WordPressGrey],
             [UIColor Wunderlist],
             [UIColor XBOX],
             [UIColor XING],
             [UIColor Yahoo],
             [UIColor Yandex],
             [UIColor Yelp],
             [UIColor YouTube],
             [UIColor Zalongo],
             [UIColor Zendesk],
             [UIColor Zerply],
             [UIColor Zootool]];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView   // return a yes if you want to scroll to the top. if not defined, assumes YES
{
    if (scrollView == self.collectionView)
        return YES;
    return YES;
}


@end
