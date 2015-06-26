//
//  FilterViewController.m
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "MHFilterViewController.h"

@interface MHFilterViewController()

@property (strong, nonatomic) NSMutableArray *managerArray;
//Keeping track of the current section gives the ability to get data
//and invoke actions from the filterviewcontroller
@property (strong, nonatomic) MHCollapsibleSection *currentSection;
@property (nonatomic) CRUCellViewInteractionType currentModalType;
@property (nonatomic) NSIndexPath *currentRowPath;
@property (nonatomic) NSUInteger currentSubViewControllerIndex;
//Checked for Clear button since it appears on modals as well
@property (nonatomic) BOOL modalCurrentlyShown;
//After save button, this array is populated with MHPakcgaedFilter records
//returned by each MHCollapsibleViewManager
@property (nonatomic, strong) NSMutableArray *combinedFilters;
@property (nonatomic) NSUInteger managerCount;
@property (nonatomic) UIColor *modalBackgroundColor;
@property (nonatomic, strong) NSString *stringsFileName;

//Modal interaction methods
- (void)resignFirstResponderWithClearOption:(BOOL)clear;

//Modal settings
- (void)setButtonsAndColorWithController:(UIViewController*)viewController bgColor:(UIColor*)bgColor
                                  cancel:(UIBarButtonItem*)cancel save:(UIBarButtonItem*)save clear:(UIBarButtonItem*)clear;

//Handles clear, save and cancel for modals
- (void)saveChangesForCurrentSection;
- (void)cancelChangesForCurrentSection;
- (void)clearChangesForCurrentSection;

//Creating pieces for modals
- (void)setLabelSettingsWithLabel:(UILabel*)label section:(MHCollapsibleSection*)section rowPath:(NSIndexPath*)rowPath cgSize:(CGSize)size;
- (void)setTextFieldSettingsWithField: (UITextField*)textField section:(MHCollapsibleSection*)section cgSize:(CGSize)size yPosition:(NSUInteger)yPosition;

- (NSUInteger)yPositionForTextFieldBasedOnLabel:(UILabel*)label;

//Tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MHFilterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.combinedFilters = [[NSMutableArray alloc] init];
    self.managerArray = [[NSMutableArray alloc] init];
    self.managerCount = 0;
    [self setModalBackgroundColorWithColor:self.tableView.backgroundColor];
    self.stringsFileName = @"MHCollapsibleManagerStrings";
}

#pragma Manager Data

- (void)addFilterManagerWithFilters:(NSArray*)filters
                       headerTitles:(NSArray*)headerTitles
                   singleIdentifier:(NSString*)singleIdentifier
                   pluralIdentifier:(NSString*)pluralIdentifier{
    
    MHCollapsibleViewManager *simpleManager = [[MHCollapsibleViewManager alloc] initManagerWithAnimation:UITableViewRowAnimationMiddle];
    [simpleManager setFiltersWithFilterNames:filters headerTitles:headerTitles];
    [simpleManager setTextIdentifierAndIndexWithSingleIdentifier:singleIdentifier pluralIdentifier:pluralIdentifier managerIndex:self.managerCount];
    simpleManager.delegate = self;
    self.managerCount++;
    [self.managerArray addObject:simpleManager];
}


- (void)setCurrentManagerSettingsWithTopHierarchyTitle:(NSString *)topHierarchyTitle
                                  rootSingleIdentifier:(NSString *)rootSingleIdentifier
                                  rootPluralIdentifier:(NSString *)rootPluralIdentifier{
    
    MHCollapsibleViewManager *complexManager = self.managerArray[self.managerCount-1];//offset 1 for index
    [complexManager setTextIdentifierForManagerWithSingleIdentifier:rootSingleIdentifier pluralIdentifier:rootPluralIdentifier];
    [complexManager setTitleWithString:topHierarchyTitle];
    
}

- (void)setModalBackgroundColorWithColor:(UIColor *)modalBackgroundColor{
    
    self.modalBackgroundColor = modalBackgroundColor;
}

- (void)setStringsFileNameWithName:(NSString*)name{
    
    self.stringsFileName = name;
}

