//
//  SpeciesPercentViewController.m
//  WasteMobile
//
//  Created by Sweta Kutty on 2019-03-19.
//  Copyright © 2019 Salus Systems. All rights reserved.
//

#import "SpeciesPercentViewController.h"
#import "PilePlotViewController.h"
#import "WasteCalculator.h"
#import "WastePile+CoreDataClass.h"
#import "PileShapeCode+CoreDataClass.h"
#import "WastePlot.h"
#import "WasteStratum.h"
#import "WasteBlock.h"
#import "CodeDAO.h"
#import "WasteTypeCode.h"

@interface SpeciesPercentViewController ()

@end

@implementation SpeciesPercentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initLookup];
    [self calculateTotal];
}

-(void)initLookup{

    self.alPercent.text =  [self.wastePile valueForKey:@"alPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"alPercent"]] : @"";
    self.arPercent.text =  [self.wastePile valueForKey:@"arPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"arPercent"]] : @"";
    self.asPercent.text =  [self.wastePile valueForKey:@"asPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"asPercent"]] : @"";
    self.baPercent.text =  [self.wastePile valueForKey:@"baPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"baPercent"]] : @"";
    self.biPercent.text =  [self.wastePile valueForKey:@"biPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"biPercent"]] : @"";
    self.cePercent.text =  [self.wastePile valueForKey:@"cePercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"cePercent"]] : @"";
    self.coPercent.text =  [self.wastePile valueForKey:@"coPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"coPercent"]] : @"";
    self.cyPercent.text =  [self.wastePile valueForKey:@"cyPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"cyPercent"]] : @"";
    self.fiPercent.text =  [self.wastePile valueForKey:@"fiPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"fiPercent"]] : @"";
    self.hePercent.text =  [self.wastePile valueForKey:@"hePercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"hePercent"]] : @"";
    self.laPercent.text =  [self.wastePile valueForKey:@"laPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"laPercent"]] : @"";
    self.loPercent.text =  [self.wastePile valueForKey:@"loPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"loPercent"]] : @"";
    self.maPercent.text =  [self.wastePile valueForKey:@"maPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"maPercent"]] : @"";
    self.otPercent.text =  [self.wastePile valueForKey:@"otPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"otPercent"]] : @"";
    self.spPercent.text =  [self.wastePile valueForKey:@"spPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"spPercent"]] : @"";
    self.wbPercent.text =  [self.wastePile valueForKey:@"wbPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"wbPercent"]] : @"";
    self.whPercent.text =  [self.wastePile valueForKey:@"whPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"whPercent"]] : @"";
    self.wiPercent.text =  [self.wastePile valueForKey:@"wiPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"wiPercent"]] : @"";
    self.uuPercent.text =  [self.wastePile valueForKey:@"uuPercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"uuPercent"]] : @"";
    self.yePercent.text =  [self.wastePile valueForKey:@"yePercent"] ? [[NSString alloc] initWithFormat:@"%@", [self.wastePile valueForKey:@"yePercent"]] : @"";

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self calculateTotal];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveSpecies:(id)sender {
    
    if ([self.alPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"alPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.alPercent.text intValue]] forKey:@"alPercent"];
    }
    if ([self.arPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"arPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.arPercent.text intValue]] forKey:@"arPercent"];
    }
    if ([self.asPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"asPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.asPercent.text intValue]] forKey:@"asPercent"];
    }
    if ([self.baPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"baPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.baPercent.text intValue]] forKey:@"baPercent"];
    }
    if ([self.biPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"biPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.biPercent.text intValue]] forKey:@"biPercent"];
    }
    if ([self.cePercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"cePercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.cePercent.text intValue]] forKey:@"cePercent"];
    }
    if ([self.coPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"coPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.coPercent.text intValue]] forKey:@"coPercent"];
    }
    if ([self.cyPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"cyPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.cyPercent.text intValue]] forKey:@"cyPercent"];
    }
    if ([self.fiPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"fiPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.fiPercent.text intValue]] forKey:@"fiPercent"];
    }
    if ([self.hePercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"hePercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.hePercent.text intValue]] forKey:@"hePercent"];
    }
    if ([self.laPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"laPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.laPercent.text intValue]] forKey:@"laPercent"];
    }
    if ([self.loPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"loPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.loPercent.text intValue]] forKey:@"loPercent"];
    }
    if ([self.maPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"maPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.maPercent.text intValue]]forKey:@"maPercent"];
    }
    if ([self.otPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"otPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.otPercent.text intValue]] forKey:@"otPercent"];
    }
    if ([self.spPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"spPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.spPercent.text intValue]] forKey:@"spPercent"];
    }
    if ([self.wbPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"wbPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.wbPercent.text intValue]] forKey:@"wbPercent"];
    }
    if ([self.whPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"whPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.whPercent.text intValue]] forKey:@"whPercent"];
    }
    if ([self.wiPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"wiPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.wiPercent.text intValue]] forKey:@"wiPercent"];
    }
    if ([self.uuPercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"uuPercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.uuPercent.text intValue]] forKey:@"uuPercent"];
    }
    if ([self.yePercent.text isEqualToString:@""]){
        [self.wastePile setValue:nil forKey:@"yePercent"];
    }else{
        [self.wastePile setValue:[NSNumber numberWithInt:[self.yePercent.text intValue]] forKey:@"yePercent"];
    }
    [self calculateTotal];
    //calculate the piece stat
    WastePlot *plot =[self.wastePile valueForKey:@"pilePlot"];

    //NSLog(@"plotPile %@", self.wastePile);
    //udpate the current editing piece on plot viewcontroller
   //[self.pileVC updateCurrentPileProperty:(WastePile*)self.wastePile property:self.propertyName];

    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - alertView
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    switch (textField.tag) {
        case 1:
            return (newLength > 10) ? NO : YES;
            break;
        case 2:
            return (newLength > 256) ? NO : YES;
            break;
            
        default:
            return NO; // NOT EDITABLE
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [self saveSpecies:textField];
    
    return YES;
}
#pragma mark navigation
-(BOOL) navigationShouldPopOnBackButton{
    
    //clear the current edit pile to stop auto-property looping
    [self.pileVC removeCurrentPile];
    
    return YES;
}

- (void) calculateTotal{
    int total = [self.alPercent.text intValue] + [self.arPercent.text intValue] + [self.asPercent.text intValue] + [self.baPercent.text intValue] + [self.biPercent.text intValue] + [self.cePercent.text intValue] + [self.coPercent.text intValue] + [self.cyPercent.text intValue] + [self.fiPercent.text intValue] + [self.hePercent.text intValue] + [self.laPercent.text intValue] + [self.loPercent.text intValue] + [self.maPercent.text intValue] + [self.otPercent.text intValue] + [self.spPercent.text intValue] + [self.wbPercent.text intValue] + [self.whPercent.text intValue] + [self.wiPercent.text intValue] + [self.uuPercent.text intValue] + [self.yePercent.text intValue];
    
    self.totalField.text = [NSString stringWithFormat:@"%d", total];
}

@end
