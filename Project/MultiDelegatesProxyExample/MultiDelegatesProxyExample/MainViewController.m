//
//  MainViewController.m
//  MultiDelegatesProxyExample
//
//  Created by Daniele Margutti on 05/02/14.
//  Copyright (c) 2014 danielemargutti. All rights reserved.
//

#import "MainViewController.h"

#import "DMMultiDelegatesProxy.h"

@interface MainViewController () <UIScrollViewDelegate> {
	IBOutlet	UIScrollView				*theScrollView;
				UIImageView					*bkImageView;
				DMMultiDelegatesProxy		*multiDelegateProxy;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	theScrollView.backgroundColor = [UIColor lightGrayColor];
	theScrollView.contentSize = CGSizeMake(theScrollView.contentSize.width, theScrollView.frame.size.height*3);
	theScrollView.maximumZoomScale= 5.0;
	
	UIImage *backImage = [UIImage imageNamed:@"landscape.jpg"];
	bkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
    [bkImageView setImage:backImage];
    [theScrollView addSubview:bkImageView];
	
	// create our DMMultiDelegatesProxy proxy object, register delegates
	// and set as delegate of our object a new instance of DMMultiDelegatesProxy.
	// Simple, yuh?
	multiDelegateProxy = [DMMultiDelegatesProxy newProxyWithMainDelegate:self other:@[[UIApplication sharedApplication].delegate]];
	theScrollView.delegate = ((id <UIScrollViewDelegate>)multiDelegateProxy);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	NSLog(@"[in %@] Scroll %@",NSStringFromClass(self.class),NSStringFromCGPoint(scrollView.contentOffset));
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	NSLog(@"[in %@] viewForZoomingInScrollView return value is consumed! it's main delegate",NSStringFromClass(self.class));
	return bkImageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