#pragma  Button Interaction for Modals
//Save and Cancel are actually on the temporary modals
//While the save and cancel checked here are on the filterviewcontroller itself
- (IBAction)buttonTapped:(UIBarButtonItem*)sender{
    
    
    NSString *saveString = NSLocalizedStringFromTable(@"MHCollapsibleViewManager_Interaction_Button_defaultSave", self.stringsFileName, nil);
    NSString *cancelString = NSLocalizedStringFromTable(@"MHCollapsibleViewManager_Interaction_Button_defaultCancel", self.stringsFileName, nil);
    NSString *clearString = NSLocalizedStringFromTable(@"MHCollapsibleViewManager_Interaction_Button_defaultClear", self.stringsFileName, nil);
    
    if([sender.title isEqualToString: clearString]){
        
        if(self.modalCurrentlyShown){
            //clear just shown on modal, the temp storage
            //is cleared with this method
            [self clearChangesForCurrentSection];
        }
        else{
            
            //This is a hard clear in a sense all labels and their results (not temp results) will get cleared
            [self.managerArray enumerateObjectsUsingBlock:^(MHCollapsibleViewManager *manager, NSUInteger index, BOOL *stop){
                [manager clearAllData];
            }];
            //reload the entire table since multiple managers
            //could have been affected by the clear
            [self.tableView reloadData];
        }
    }
    else if ([sender.title isEqualToString: saveString] && !self.modalCurrentlyShown){
        
        //Loop through the managers and get a MHPackagedFilter for each
        //these are concatonated. MHPackagedFilter contains key/value pairs and can have a hierarchy
        //depending if the manager had to create multiple sections
        [self.managerArray enumerateObjectsUsingBlock:^(MHCollapsibleViewManager *manager, NSUInteger index, BOOL *stop){
            NSMutableArray *filter = manager.returnPackagedFilter;
            if(filter != nil){
                [self.combinedFilters addObjectsFromArray:filter];
            }
        }];
        
        //Now the data is stored in an array of MHPackagedFilters, with key/value pairs
        //They can be parsed and packaged to whatever API needs to be called
        //For a subclass, just call super on this class and then handle the combinedFilters array accordingly
        
    }
    else if([sender.title isEqualToString:cancelString] && !self.modalCurrentlyShown){
        
        //dismiss modal, nothing needs to be sent to the search view controller or wherever the filter gets sent
        self.presentedViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)isModalCurrentlyShown{
    
    return self.modalCurrentlyShown;
}

#pragma Manager Delegate
//Handles creation of modal or pretend half modal that shows the type of uiview applicable
- (void)selectedCellWithType:(CRUCellViewInteractionType)cellType section:(MHCollapsibleSection *)section rowPath:(NSIndexPath *)rowPath{
    
    self.currentSection = section;
    self.currentModalType = cellType;
    self.currentRowPath = rowPath;
    self.modalCurrentlyShown = YES;
    
    //so the modal will take up the entire screen properly
    [self.tableView setBounces:NO];
    self.tableView.scrollEnabled = NO;
    
    NSString *saveString = NSLocalizedStringFromTable(@"MHCollapsibleViewManager_Interaction_Button_defaultSave", self.stringsFileName, nil);
    NSString *cancelString = NSLocalizedStringFromTable(@"MHCollapsibleViewManager_Interaction_Button_defaultCancel", self.stringsFileName, nil);
    NSString *clearString = NSLocalizedStringFromTable(@"MHCollapsibleViewManager_Interaction_Button_defaultClear", self.stringsFileName, nil);
    
    //Not all will need these buttons but most will have them in common
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:saveString
                                                            style:UIBarButtonItemStylePlain target:self action:@selector(saveChangesForCurrentSection)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:cancelString
                                                               style:UIBarButtonItemStylePlain target:self action:@selector(cancelChangesForCurrentSection)];
    
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:clearString
                                                               style:UIBarButtonItemStylePlain target:self action:@selector(clearChangesForCurrentSection)];
    
    switch (cellType) {
            
        case CRUCellViewInteractionCheckList:{
            
            UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            //section will delegate displaying cell selects, etc.
            //and what data will be shown
            tableViewController.tableView.delegate = section;
            tableViewController.tableView.dataSource = section;
            
            //tableviewcontroller has save, cancel and clear buttons
            [self setButtonsAndColorWithController:(UIViewController*)tableViewController bgColor:nil cancel:cancel save:save clear:clear];

            //navigation controller for handling the back/forth of the modal
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
            //do not call setSettingsforNav since this won't be a half view
            navigationController.toolbarHidden = NO;
            [self presentViewController:navigationController animated:YES completion:nil];
            
            navigationController = nil;
            tableViewController = nil;
            break;
        }
            
        case CRUCellViewInteractionPicker:{
            
            UIPickerView *picker = [[UIPickerView alloc] init];
            picker.backgroundColor = [UIColor whiteColor];
            picker.delegate = section;
            picker.dataSource = section;
            
            UIViewController *pickerViewController = [[UIViewController alloc] init];
            [self setButtonsAndColorWithController:pickerViewController bgColor:nil cancel:cancel save:save clear:clear];
            [pickerViewController.view addSubview:picker];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pickerViewController];
            navigationController.toolbarHidden = NO;
            [self presentViewController:navigationController animated:YES completion:nil];
            //keep the previously selected row in context so the user can see what they put before
            [picker selectRow:section.getCurrentFocusForPicker inComponent:0 animated:YES];

            navigationController = nil;
            pickerViewController = nil;
            break;
        }
            
        case CRUCellViewInteractionTextBox:{
            
            UILabel *descriptionText = [[UILabel alloc] init];
            [self setLabelSettingsWithLabel:descriptionText section:section rowPath:rowPath cgSize:self.view.frame.size];
            
            NSUInteger yPositionForTextField = [self yPositionForTextFieldBasedOnLabel:descriptionText];
            //the textfield should be below the label, no matter how big the label is and 10 above is for padding
            UITextField *textField = [[UITextField alloc]init];
            [self setTextFieldSettingsWithField:textField section:section cgSize:self.view.frame.size yPosition:yPositionForTextField];
            textField.backgroundColor = [UIColor whiteColor];
            
            UIViewController *textAreaController = [[UIViewController alloc] init];
            [self setButtonsAndColorWithController:textAreaController bgColor:nil cancel:cancel save:save clear:clear];
            
            [textAreaController.view addSubview:descriptionText];
            [textAreaController.view addSubview:textField];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:textAreaController];
            navigationController.toolbarHidden = NO;
            [self presentViewController:navigationController animated:YES completion:nil];
            
            //Notification is for half modals to orientate properly if device is rotated during the modal being shown
            [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
            
            navigationController = nil;
            textAreaController = nil;
            break;
        }
            
        default:
            break;
    }
    
}

