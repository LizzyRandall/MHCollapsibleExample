//
//  MHCollapsibleViewManager.h
//  Represents a view piece that is collapsible
//  It manages the following:
//      The header record style/accessory for clicked record
//      Showing/Hiding rows under header
//      Clicked child cell style/accessory
//      Keeps track if cell was clicked using MHFilterLabel class
//
//  Created by Lizzy Randall on 5/6/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHFilterLabel.h"
#import "MHTableViewCell.h"
#import "MHCollapsibleSection.h"
#import "MHPackagedFilter.h"

#pragma Delgate Methods

@protocol MHCollapibleViewManagerDelegate <NSObject>

@required

- (void)selectedCellWithType:(CRUCellViewInteractionType)cellType section:(MHCollapsibleSection*)section rowPath:(NSIndexPath*)rowPath;

@end

@interface MHCollapsibleViewManager : NSObject

@property (nonatomic, weak) id delegate;

//INIT METHODS

-(instancetype)init;

//Initialize Manager with animation type
- (instancetype)initManagerWithAnimation:(UITableViewRowAnimation)animation;

//SET METHODS

//Set the data for the manager
//This should be a mutable array of strings that the Manager then creates MHFilterLabel objects for
//Can be used to override a manager's array of data
- (void)setFiltersWithFilterNames:(NSArray*)filterNames headerTitles:(NSArray*)headerTitles headerIds:(NSArray*)headerIds;

//Identifier is a singleton of what are the sections, ex: label, question
//while rootText gives the root such as survey
- (void)setTextIdentifierAndIndexWithSingleIdentifier:(NSString *)singleIdentifier pluralIdentifier:(NSString*)pluralIdentifier managerIndex:(NSUInteger)managerIndex;

//If this is not set, the manager will use the sections identifier combo above
- (void)setTextIdentifierForManagerWithSingleIdentifier:(NSString *)singleIdentifier pluralIdentifier:(NSString*)pluralIdentifier;

- (void)setStringFileNameWith:(NSString *)stringFileName;

//RETURN METHODS

- (MHTableViewCell*)returnCellWithIndex:(NSIndexPath*)indexPath tableView:(UITableView*)tableView;

- (void)selectedRowAtIndexPath:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;

//Returns a mutable array of packaged filters for each filter label
//MHPackaged Filter is made up of key value pairs with a root key value pair
//if it's a hierarchy. The root shows what type the children expansions are
//for example surveys and survey questions. Each question name ex: "What is your phone number?"
//will have a value. Key value pair: Question, Answer and yes there can be exactly the same
//for the key value pair, so the same key can exist but with different values
- (NSMutableArray*)returnPackagedFilter;

- (NSString*)title;

//changes based on if manager expanded
//and if manager is hierarchy, it's included in the number
- (NSUInteger)numOfRows;

//changes based on if manager expanded
- (NSUInteger)numOfSections;

- (void)setTitleWithString:(NSString*)headerTitle;

//clears and "saves" (not as filter but not in temp results)
- (void)clearAllData;



@end
