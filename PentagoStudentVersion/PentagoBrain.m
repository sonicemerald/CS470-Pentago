//
//  PentagoBrain.m
//  PentagoStudentVersion
//
//  Created by AAK on 2/17/14.
//  Copyright (c) 2014 Ali Kooshesh. All rights reserved.
//  Modified by Micah Gemmell
//

#import "PentagoBrain.h"


@implementation PentagoBrain

-(void) initialize{
    if(self.col0 == nil)
        self.col0 = [[NSMutableArray alloc] initWithObjects:@0,@0,@0,@0,@0,@0,nil];
    if(self.col1 == nil)
        self.col1 = [[NSMutableArray alloc] initWithObjects:@0,@0,@0,@0,@0,@0,nil];
    if(self.col2 == nil)
        self.col2 = [[NSMutableArray alloc] initWithObjects:@0,@0,@0,@0,@0,@0,nil];
    if(self.col3 == nil)
        self.col3 = [[NSMutableArray alloc] initWithObjects:@0,@0,@0,@0,@0,@0,nil];
    if(self.col4 == nil)
        self.col4 = [[NSMutableArray alloc] initWithObjects:@0,@0,@0,@0,@0,@0,nil];
    if(self.col5 == nil)
        self.col5 = [[NSMutableArray alloc] initWithObjects:@0,@0,@0,@0,@0,@0,nil];
    if(self.row == nil)
        self.row = [[NSMutableArray alloc] initWithObjects:self.col0,self.col1,self.col2,self.col3,self.col4,self.col5,nil];
}

+(PentagoBrain *) sharedInstance
{
    static PentagoBrain *sharedObject = nil;
    
    
    
    if( sharedObject == nil )
        sharedObject = [[PentagoBrain alloc] init];

    
    return sharedObject;
}

-(bool) SetPlayerTurn:(bool) turn{
    
    self.playerPlacedMove = false;
    self.playerRotated = false;
    self.playerTurn = turn;
    
    return true;
}


-(bool) addMove:(NSValue *)point byPlayer:(bool)player inQuadrant:(int)q{
    int x = 0;
    int y = 0;
    int xoffset = 0;
    int yoffset = 0;
    
    switch (q) {
        case 2:
            xoffset = 3;
            break;
        case 1:
            yoffset = 3;
            break;
        case 0:
            yoffset = xoffset = 3;
            break;
        default:
            break;
    }
    x = xoffset+(int)[point CGPointValue].x;
    y = yoffset+(int)[point CGPointValue].y;

    if( ([[[self.row objectAtIndex:x] objectAtIndex:y] isEqual: @1]) || [[[self.row objectAtIndex:x] objectAtIndex:y]  isEqual: @2])
        return false;

    if(self.playerPlacedMove){
        return false; }
    
    self.playerPlacedMove = true;

    
    if(player == 0){// Player 1
        [[self.row objectAtIndex:x] setObject:@1 atIndex:y];
    } else {
        [[self.row objectAtIndex:x] setObject:@2 atIndex:y];
    }

    return true;
}

-(void) rotateMoves:(NSString *) rotation inQuadrant:(int)q{
    int xoffset = 0;
    int yoffset = 0;
    // 3 2 The board is flipped for some reason.
    // 1 0
    switch (q) {
        case 2:
            xoffset = 3;
            break;
        case 1:
            yoffset = 3;
            break;
        case 0:
            yoffset = xoffset = 3;
            break;
        default:
            break;
    }
    //This way of applying a matrix transform seems like it could be a slick way of rotating the board, it just has a few bugs that I'm not entirely sure of the cause, so I do the same thing, except by copying the board I want to rotate to a temporary array and apply the transform.
//        int x =0; int y =0;
//        for(x = xoffset; x <= xoffset+2; x++)
//            for(y = yoffset; y <= x; y++){
//                
//            //Swap X and Y; //Transpose
//            NSNumber *objX = [[self.row objectAtIndex:x] objectAtIndex:y];
//            NSNumber *objY = [[self.row objectAtIndex:y] objectAtIndex:x];
//            [[self.row objectAtIndex:x] setObject:objY atIndex:y];
//            [[self.row objectAtIndex:y] setObject:objX atIndex:x];
//        }
//    
//            if([rotation isEqual: @"right"]){
//                //reverse rows
//                int x = xoffset;
//                [self.row exchangeObjectAtIndex:x withObjectAtIndex:x+2];
//            } else {
//                //reverse cols
//                int y = yoffset;
//                for(int x = xoffset; x <= xoffset+2; x++)
//                    [[self.row objectAtIndex:x] exchangeObjectAtIndex:y withObjectAtIndex:y+2];
//            }
    NSMutableArray *tcol0 = [[NSMutableArray alloc] init];
    NSMutableArray *tcol1 = [[NSMutableArray alloc] init];
    NSMutableArray *tcol2 = [[NSMutableArray alloc] init];
    NSMutableArray *temp = [[NSMutableArray alloc] initWithObjects:tcol0,tcol1,tcol2,nil];
    
    int x1 = xoffset;
    for(int y1 = yoffset; y1<=yoffset+2; y1++){
        [tcol0 addObject:[[self.row objectAtIndex:x1] objectAtIndex:y1]];
        [tcol1 addObject:[[self.row objectAtIndex:x1+1] objectAtIndex:y1]];
        [tcol2 addObject:[[self.row objectAtIndex:x1+2] objectAtIndex:y1]];
    }
    for(int x = 0; x <= 2; x++)
        for(int y = 0; y <= x; y++){
            //Swap X and Y; //Transpose
            NSNumber *objX = [[temp objectAtIndex:x] objectAtIndex:y];
            NSNumber *objY = [[temp objectAtIndex:y] objectAtIndex:x];
            [[temp objectAtIndex:x] setObject:objY atIndex:y];
            [[temp objectAtIndex:y] setObject:objX atIndex:x];
        }
    
    if([rotation isEqual: @"right"]){
        //reverse rows
        int x = 0;
        [temp exchangeObjectAtIndex:x withObjectAtIndex:x+2];
    } else {
        //reverse cols
        int y = 0;
        for(int x = 0; x <=2; x++)
            [[temp objectAtIndex:x] exchangeObjectAtIndex:y withObjectAtIndex:y+2];
    }
    
    //copy temp back to main array.
    for(int x = 0; x<=2; x++)
        for(int y = 0; y<=2; y++){
            NSNumber *obj = [[temp objectAtIndex:x] objectAtIndex:y];
            [[self.row objectAtIndex:x+xoffset] setObject:obj atIndex:y+yoffset];
        }
    temp = nil;

}