//Used by each modal type to set buttons and the default color
//Not all of them will need each of them set, hence the check for nil on each
- (void)setButtonsAndColorWithController:(UIViewController*)viewController bgColor:(UIColor*)bgColor
                                  cancel:(UIBarButtonItem*)cancel save:(UIBarButtonItem*)save clear:(UIBarButtonItem*)clear{
    
    if(save != nil){
        viewController.navigationItem.rightBarButtonItem = save;
    }
    if(cancel != nil){
        viewController.navigationItem.leftBarButtonItem = cancel;
    }
    if(clear != nil){
        [viewController setToolbarItems:@[clear]];
    }
    if(bgColor != nil){
        viewController.view.backgroundColor = bgColor;
    }
    else{
        viewController.view.backgroundColor = self.modalBackgroundColor;
    }
}

//Creates a UILabel for the actual label selected since the modal could cover up that selection
//and the user doesn't have to remember which one they selected this way
- (void)setLabelSettingsWithLabel:(UILabel*)label section:(MHCollapsibleSection*)section rowPath:(NSIndexPath*)rowPath cgSize:(CGSize)size{
    
    NSUInteger height = size.height;
    NSUInteger width = size.width;
    
    NSString *labelText = [section returnLabelNameAtRow:rowPath.row];
   CGRect labelFrame = CGRectMake(width/22, height/6, width-width/15, height/10);
    
    label.text = labelText;
    label.frame = labelFrame;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 8.0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [label sizeToFit];
}


