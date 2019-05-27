//
//  PileHeaderView.m
//  iForWaste
//
//  Created by Sweta Kutty on 2019-03-04.
//  Copyright © 2019 Salus Systems. All rights reserved.
//

#import "PileHeaderView.h"
#import "UIColor+WasteColor.h"

@implementation PileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawHeaderForPilePlot: [self.userCreatedBlock isEqualToString:@"YES" ]];
    
}

- (void) drawHeaderForPilePlot: (BOOL) userCreated{
    
    NSMutableArray *labelArray = [[NSMutableArray alloc] init];
    
    [labelArray addObject:@" Pile #;w;y"];
    [labelArray addObject:@" L;e;y"];
    [labelArray addObject:@" W;e;y"];
    [labelArray addObject:@" H;e;y"];
    [labelArray addObject:@" Shape;e;n"];
    [labelArray addObject:@" Pile Area m2;w;y"];
    [labelArray addObject:@" Pile Volume m3;w;y"];
    [labelArray addObject:@" Sample Pile;w;y"];
    [labelArray addObject:@" L;m;y"];
    [labelArray addObject:@" W;m;y"];
    [labelArray addObject:@" H;m;y"];
    [labelArray addObject:@" Pile Area m2;w;y"];
    [labelArray addObject:@" Pile Volume m3;w;y"];
    [labelArray addObject:@" Species;w;y"];
    [labelArray addObject:@" Block;w;y"];
    [labelArray addObject:@" Comments;w;y"];
    
    //width for each column is 47
    int locationCounter = -48;
    //int alterCounter = 0;
    for (NSString *lbStr in labelArray){
        NSArray *lbStrAry = [lbStr componentsSeparatedByString:@";"];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(locationCounter, 88, 140, 45)];
        lbl.text = [lbStrAry objectAtIndex:0];
        
        if ([[lbStrAry objectAtIndex:0] isEqualToString:@" Pile Area m2"]){
            lbl.backgroundColor = [UIColor grayColor];
        }else if([[lbStrAry objectAtIndex:0] isEqualToString:@" Pile Volume m3"]){
            lbl.backgroundColor = [UIColor grayColor];
        }
        
        lbl.textColor = [UIColor blackColor];
        lbl.highlightedTextColor = [UIColor blackColor];
        lbl.transform = CGAffineTransformMakeRotation(-M_PI_2);
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.layer.borderColor = [UIColor blackColor].CGColor;
        lbl.layer.borderWidth = 1.0;
        [lbl setFont:[UIFont fontWithName:@"Helvetica" size:18]];
        
        [self addSubview:lbl];
        
        locationCounter = locationCounter + 43;
        //  alterCounter = alterCounter + 1;
    }    
    
    NSMutableArray *labelArray2 = [[NSMutableArray alloc] init];
    
    [labelArray2 addObject:@" Estimated Dimension ;e;1;4"];
    [labelArray2 addObject:@" Measured Dimensions;m;8;3"];
    //[labelArray2 addObject:@" Sample Pile Species %;s;13;20"];
    
    
    for (NSString *lbStr in labelArray2){
        NSArray *lbStrAry = [lbStr componentsSeparatedByString:@";"];
        int lbX = [[lbStrAry objectAtIndex:2] intValue] * 43;
        int lbWidth = [[lbStrAry objectAtIndex:3] intValue] * 43;

        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(lbX, 0, lbWidth, 42)];
        lbl.text = [lbStrAry objectAtIndex:0];
        
        if ([[lbStrAry objectAtIndex:0] isEqualToString:@" Pile Area m2"]){
            lbl.backgroundColor = [UIColor grayColor];
        }else if([[lbStrAry objectAtIndex:0] isEqualToString:@" Pile Volume m3"]){
            lbl.backgroundColor = [UIColor grayColor];
        }
        
        lbl.textColor = [UIColor blackColor];
        lbl.highlightedTextColor = [UIColor blackColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.lineBreakMode = NSLineBreakByCharWrapping;
        lbl.numberOfLines = 0;
        lbl.layer.borderColor = [UIColor blackColor].CGColor;
        lbl.layer.borderWidth = 1.0;
        [lbl setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [self addSubview:lbl];
        
        locationCounter = locationCounter + 43;
    }

}


@end
