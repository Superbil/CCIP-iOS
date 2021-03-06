//
//  ProgramDetailViewPagerController.m
//  CCIP
//
//  Created by FrankWu on 2016/7/19.
//  Copyright © 2016年 CPRTeam. All rights reserved.
//

#import "ProgramDetailViewPagerController.h"
#import "ProgramAbstractViewController.h"
#import "ProgramSpeakerIntroViewController.h"
#import "NSInvocation+addition.h"

@interface ProgramDetailViewPagerController()

@property (strong, nonatomic) ProgramAbstractViewController *abstractView;
@property (strong, nonatomic) ProgramSpeakerIntroViewController *speakerIntroView;
@property (strong, nonatomic) UIViewController *currentContentViewController;

@end

@implementation ProgramDetailViewPagerController

- (instancetype)init {
    self = [super init];
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        self.abstractView = (ProgramAbstractViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProgramAbstractViewController"];
        self.speakerIntroView = (ProgramSpeakerIntroViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ProgramSpeakerIntroViewController"];
    }
    return self;
}

- (instancetype)initWithProgram:(NSDictionary *)program {
    self = [self init];
    if (self) {
        // Custom initialization
        [self setProgram:program];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.currentContentViewController != nil) {
        if ([self.currentContentViewController canPerformAction:@selector(viewWillAppear:) withSender:@(animated)]) {
            [self.currentContentViewController viewWillAppear:animated];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.currentContentViewController != nil) {
        if ([self.currentContentViewController canPerformAction:@selector(viewDidAppear:) withSender:@(animated)]) {
            [self.currentContentViewController viewDidAppear:animated];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProgram:(NSMutableDictionary *)program {
    _program = program;
    
    [self.abstractView setProgram:_program];
    [self.speakerIntroView setProgram:_program];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 2;
}

#pragma mark - ViewPagerDataSource
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    
    switch (index) {
        case 0:
            label.text = NSLocalizedString(@"Introduction", nil);
            break;
        case 1:
            label.text = NSLocalizedString(@"Speaker", nil);
            break;
        default:
            label.text = @"(NULL)";
            break;
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    [self.view bringSubviewToFront:label];

    return label;
}

#pragma mark - ViewPagerDataSource
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            self.currentContentViewController = self.abstractView;
            break;
        case 1:
            self.currentContentViewController = self.speakerIntroView;
            break;
        default:
            self.currentContentViewController = [UIViewController new];
            break;
    }
    return self.currentContentViewController;
}

#pragma mark - ViewPagerDelegate
- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    // Do something useful
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        //case ViewPagerOptionTabHeight:
        //    return 49.0;
        //case ViewPagerOptionTabOffset:
        //    return 36.0;
        case ViewPagerOptionTabDisableTopLine:
            return 1.0;
        case ViewPagerOptionTabDisableBottomLine:
            return 1.0;
        case ViewPagerOptionTabNarmalLineWidth:
            return 5.0;
        case ViewPagerOptionTabSelectedLineWidth:
            return 5.0;
        case ViewPagerOptionTabWidth:
            return [[UIScreen mainScreen] bounds].size.width/2;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        case ViewPagerIndicator: {
            return [UIColor colorWithRed:184.0f/255.0f green:233.0f/255.0f blue:134.0f/255.0f alpha:1.0f];
        }
        case ViewPagerTabsView: {
            return [UIColor clearColor];
        }
        case ViewPagerContent: {
            return [UIColor clearColor];
        }
        default: {
            return color;
        }
    }
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}
@end