//Creates a textfield for the user to enter their filter label
- (void)setTextFieldSettingsWithField: (UITextField*)textField section:(MHCollapsibleSection*)section cgSize:(CGSize)size yPosition:(NSUInteger)yPosition{
    
    NSUInteger height = size.height;
    NSUInteger width = size.width;
    
    NSString *previousText = section.getTextForTextArea;
    
    if([previousText isEqualToString:@""] || previousText == nil){
        textField.placeholder = section.getPlaceHolderText;
    }
    else{
        textField.text = previousText;
    }
    
    textField.frame = CGRectMake(width/22, yPosition, width - width/15, height/15);
    textField.borderStyle = UITextBorderStyleLine;
    textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textField.delegate = section;
    textField.returnKeyType = UIReturnKeyDone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.keyboardType = UIKeyboardAppearanceDefault;
    //important to give responder
    [textField becomeFirstResponder];
}


- (NSUInteger)yPositionForTextFieldBasedOnLabel:(UILabel*)label{
    
    return label.frame.size.height + label.frame.origin.y + 10;
}
//Saves the changes made by the user and handles refreshing
//so the user can see the results on the filter label of what they selected
- (void)saveChangesForCurrentSection{
    
    [self.tableView setBounces:YES];
    self.tableView.scrollEnabled = YES;
    
    if(self.currentModalType == CRUCellViewInteractionTextBox){
        
        [self resignFirstResponderWithClearOption:NO];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    //section keeps changes
    [self.currentSection saveChanges];
    
    self.modalCurrentlyShown = NO;
    //Reload the modal row to show results
    [self.tableView reloadRowsAtIndexPaths:@[self.currentRowPath] withRowAnimation:UITableViewRowAnimationNone];
    //Reload the header row of that modal so it's counter for # of selected items changes
    NSIndexPath *rootPath = [NSIndexPath indexPathForRow:self.currentSection.headerRowNum inSection:self.currentSection.returnManagerIndex];
    [self.tableView reloadRowsAtIndexPaths:@[rootPath] withRowAnimation:UITableViewRowAnimationNone];
    //manager header row num is always 0, reload this just in case it's a newly selected item for # change text
    rootPath = [NSIndexPath indexPathForRow:0 inSection:self.currentSection.returnManagerIndex];
    [self.tableView reloadRowsAtIndexPaths:@[rootPath] withRowAnimation:UITableViewRowAnimationNone];
    rootPath = nil;
    [self dismissCurrentModal];
}

//Dismisses the half modal or full modal
//Resets the temp data stored in the label so that the changes are not kept
- (void)cancelChangesForCurrentSection{
    
    [self.tableView setBounces:YES];
    self.tableView.scrollEnabled = YES;
    
    if(self.currentModalType == CRUCellViewInteractionTextBox){
        
        [self resignFirstResponderWithClearOption:NO];
        //remove observing for device orientation
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    [self.currentSection cancelChanges];
    [self dismissCurrentModal];
    
    self.modalCurrentlyShown = NO;
}

//Clears the temp data so that a clear isn't saved, the user will need to hit save
//after clearing to make the clear permanent
- (void)clearChangesForCurrentSection{
    
    [self.currentSection clearSelections];
    
    if(self.currentModalType == CRUCellViewInteractionCheckList){
        
        UINavigationController *navigationController = (UINavigationController*)self.presentedViewController;
        UITableViewController *tableViewController = (UITableViewController*)navigationController.topViewController;
        //since the checkmarks have been cleared, reload the table to show the clear affect
        [tableViewController.tableView reloadData];
        tableViewController = nil;
        navigationController = nil;
    }
    else if(self.currentModalType == CRUCellViewInteractionPicker){
        
        //currentSubViewControllerIndex set as 0 by default in viewdidload
        UINavigationController *navigationController = (UINavigationController*)self.presentedViewController;
        UIViewController *pickerViewController = navigationController.topViewController;
        
        [pickerViewController.view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger index, BOOL *stop){
            
            if([view isKindOfClass:[UIPickerView class]]){
                
                UIPickerView *pickView = (UIPickerView*)view;
                [pickView selectRow:self.currentSection.getCurrentFocusForPicker inComponent:0 animated:YES];
            }
        }];
    }
    else if(self.currentModalType == CRUCellViewInteractionTextBox){
        
        [self resignFirstResponderWithClearOption:YES];
    }
    self.modalCurrentlyShown = NO;
}

//Subclass can override to change transition style
- (void)dismissCurrentModal{
    
    //remove the modal view controller
    self.presentedViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Resigns the keyboard so the save/cancel buttons can take control after
- (void)resignFirstResponderWithClearOption:(BOOL)clear{
    
    //currentSubViewControllerIndex set 0 default in viewdidload
    UINavigationController *navigationController = (UINavigationController*)self.presentedViewController;
    UIViewController *textFieldViewController = navigationController.topViewController;
    
    [textFieldViewController.view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger index, BOOL *stop){
        
        if([view isKindOfClass:[UITextField class]]){
            
            UITextField *textField = (UITextField*)view;
            
            if(clear){
                textField.text = @"";
            }
            [textField resignFirstResponder];
        }
    }];
    
}

//The orientation changing is handled by the tableviewcontroller modal but for the uiviewcontroller
//with the text field/label, the text field and label need to adjust to the rotation
//so the sub views are traversed and the label settings are reset
- (void)orientationChanged:(NSNotification *)notification{
    
    if(self.modalCurrentlyShown && self.currentModalType == CRUCellViewInteractionTextBox){
        
        UINavigationController *navigationController = (UINavigationController*)self.presentedViewController;
        UIViewController *textFieldController = navigationController.topViewController;
        
        __block NSUInteger yPositionBasedOnLabelLocation = 0;
        
        [textFieldController.view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger index, BOOL *stop){
            
            if([view isKindOfClass:[UILabel class]]){
                
                UILabel *label = (UILabel*)view;
                
                [self setLabelSettingsWithLabel:label section: self.currentSection rowPath:self.currentRowPath cgSize:navigationController.view.frame.size];
                yPositionBasedOnLabelLocation = [self yPositionForTextFieldBasedOnLabel:label];
                
            }
            else if([view isKindOfClass:[UITextField class]]){
                
                UITextField *textField = (UITextField*)view;
                [self setTextFieldSettingsWithField:textField section:self.currentSection cgSize:navigationController.view.frame.size yPosition:yPositionBasedOnLabelLocation];
            }
          
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Return the number of rows in the section.
    MHCollapsibleViewManager *manager = [self.managerArray objectAtIndex:section];
    //There will at least be one because of the header
    NSUInteger numOfRows = (NSInteger) manager.numOfRows;
    manager = nil;
    return numOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //managerArray per section
   return [self.managerArray count];
}

//If the filterview is subclassed, the MHTableViewCell can be returned instead
//and the defaults set for the look of the cell can be overwritten by the controller
//They will still be set by the manager as default but customization is still possible
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //temp manager to get create and return cell
    MHCollapsibleViewManager *manager = [self.managerArray objectAtIndex:indexPath.section];
    //returnCellWithIndex handles the look of a header cell, modal cell (> indicator) and checktoggle
    //to customize look, a subclassed controller could get the MHTableViewCell instead of casting it
    //and then modify the defaults from there with setDefaults and setClicked
    UITableViewCell * cell = (UITableViewCell*)[manager returnCellWithIndex:indexPath tableView:tableView];
    manager = nil;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHCollapsibleViewManager *manager = [self.managerArray objectAtIndex:indexPath.section];
    //manager handles look and keeping track if whatever cell has been selected
    [manager selectedRowAtIndexPath:tableView indexPath:indexPath];
    
    //Fix ios 7 bug via stackoverflow:
    //http://stackoverflow.com/questions/19212476/uitableview-separator-line-disappears-when-selecting-cells-in-ios7
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    manager = nil;
}


@end
