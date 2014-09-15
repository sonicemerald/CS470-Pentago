//
//  PentagoSubBoardViewController.m
//  PentagoStudentVersion
//
//  Created by AAK on 2/17/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//  Modified by Micah Gemmell
//

#import "PentagoSubBoardViewController.h"
#import "PentagoViewController.h"
#import "PentagoBrain.h"

const int BORDER_WIDTH = 10;
const int TOP_MARGIN = 50;

@interface PentagoSubBoardViewController () {
    int subsquareNumber;
    int widthOfSubsquare;
}

@property (nonatomic, strong) PentagoBrain *pBrain;
@property(nonatomic) CALayer *blueLayer;
@property(nonatomic) CALayer *ballLayer;
@property (nonatomic, strong) UIImageView *gridImageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGest;
@property (nonatomic) UISwipeGestureRecognizer *rightSwipe;
@property (nonatomic) UISwipeGestureRecognizer *leftSwipe;
@property (nonatomic) NSString *imageName;

-(void) didTapTheView: (UITapGestureRecognizer *) tapObject;

@end

@implementation PentagoSubBoardViewController
-(id) initWithSubsquare: (int) position
{
    // 0 1
    // 2 3
    if( (self = [super init]) == nil )
        return nil;
    subsquareNumber = position;
    // appFrame is the frame of the entire screen so that appFrame.size.width
    // and appFrame.size.height contain the width and the height of the screen, respectively.
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    widthOfSubsquare = ( appFrame.size.width-3 * BORDER_WIDTH ) / 2;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect ivFrame = CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare);
    self.gridImageView.frame = ivFrame;
    UIImage *image = [UIImage imageNamed:@"grid.png"];
    [self.gridImageView setImage:image];
    [self.view addSubview:self.gridImageView];
    [self.view addGestureRecognizer: self.rightSwipe];
    [self.view addGestureRecognizer: self.leftSwipe];
    [self.view addGestureRecognizer: self.tapGest];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    NSInteger Vx = [self.view convertPoint:[self.view center] toView:self.view.superview].x;
    NSInteger Vy = [self.view convertPoint:[self.view center] toView:self.view.superview].y;
    
    //10px margin around all sides
    CGRect viewFrame = CGRectMake(((Vx-(widthOfSubsquare+BORDER_WIDTH)*(subsquareNumber%2))), ((Vy-(widthOfSubsquare+BORDER_WIDTH)*(subsquareNumber/2))), widthOfSubsquare, widthOfSubsquare-(2*BORDER_WIDTH));

    //No Margin
    //CGRect viewFrame = CGRectMake(((Vx-(widthOfSubsquare)*(subsquareNumber%2))), ((Vy-(widthOfSubsquare)*(subsquareNumber/2))), widthOfSubsquare, widthOfSubsquare-(2*BORDER_WIDTH));
    
    self.view.frame = viewFrame;
    self.pBrain.playerPlacedMove = false;
    self.pBrain.playerRotated = false;
}

-(UITapGestureRecognizer *) tapGest
{
    if( ! _tapGest ) {
        _tapGest = [[UITapGestureRecognizer alloc]
                    initWithTarget:self action:@selector(didTapTheView:)];
        
        [_tapGest setNumberOfTapsRequired:1];
        [_tapGest setNumberOfTouchesRequired:1];
    }
    return _tapGest;
}
-(void) didTapTheView: (UITapGestureRecognizer *) tapObject
{
    // p is the location of the tap in the coordinate system of this view-controller's view (not the view of the
    // the view-controller that includes the subboards.)
    
    CGPoint p = [tapObject locationInView:self.view];
    int squareWidth = widthOfSubsquare / 3;
    // The board is divided into nine equally sized squares and thus width = height.
    CGPoint n = CGPointMake((int)(p.x/squareWidth), (int)p.y/squareWidth);
    if(![self.pBrain addMove:[NSValue valueWithCGPoint:n] byPlayer:_pBrain.playerTurn inQuadrant:subsquareNumber])
        return;
    
    if (self.pBrain.playerTurn == 0)
        self.imageName = @"redMarble.png";
    else
        self.imageName = @"greenMarble.png";
    UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageName]];
    p = [self.gridImageView convertPoint:p fromView:self.view];
    iView.frame = CGRectMake((int) (p.x / squareWidth) * squareWidth,
                             (int) (p.y / squareWidth) * squareWidth,
                             3+squareWidth - BORDER_WIDTH / 3,
                             3+squareWidth - BORDER_WIDTH / 3);

    [self.gridImageView addSubview:iView];
    self.ballLayer = [CALayer layer];
    [self.ballLayer addSublayer: iView.layer];
    self.ballLayer.frame = CGRectMake(0, 0, widthOfSubsquare, widthOfSubsquare);
    self.ballLayer.affineTransform = CGAffineTransformMakeRotation(0.0);
    [self.gridImageView.layer addSublayer:self.ballLayer];
    int winner = [self.pBrain isThereAWinner];
    if(winner != 0){
        [self displayWinner:winner];
    }
}

