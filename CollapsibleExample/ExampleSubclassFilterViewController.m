//
//  ExampleSubclassFilterViewController.m
//  CollapsibleExample
//
//  Created by Lizzy Randall on 6/12/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "ExampleSubclassFilterViewController.h"

@interface ExampleSubclassFilterViewController ()

- (NSArray*)labels;
- (NSArray*)surveys;
- (NSArray*)interactions;
- (void)printFilterWithArray:(NSArray*)filterArray;

@end

@implementation ExampleSubclassFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createManagersAndPopulateData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createManagersAndPopulateData{
    
    
    NSString *label = NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_label_single", @"ExampleStringsFile", nil);
    NSString *labels = NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_label_plural", @"ExampleStringsFile", nil);
    [self addFilterManagerWithFilters:self.labels headerTitles:@[@"Labels"] headerIds:@[@"0"] singleIdentifier:label pluralIdentifier:labels];
    
    NSString *surveyQuestion = NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_survey_question_single", @"ExampleStringsFile", nil);
    NSString *surveyQuestions = NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_survey_question_plural", @"ExampleStringsFile", nil);
    
    NSString *survey = NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_survey_single", @"ExampleStringsFile", nil);
    NSString *surveys = NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_survey_plural", @"ExampleStringsFile", nil);
    
    [self addFilterManagerWithFilters:self.surveys
                         headerTitles:@[@"Bridges Guestbook", @"International Students", @"Engels Scale"]
                            headerIds:@[@"0", @"1", @"2"]
                     singleIdentifier:surveyQuestion
                     pluralIdentifier:surveyQuestions];
    
    [self setCurrentManagerSettingsWithTopHierarchyTitle:@"Surveys" rootSingleIdentifier:survey rootPluralIdentifier:surveys];


    NSString *interaction = NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_interaction_single", @"ExampleStringsFile", nil);
    NSString *interactions = NSLocalizedStringFromTable(@"MHFilterViewController_Interaction_CellHeader_interaction_plural", @"ExampleStringsFile", nil);
    
    [self addFilterManagerWithFilters:self.interactions headerTitles:@[@"Interactions"] headerIds:@[@"0"] singleIdentifier:interaction pluralIdentifier:interactions];

}

- (NSArray*)labels{
    
    MHFilterLabel *label1 = [[MHFilterLabel alloc] initLabelWithName:@"Freshman" uniqueId:@"0" checked:NO interactionType:CRUCellViewInteractionCheckToggle];
    MHFilterLabel *label2 = [[MHFilterLabel alloc] initLabelWithName:@"Sophomore" uniqueId:@"1" checked:NO interactionType:CRUCellViewInteractionCheckToggle];
    MHFilterLabel *label3 = [[MHFilterLabel alloc] initLabelWithName:@"Junior" uniqueId:@"2" checked:NO interactionType:CRUCellViewInteractionCheckToggle];
    MHFilterLabel *label4 = [[MHFilterLabel alloc] initLabelWithName:@"Senior" uniqueId:@"3" checked:NO interactionType:CRUCellViewInteractionCheckToggle];
    
    return @[label1, label2, label3, label4];
}

