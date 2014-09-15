//
//  PentagoSubBoardViewController.h
//  PentagoStudentVersion
//
//  Created by AAK on 2/17/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//  Modified by Micah Gemmell
//

#import <UIKit/UIKit.h>

@interface PentagoSubBoardViewController : UIViewController
-(id) initWithSubsquare: (int) position;
-(void)displayWinner:(int)winner;
@end
