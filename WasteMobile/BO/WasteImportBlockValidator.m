//
//  WasteImportBlockValidator.m
//  WasteMobile
//
//  Created by Jack Wong on 2017-02-08.
//  Copyright © 2017 Salus Systems. All rights reserved.
//
#include <math.h>

#import "WasteImportBlockValidator.h"

#import "WasteBlock.h"
#import "WasteStratum.h"
#import "WastePlot.h"
#import "Timbermark.h"
#import "AssessmentmethodCode.h"
#import "HarvestMethodCode.h"
#import "PlotSizeCode.h"
#import "StratumTypeCode.h"
#import "WasteLevelCode.h"
#import "WasteTypeCode.h"
#import "MaturityCode.h"
#import "SiteCode+CoreDataClass.h"
#import "Constants.h"

@implementation WasteImportBlockValidator

+(NSMutableArray *) compareBlockForImport:(WasteBlock *)wb1 wb2:(WasteBlock *)wb2{

    //reporting unit number, cut block ID, licence number and cutting permit ID should be the same
    NSMutableArray *warning = [[NSMutableArray alloc] init];
    
    //comparing Cut Block Fields
    if(wb1.yearLoggedTo && wb2.yearLoggedTo && [wb1.yearLoggedTo integerValue] != [wb2.yearLoggedTo integerValue]){
        [warning addObject:@"Cut Block Logged To"];
    }
    if(wb1.yearLoggedFrom && wb2.yearLoggedFrom && [wb1.yearLoggedFrom integerValue] != [wb2.yearLoggedFrom integerValue]){
        [warning addObject:@"Cut Block Logged From"];
    }
    if((wb1.loggingCompleteDate == nil && wb2.loggingCompleteDate != nil) || (wb1.loggingCompleteDate != nil && wb2.loggingCompleteDate == nil) || (wb1.loggingCompleteDate != nil && wb2.loggingCompleteDate != nil)){
        if(![wb1.loggingCompleteDate isEqualToDate:wb2.loggingCompleteDate]){
            [warning addObject:@"Cut Block Logging Complete Date"];
        }
    }
    if((wb1.surveyDate == nil && wb2.surveyDate != nil) || (wb1.surveyDate != nil && wb2.surveyDate == nil) || (wb1.surveyDate != nil && wb2.surveyDate != nil)){
        if(![wb1.surveyDate isEqualToDate:wb2.surveyDate]){
            [warning addObject:@"Cut Block Survey Date"];
        }
    }
    if(wb1.netArea && wb2.netArea && [wb1.netArea floatValue] != [wb2.netArea floatValue]){
        [warning addObject:@"Cut Block Net Area"];
    }
    if(wb1.surveyArea && wb2.surveyArea && (isnan([wb1.surveyArea floatValue]) ? 0.0 :[wb1.surveyArea floatValue] != [wb2.surveyArea floatValue])){
        [warning addObject:@"Cut Block Net Area"];
    }
    if((wb1.blockMaturityCode == nil && wb2.blockMaturityCode != nil) || (wb1.blockMaturityCode != nil && wb2.blockMaturityCode == nil) || (wb1.blockMaturityCode != nil && wb2.blockMaturityCode != nil)){
        if([wb1.regionId integerValue] == 1 && [wb2.regionId integerValue]== 1 && ![[wb1.blockMaturityCode.maturityCode.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:[wb2.blockMaturityCode.maturityCode.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
            [warning addObject:@"Cut Block Maturity Code"];
        }
    }
    if((wb1.blockSiteCode == nil && wb2.blockSiteCode != nil) || (wb1.blockSiteCode != nil && wb2.blockSiteCode == nil) || (wb1.blockSiteCode != nil && wb2.blockSiteCode != nil)){
        if([wb1.regionId integerValue] == 2 && [wb2.regionId integerValue]== 2 && ![[wb1.blockSiteCode.siteCode.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:[wb2.blockSiteCode.siteCode.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
            [warning addObject:@"Cut Block Site Code"];
        }
    }
    if((wb1.ratioSamplingEnabled == nil && wb2.ratioSamplingEnabled != nil) || (wb1.ratioSamplingEnabled != nil && wb2.ratioSamplingEnabled == nil) || (wb1.ratioSamplingEnabled != nil && wb2.ratioSamplingEnabled != nil)){
        if([wb1.ratioSamplingEnabled integerValue] != [wb2.ratioSamplingEnabled integerValue]){
            [warning addObject:@"Cut Block Survey Type (SRS vs Ratio Sampling)"];
        }
    }
    
    //comparing Timber Mark
    Timbermark *ptm = nil;
    Timbermark *stm = nil;
    for (Timbermark *tm in wb1.blockTimbermark ){
        if( [tm.primaryInd integerValue]== 1){
            ptm = tm;
        }else{
            stm = tm;
        }
    }
    for (Timbermark *tm in wb2.blockTimbermark ){
        if( [tm.primaryInd integerValue]== 1){
            [self ValidateTimbermark:ptm tm2:tm warning:warning prefix:@"Primary"];
        }/*else{
            [self ValidateTimbermark:stm tm2:tm warning:warning prefix:@"Secondary"];
        }*/
    }
    
    // comparing Stratum
    //BOOL found_matching_st = NO;
    for (WasteStratum *st1 in wb1.blockStratum){
        for (WasteStratum *st2 in wb2.blockStratum){
            NSString *st1_name = st1.stratum;
            NSString *st2_name = st2.stratum;
            if([st1.stratum isEqualToString:st2.stratum]){
                //found_matching_st = YES;
                [self ValidateStratum:st1 st2:st2 warning:warning stratum:st1.stratum];
            }
        }
        //if(!found_matching_st){
        //    [warning addObject:[NSString stringWithFormat:@"Stratum %@ is missing", st1.stratum]];
       // }
        //found_matching_st = NO;
    }

    return warning;
}

+(void) ValidateTimbermark:(Timbermark *)tm1 tm2:(Timbermark*)tm2 warning:(NSMutableArray*)warning prefix:(NSString*)prefix{
    if([tm1.timbermarkBlock.regionId integerValue] == CoastRegion){
        if(tm1.timbermark && tm2.timbermark && ![[tm1.timbermark.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:[tm2.timbermark.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
            [warning addObject: [NSString stringWithFormat:@"%@ %@", prefix, @"Timber Mark Name"]];
        }
    }else {
    if((tm1.timbermark  == nil && tm2.timbermark != nil) || (tm1.timbermark  != nil && tm2.timbermark == nil) || (tm1.timbermark  != nil && tm2.timbermark != nil)){
        if( ![[tm1.timbermark.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:[tm2.timbermark.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
            [warning addObject: [NSString stringWithFormat:@"%@ %@", prefix, @"Timber Mark Name"]];
        }
    }
    }
    if((tm1.area  == nil && tm2.area != nil) || (tm1.area  != nil && tm2.area == nil) || (tm1.area  != nil && tm2.area != nil)){
        if([tm1.area floatValue] != [tm2.area floatValue]){
            [warning addObject: [NSString stringWithFormat:@"%@ %@", prefix, @"Timber Mark Area"]];
        }
    }
}

+(void) ValidateStratum:(WasteStratum *)st1 st2:(WasteStratum*)st2 warning:(NSMutableArray*)warning stratum:(NSString *)stratum{
    if((st1.stratumWasteTypeCode  == nil && st2.stratumWasteTypeCode != nil) || (st1.stratumWasteTypeCode  != nil && st2.stratumWasteTypeCode == nil) || (st1.stratumWasteTypeCode  != nil && st2.stratumWasteTypeCode != nil)){
        if(![[st1.stratumWasteTypeCode.wasteTypeCode.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:[st2.stratumWasteTypeCode.wasteTypeCode.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
            [warning addObject:[NSString stringWithFormat:@"Stratum (%@) %@", stratum, @"Waste Type Code"]];
        }
    }
    if((st1.stratumHarvestMethodCode  == nil && st2.stratumHarvestMethodCode != nil) || (st1.stratumHarvestMethodCode  != nil && st2.stratumHarvestMethodCode == nil) || (st1.stratumHarvestMethodCode  != nil && st2.stratumHarvestMethodCode != nil)){
        if(![[st1.stratumHarvestMethodCode.harvestMethodCode.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:[st2.stratumHarvestMethodCode.harvestMethodCode.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
            [warning addObject: [NSString stringWithFormat:@"Stratum (%@) %@", stratum, @"Harvest Method Code"]];
        }
    }
    if((st1.stratumAssessmentMethodCode  == nil && st2.stratumAssessmentMethodCode != nil) || (st1.stratumAssessmentMethodCode  != nil && st2.stratumAssessmentMethodCode == nil) || (st1.stratumAssessmentMethodCode  != nil && st2.stratumAssessmentMethodCode != nil)){
        if(![[st1.stratumAssessmentMethodCode.assessmentMethodCode.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:[st2.stratumAssessmentMethodCode.assessmentMethodCode.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
            [warning addObject: [NSString stringWithFormat:@"Stratum (%@) %@", stratum, @"Assessment Method Code"]];
        }
    }
    if((st1.stratumWasteLevelCode  == nil && st2.stratumWasteLevelCode != nil) || (st1.stratumWasteLevelCode  != nil && st2.stratumWasteLevelCode == nil) || (st1.stratumWasteLevelCode  != nil && st2.stratumWasteLevelCode != nil)){
        if(![[st1.stratumWasteLevelCode.wasteLevelCode.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:[st2.stratumWasteLevelCode.wasteLevelCode.lowercaseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]){
            [warning addObject: [NSString stringWithFormat:@"Stratum (%@) %@", stratum, @"Waste Level Code"]];
        }
    }
    if((st1.stratumSurveyArea == nil && st2.stratumSurveyArea != nil) || (st1.stratumSurveyArea != nil && st2.stratumSurveyArea == nil) || (st1.stratumSurveyArea != nil && st2.stratumSurveyArea != nil)){
        if([st1.stratumSurveyArea floatValue] != [st2.stratumSurveyArea floatValue]){
            [warning addObject: [NSString stringWithFormat:@"Stratum (%@) %@", stratum, @"Area"]];
        }
    }
    if((st1.measurePlot == nil && st2.measurePlot != nil) || (st1.measurePlot != nil && st2.measurePlot == nil) || (st1.measurePlot != nil && st2.measurePlot != nil)){
        if([st1.measurePlot integerValue] != [st2.measurePlot integerValue]){
            [warning addObject: [NSString stringWithFormat:@"Stratum (%@) %@", stratum, @"Measure Plot"]];
        }
    }
    if((st1.predictionPlot == nil && st2.predictionPlot != nil) || (st1.predictionPlot != nil && st2.predictionPlot == nil) || (st1.predictionPlot != nil && st2.predictionPlot != nil)){
        if([st1.predictionPlot integerValue] != [st2.predictionPlot integerValue]){
            [warning addObject: [NSString stringWithFormat:@"Stratum (%@) %@", stratum, @"Prediction Plot"]];
        }
    }

    for(WastePlot* plot_st1 in st1.stratumPlot){
        for(WastePlot* plot_st2 in st2.stratumPlot){
            if([plot_st1.plotNumber integerValue] == [plot_st2.plotNumber integerValue]){
                [warning addObject: [NSString stringWithFormat:@"Stratum (%@) has duplicate plot %@", stratum, plot_st1.plotNumber]];
                break;
            }
        }
    }
}
@end
