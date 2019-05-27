//
//  PileEditTableViewCell.m
//  iForWaste
//
//  Created by Sweta Kutty on 2019-03-04.
//  Copyright © 2019 Salus Systems. All rights reserved.
//

#import "PileEditTableViewCell.h"
#import "UIColor+WasteColor.h"
#import "WastePile+CoreDataClass.h"
#import "PileValueTableViewController.h"
#import "PilePlotViewController.h"
#import "PileShapeCode+CoreDataClass.h"
#import "CodeDAO.h"
#import "WasteBlock.h"
#import "Constants.h"
#import "SpeciesPercentViewController.h"

@implementation PileEditTableViewCell

@synthesize cellWastePile;
@synthesize displayObjectDictionary;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)bindCell:(WastePile *)wastePile wasteBlock:(WasteBlock *)wasteBlock userCreatedBlock:(BOOL)userCreatedBlock {
    
    self.cellWastePile = wastePile;
    self.wasteBlock = wasteBlock;
    
    NSMutableArray *labelArray = [[NSMutableArray alloc] init];
    int locationCounter = 0;
    int total = 0;
    [labelArray addObject:@";pileId;w;43;l;1"];
    [labelArray addObject:@";length;e;43;l;2"];
    [labelArray addObject:@";width;e;43;l;3"];
    [labelArray addObject:@";height;e;43;l;4"];
    [labelArray addObject:@";pilePileShapeCode;e;43;l;5"];
    [labelArray addObject:@";pileArea;w;43;l;6"];
    [labelArray addObject:@";pileVolume;w;43;l;7"];
    [labelArray addObject:@";sampleNumber;w;43;l;8"];
    [labelArray addObject:@";measuredLength;m;43;b;9"];
    [labelArray addObject:@";measuredWidth;m;43;b;10"];
    [labelArray addObject:@";measuredHeight;m;43;b;11"];
    [labelArray addObject:@";measuredPileArea;w;43;l;12"];
    [labelArray addObject:@";measuredPileVolume;w;43;l;13"];
    [labelArray addObject:@";;w;43;b;14"];
    [labelArray addObject:@";length;w;43;l;15"];
    [labelArray addObject:@";comment;w;43;b;16"];
    
    //init the display object dictionary if it is not initialized yet
    if (!self.displayObjectDictionary){
        self.displayObjectDictionary = [[NSMutableDictionary alloc] init];
    }
    
    for (NSString *lbStr in labelArray){
        NSArray *lbStrAry = [lbStr componentsSeparatedByString:@";"];
        
        int widthInt = [[lbStrAry objectAtIndex:3] intValue];
        float width = [[NSNumber numberWithInt:widthInt] floatValue];
        
        if ([[lbStrAry objectAtIndex:4] isEqualToString:@"l"]){
            UILabel *lbl = nil;
            if ([self.displayObjectDictionary valueForKey:[lbStrAry objectAtIndex:1]]){
                lbl =[self.displayObjectDictionary valueForKey:[lbStrAry objectAtIndex:1]];
            }else{
                lbl = [[UILabel alloc] initWithFrame:CGRectMake(locationCounter, -1, width, 45)];
                [self.displayObjectDictionary setObject:lbl forKey:[lbStrAry objectAtIndex:1]];
            }
            
            if (![[lbStrAry objectAtIndex:1] isEqualToString: @""]){
                if([[wastePile valueForKey:[lbStrAry objectAtIndex:1]] isKindOfClass:[NSString class]]){
                    lbl.text = [wastePile valueForKey:[lbStrAry objectAtIndex:1]];
                }else if ([[wastePile valueForKey:[lbStrAry objectAtIndex:1]] isKindOfClass:[NSNumber class]]){
                    lbl.text =[(NSNumber *)[wastePile valueForKey:[lbStrAry objectAtIndex:1]] stringValue];
                }else if([[wastePile valueForKey:[lbStrAry objectAtIndex:1]] isKindOfClass:[PileShapeCode class]]){
                    lbl.text = [wastePile valueForKey:[lbStrAry objectAtIndex:1]] ? [(PileShapeCode *)[wastePile valueForKey:[lbStrAry objectAtIndex:1]] pileShapeCode] : @"";
                }
            }
            
            if ([[lbStrAry objectAtIndex:1] isEqualToString:@"pileArea"]){
                lbl.backgroundColor = [UIColor grayColor];
            }else if([[lbStrAry objectAtIndex:1] isEqualToString:@"pileVolume"]){
                lbl.backgroundColor = [UIColor grayColor];
            }else if([[lbStrAry objectAtIndex:1] isEqualToString:@"measuredPileArea"]) {
                lbl.backgroundColor = [UIColor grayColor];
            }else if([[lbStrAry objectAtIndex:1] isEqualToString:@"measuredPileVolume"]) {
                lbl.backgroundColor = [UIColor grayColor];
            }else if([[lbStrAry objectAtIndex:1] isEqualToString:@"pileId"]) {
                lbl.backgroundColor = [UIColor colorWithRed:5/255.0 green:180/255.0 blue:66/255.0 alpha:1];
            }
            
            lbl.textColor = [UIColor blackColor];
            lbl.highlightedTextColor = [UIColor blackColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.layer.borderColor = [UIColor blackColor].CGColor;
            lbl.layer.borderWidth = 1.0;
            [lbl setFont:[UIFont fontWithName:@"Helvetica" size:18]];
            
            [self addSubview:lbl];
            
        }else if([[lbStrAry objectAtIndex:4] isEqualToString: @"b"]){
            UIButton *btn = nil;
            
            if ([self.displayObjectDictionary valueForKey:[lbStrAry objectAtIndex:1]]){
                btn =[self.displayObjectDictionary valueForKey:[lbStrAry objectAtIndex:1]];
            }else{
                btn = [[UIButton alloc] initWithFrame:CGRectMake(locationCounter, -1, width, 45)];
                [self.displayObjectDictionary setObject:btn forKey:[lbStrAry objectAtIndex:1]];
            }
            
            if (![[lbStrAry objectAtIndex:1] isEqualToString: @""]){
                // for now, it only work when the property is string
                
                if ([[lbStrAry objectAtIndex:1] isEqualToString:@"comment"]){
                    if([wastePile valueForKey:[lbStrAry objectAtIndex:1]]){
                        [btn setTitle: @"*" forState:UIControlStateNormal];
                    }else{
                        [btn setTitle: @"" forState:UIControlStateNormal];
                    }
                }else{
                    //NSLog(@"property name = %@", [lbStrAry objectAtIndex:1]);
                    if ([wastePile valueForKey:[lbStrAry objectAtIndex:1]]){
                        
                        if([[wastePile valueForKey:[lbStrAry objectAtIndex:1]] isKindOfClass:[NSDecimalNumber class]]){
                            [btn setTitle:[[NSString alloc] initWithFormat:@"%0.1f", [(NSDecimalNumber *)[wastePile valueForKey:[lbStrAry objectAtIndex:1]] floatValue]] forState:UIControlStateNormal];
                        }else if ([[wastePile valueForKey:[lbStrAry objectAtIndex:1]] isKindOfClass:[NSNumber class]]){
                            [btn setTitle:[(NSNumber *)[wastePile valueForKey:[lbStrAry objectAtIndex:1]] stringValue] forState:UIControlStateNormal];
                            total += [(NSNumber *)[wastePile valueForKey:[lbStrAry objectAtIndex:1]] integerValue];
                        }else if([[wastePile valueForKey:[lbStrAry objectAtIndex:1]] isKindOfClass:[NSString class]]){
                            [btn setTitle:[wastePile valueForKey:[lbStrAry objectAtIndex:1]] forState:UIControlStateNormal];
                        }else{
                            
                        }
                    }else{
                        [btn setTitle:@" " forState:UIControlStateNormal];
                    }
                }
                
            }
            
            if ([[lbStrAry objectAtIndex:1] isEqualToString:@"pileArea"]){
                btn.backgroundColor = [UIColor grayColor];
            }else if([[lbStrAry objectAtIndex:1] isEqualToString:@"pileVolume"]){
                btn.backgroundColor = [UIColor grayColor];
            }else if([[lbStrAry objectAtIndex:1] isEqualToString:@"measuredPileArea"]) {
                btn.backgroundColor = [UIColor grayColor];
            }else if([[lbStrAry objectAtIndex:1] isEqualToString:@"measuredPileVolume"]) {
                btn.backgroundColor = [UIColor grayColor];
            }
            
            if([[lbStrAry objectAtIndex:1] isEqualToString:@""]){
                total += [wastePile.alPercent intValue] + [wastePile.arPercent intValue] + [wastePile.asPercent intValue] + [wastePile.baPercent intValue] + [wastePile.biPercent intValue] + [wastePile.cePercent intValue] + [wastePile.coPercent intValue] + [wastePile.cyPercent intValue] + [wastePile.fiPercent intValue] + [wastePile.hePercent intValue] + [wastePile.laPercent intValue] + [wastePile.loPercent intValue] + [wastePile.maPercent intValue] + [wastePile.otPercent intValue] + [wastePile.spPercent intValue] + [wastePile.wbPercent intValue] +
                [wastePile.whPercent intValue] + [wastePile.wiPercent intValue] + [wastePile.uuPercent intValue] + [wastePile.yePercent intValue];
                
               // [btn setTitle:total forState:UIControlStateNormal];
            }
            //populate the initial value for testing purpose
            /*
             if (![[lbStrAry objectAtIndex:0] isEqualToString:@""]){
             [btn setTitle:[lbStrAry objectAtIndex:0] forState:UIControlStateNormal];
             }
             */
            
            //btn.textColor = [UIColor blackColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //btn.textAlignment = NSTextAlignmentCenter;
            btn.layer.borderColor = [UIColor blackColor].CGColor;
            btn.layer.borderWidth = 1.0;
            [[btn titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:18]];
            //set the tag number to identify what field
            if (![[lbStrAry objectAtIndex:5] isEqualToString: @""]){
                btn.tag = [[lbStrAry objectAtIndex:5] intValue];
            }
            if (btn.tag == 14) {
                [btn addTarget:self action:@selector(editActionClick1:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [btn addTarget:self action:@selector(editActionClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self addSubview:btn];
        }
              
        
        locationCounter = locationCounter + widthInt;
        //  alterCounter = alterCounter + 1;
    }
}

-(IBAction)editActionClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    PileValueTableViewController *pvc = [self.pileView.storyboard instantiateViewControllerWithIdentifier:@"PileLookupPickerViewControllerSID"];

    switch (btn.tag) {
        case 9:
            pvc.propertyName = @"measuredLength";
            break;
        case 10:
            pvc.propertyName = @"measuredWidth";
            break;
        case 11:
            pvc.propertyName = @"measuredHeight";
            break;
        case 16:
            pvc.propertyName = @"comment";
            break;
        default:
            break;
    }
    // pvc.title =[NSString stringWithFormat:@"%@ %@", @"(IFOR 205", pvc.title];
    pvc.wastePile = self.cellWastePile;
    pvc.wasteBlock = self.wasteBlock;
    pvc.pileVC = self.pileView;
    //pvc.editPieceViewController = self.superview;
    
    //NSLog(@"cell's super view = %@", self.superview);
    
    [self.pileView.navigationController pushViewController:pvc animated:YES];
}

-(IBAction)editActionClick1:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    SpeciesPercentViewController *pvc = [self.pileView.storyboard instantiateViewControllerWithIdentifier:@"SpeciesPercentViewControllerSID"];
    
    pvc.wastePile = self.cellWastePile;
    pvc.wasteBlock = self.wasteBlock;
    pvc.pileVC = self.pileView;
    
    [self.pileView.navigationController pushViewController:pvc animated:YES];
}

#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

@end