-(UISwipeGestureRecognizer *) rightSwipe
{
    if( !_rightSwipe ) {
        _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
        [_rightSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    }
    return _rightSwipe;
}

-(void) didSwipeRight: (UISwipeGestureRecognizer *) swipeObject
{
    if(!self.pBrain.playerPlacedMove || self.pBrain.playerRotated)
        return;
    else self.pBrain.playerRotated = true;
    [self.pBrain SetPlayerTurn:!_pBrain.playerTurn];
    CGAffineTransform currTransform = self.gridImageView.layer.affineTransform;
    [UIView animateWithDuration:1 animations:^ {
        CGAffineTransform newTransform = CGAffineTransformConcat(currTransform, CGAffineTransformMakeRotation(M_PI_2));
        self.gridImageView.layer.affineTransform = newTransform;
    }];
    
    [self.view.superview bringSubviewToFront:self.view];
    [self.view addGestureRecognizer:self.rightSwipe];
    [self.view addGestureRecognizer:self.leftSwipe];
    [self.pBrain rotateMoves:@"right" inQuadrant:subsquareNumber];
    
    int winner = [self.pBrain isThereAWinner];
    if(winner != 0){
        [self displayWinner:winner];
    }
}
-(UISwipeGestureRecognizer *) leftSwipe
{
    if( !_leftSwipe ) {
        _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
        [_leftSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
    return _leftSwipe;
}
-(void) didSwipeLeft: (UISwipeGestureRecognizer *) swipeObject
{
    if(!self.pBrain.playerPlacedMove || self.pBrain.playerRotated)
        return;
    else self.pBrain.playerRotated = true;
    [self.pBrain SetPlayerTurn:!_pBrain.playerTurn];
    CGAffineTransform currTransform = self.gridImageView.layer.affineTransform;
    [UIView animateWithDuration:1 animations:^ {
        CGAffineTransform newTransform = CGAffineTransformConcat(currTransform, CGAffineTransformMakeRotation(-M_PI_2));
        self.gridImageView.layer.affineTransform = newTransform;
    }];
    
    [self.view.superview bringSubviewToFront:self.view];
    [self.view addGestureRecognizer:self.rightSwipe];
    [self.view addGestureRecognizer:self.leftSwipe];
    [self.pBrain rotateMoves:@"left" inQuadrant:subsquareNumber];
    int winner = [self.pBrain isThereAWinner];
    if(winner != 0){
        [self displayWinner:winner];
    }
    
}

-(void)displayWinner:(int)winner{
    NSString *color;
    if(winner == 1)
        color = @"Red";
    else color = @"Green";
    
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:color
                                                       message:@"Congratulations, you won!"
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [theAlert show];
}

-(PentagoBrain *) pBrain
{
    if( ! _pBrain ){
        _pBrain = [PentagoBrain sharedInstance];
        _pBrain.initialize;}
    return _pBrain;
}

-(UIImageView *) gridImageView
{
    if( ! _gridImageView ) {
        _gridImageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    }
    return _gridImageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
