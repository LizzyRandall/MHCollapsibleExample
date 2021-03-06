//
//  FilterViewController.h
//  FilterSearchAttempt
//
//  Created by Lizzy Randall on 5/5/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCollapsibleViewManager.h"

@interface MHFilterViewController : UITableViewController<MHCollapibleViewManagerDelegate>

- (void)buttonTapped:(UIBarButtonItem *)sender;

//Output of implemented "saving" the filter
//Returns array of MHPackagedFilters
- (NSArray*)combinedFilter;

//filters can be an array of arrays (if hierarchy collapsing)
//headerTitles is an array of strings for those collapsing sections (non hierarchy or hierarchy)
//headerIds is an array of unique ids (can just be unique per manager)
//single/plural Identifier should be a string in a Localizeable strings file
//this represents the entity getting selected, etc. so # selected labels, items, etc.
//if one is not provided the default is items
- (void)addFilterManagerWithFilters:(NSArray*)filters
                       headerTitles:(NSArray*)headerTitles
                          headerIds:(NSArray*)headerIds
                   singleIdentifier:(NSString*)singleIdentifier
                   pluralIdentifier:(NSString*)pluralIdentifier;

//A hierarchy filter manager needs more information to identify the root entity type (surveys vs. survey questions)
//so this method takes the current manager and sets more information
//This should be called after a manager is created with the above method if
//the manager needs multiple sections collapsed
- (void)setCurrentManagerSettingsWithTopHierarchyTitle:(NSString *)topHierarchyTitle
                                  rootSingleIdentifier:(NSString *)rootSingleIdentifier
                                  rootPluralIdentifier:(NSString *)rootPluralIdentifier;

- (void)dismissCurrentModal;

- (BOOL)isModalCurrentlyShown;

//To make modals consistent in background color
- (void)setModalBackgroundColorWithColor:(UIColor *)modalBackgroundColor;

//Advanced methods to customize and rework code
//only for use based on extensive knowledge of class
- (void)selectedCellWithType:(CRUCellViewInteractionType)cellType section:(MHCollapsibleSection *)section rowPath:(NSIndexPath *)rowPath;
- (void)setStringsFileNameWithName:(NSString*)name;
- (NSString*)currentStringFileName;


@end