-(int) isThereAWinner{
    //This function could be condensed considerably, but I am running out of time. I think I could loop over the board once and determine if there is a winner or not, I just don't have enough time to figure that out right now.
    int P1wincount = 0;
    int P2wincount = 0;
    
    //check for diagonal win
    for(int y = 0; y <= 5; y++){
        for(int x = 0; x <= 5; x++){
            for(int i = 0; i <=5; i++){
                int marble = [[[self.row objectAtIndex:x] objectAtIndex:y] intValue];
                int nextMarble = 9;
                if(x+i >= 6) continue;
                if(y+i >= 6) continue;
                nextMarble = [[[self.row objectAtIndex:x+i] objectAtIndex:y+i] intValue];
                if(marble == nextMarble)
                switch (marble) {
                    case 0:
                        P1wincount = P2wincount = 0;
                        break;
                    case 1:
                        P1wincount++;
                        P2wincount = 0;
                        break;
                    case 2:
                        P2wincount++;
                        P1wincount = 0;
                        break;
                    default:
                        break;
                }
            }
            if (P1wincount == 5){
                return 1;
            } else if(P2wincount == 5){
                return 2;
            }

        }
    }
    P1wincount = 0;
    P2wincount = 0;

    //check for right to left diagonal win
    for(int y = 0; y <= 5; y++){
        for(int x = 0; x <= 5; x++){
            for(int i = 0; i <=5; i++){
                int marble = [[[self.row objectAtIndex:x] objectAtIndex:y] intValue];
                int nextMarble = 9;
                if(y+i >= 6) continue;
                if(x-i >= 0)
                nextMarble = [[[self.row objectAtIndex:x-i] objectAtIndex:y+i] intValue];
                if(marble == nextMarble)
                    switch (marble) {
                        case 0:
                            P1wincount = P2wincount = 0;
                            break;
                        case 1:
                            P1wincount++;
                            P2wincount = 0;
                            break;
                        case 2:
                            P2wincount++;
                            P1wincount = 0;
                            break;
                        default:
                            break;
                    }
            }
            if (P1wincount == 5){
                return 1;
            } else if(P2wincount == 5){
                return 2;
            }
            
        }
    }
    P1wincount = 0;
    P2wincount = 0;

    //checking for a row win
    for(int y = 0; y <= 5; y++){
        for(int x = 0; x <= 5; x++){
            int marble = [[[self.row objectAtIndex:x] objectAtIndex:y] intValue];
            switch (marble) {
                case 0:
                    P1wincount = P2wincount = 0;
                    break;
                case 1:
                    P1wincount++;
                    P2wincount = 0;
                    break;
                case 2:
                    P2wincount++;
                    P1wincount = 0;
                    break;
                default:
                    break;
            }
            
            if (P1wincount == 5){
                return 1;
                
            } else if (P2wincount == 5){
                return 2;
            }
        }
    }
    P1wincount = 0;
    P2wincount = 0;
    

    //check for column win
    for(int x = 0; x <= 5; x++){
            for(int y = 0; y <= 5; y++){
                int marble = [[[self.row objectAtIndex:x] objectAtIndex:y] intValue];
            
            switch (marble) {
                case 0:
                    P1wincount = P2wincount = 0;
                    break;
                case 1:
                    P1wincount++;
                    P2wincount = 0;
                    break;
                case 2:
                    P2wincount++;
                    P1wincount = 0;
                    break;
                default:
                    break;
            }
            
            if(P1wincount == 5){
                    return 1;
            } else if (P2wincount == 5){
                    return 2;
            }
        }
    }
    P1wincount = 0;
    P2wincount = 0;
    
    return 0;
}


@end
