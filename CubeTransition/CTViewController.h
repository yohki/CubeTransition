//
//  CTViewController.h
//  CubeTransition
//
//  Created by OHKI Yoshihito on 11/5/12.
//  Copyright (c) 2012 Veronica Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTViewController : UIViewController

- (IBAction)action1:(id)sender;
- (IBAction)action2:(id)sender;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
