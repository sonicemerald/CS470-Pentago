//
//  PentagoBrain.h
//  PentagoStudentVersion
//
//  Created by AAK on 2/17/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//  Modified by Micah Gemmell
//

#import <Foundation/Foundation.h>

@interface PentagoBrain : NSObject

+(PentagoBrain *) sharedInstance;
@property (nonatomic) bool playerTurn;
@property (nonatomic) bool playerPlacedMove;
@property (nonatomic) bool playerRotated;
-(bool) SetPlayerTurn:(bool) turn;
-(int) isThereAWinner;
-(bool) addMove:(NSValue *)point byPlayer:(bool)player inQuadrant:(int)q;
-(void) rotateMoves:(NSString *) rotation inQuadrant:(int)q;

-(void)initialize;
@property (nonatomic) NSMutableArray* row;
@property (nonatomic) NSMutableArray* col0;
@property (nonatomic) NSMutableArray* col1;
@property (nonatomic) NSMutableArray* col2;
@property (nonatomic) NSMutableArray* col3;
@property (nonatomic) NSMutableArray* col4;
@property (nonatomic) NSMutableArray* col5;

@end