- (NSArray*)surveys{
    
    MHFilterLabel *label1 = [[MHFilterLabel alloc] initLabelWithName:@"How long have you been in America?" uniqueId:@"0" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [label1 setResultsWithKeyArray:@[@"Less than 6 months", @"1-2 years", @"2+ years"] resultValues:@[@NO, @NO, @NO]];
    MHFilterLabel *label2 = [[MHFilterLabel alloc] initLabelWithName:@"What is your phone number?" uniqueId:@"1" checked:NO interactionType:CRUCellViewInteractionTextBox];
    MHFilterLabel *label3 = [[MHFilterLabel alloc] initLabelWithName:@"Would you like to find more about the Bible and Jesus Christ?" uniqueId:@"2" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [label3 setResultsWithKeyArray:@[@"Yes", @"No", @"No response"] resultValues:@[@NO, @NO, @NO]];
    MHFilterLabel *label4 = [[MHFilterLabel alloc] initLabelWithName:@"What church do you go to?" uniqueId:@"2" checked:NO interactionType:CRUCellViewInteractionTextBox];
    
    NSArray *surveyArray1 = @[label1, label2, label3, label4];
    
    MHFilterLabel *label5 = [[MHFilterLabel alloc] initLabelWithName:@"What is your age?" uniqueId:@"3" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [label5 setResultsWithKeyArray:@[@"5-10 years old", @"10-15 years old", @"15-20 years old", @"25+ years old"] resultValues:@[@NO, @NO, @NO, @NO]];
    MHFilterLabel *label6 = [[MHFilterLabel alloc] initLabelWithName:@"What is your favorite snack?" uniqueId:@"4" checked:NO interactionType:CRUCellViewInteractionTextBox];
    MHFilterLabel *label7 = [[MHFilterLabel alloc] initLabelWithName:@"Where would say you are spiritually?" uniqueId:@"5" checked:NO interactionType:CRUCellViewInteractionCheckList];
    [label7 setResultsWithKeyArray:@[@"Seeking truth", @"Believer in Christ", @"Not interested"] resultValues:@[@NO, @NO, @NO]];
    MHFilterLabel *label8 = [[MHFilterLabel alloc] initLabelWithName:@"In your opinion, who is Jesus?" uniqueId:@"6" checked:NO interactionType:CRUCellViewInteractionTextBox];
    
    NSArray *surveyArray2 = @[label5, label6, label7, label8];
    
    MHFilterLabel *label9 = [[MHFilterLabel alloc] initLabelWithName:@"Engel's scale" uniqueId:@"7"checked:NO interactionType:CRUCellViewInteractionCheckList];
    [label9 setResultsWithKeyArray:@[@"don't know", @"-8 - no effective knowldge of Christianity", @"-7 - initial awareness of Christianity", @"-6 - interest in Christianity", @"-5 - aware of basic facts of the gospel", @"-4 - positive attitude toward the gospel", @"-3 - awareness of personal need", @"-2 - challenge and decision to act", @"-1 -repentance of faith", @"0 - CONVERSION", @"+1 new Christian", @"+2 - growing disciple", @"+3 - ministering disciple", @"+4 - multiplying disciple", @"No Response"] resultValues:@[@NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO, @NO]];
    
    NSArray *surveyArray3 = @[label9];
    
    return @[surveyArray1, surveyArray2, surveyArray3];
}

- (NSArray*)interactions{
    
    MHFilterLabel *label1 = [[MHFilterLabel alloc] initLabelWithName:@"Faculty on Mission" uniqueId:@"0" checked:NO interactionType:CRUCellViewInteractionCheckToggle];
    MHFilterLabel *label2 = [[MHFilterLabel alloc] initLabelWithName:@"Personal Evangelism" uniqueId:@"1" checked:NO interactionType:CRUCellViewInteractionCheckToggle];
    MHFilterLabel *label3 = [[MHFilterLabel alloc] initLabelWithName:@"Holy Spirit Presentation" uniqueId:@"2"checked:NO interactionType:CRUCellViewInteractionCheckToggle];
    MHFilterLabel *label4 = [[MHFilterLabel alloc] initLabelWithName:@"Comment" uniqueId:@"3" checked:NO interactionType:CRUCellViewInteractionCheckToggle];
    
    return @[label1, label2, label3, label4];
}

- (void)buttonTapped:(UIBarButtonItem *)sender{
    
    [super buttonTapped:sender];
    
    NSString *saveString = NSLocalizedStringFromTable(@"MHCollapsibleViewManager_Interaction_Button_defaultSave", self.currentStringFileName, nil);

    if(!self.isModalCurrentlyShown && [sender.title isEqualToString:saveString]){
        
        NSArray *filters = self.combinedFilter;
        [self printFilterWithArray:filters];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)printFilterWithArray:(NSArray*)filterArray{
    
    [filterArray enumerateObjectsUsingBlock:^(MHPackagedFilter *filter, NSUInteger index, BOOL *stop){
        
        NSLog(@"FilterId:%@ FilterName:%@", filter.filterId, filter.filterName);
        
        NSLog(@"Filter Key:%@ Filter Value:%@", filter.returnKey, filter.returnValue);
        
        for(int keyvalue=0; keyvalue < filter.numberOfRows; keyvalue++){
            
            NSLog(@"Index: %d Key:%@ Value:%@", keyvalue, [filter returnKeyAtIndex:keyvalue], [filter returnValueAtIndex:keyvalue]);
        }
        
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
