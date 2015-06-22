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

- (void)addFilterManagerWithFilters:(NSArray*)filters
                       headerTitles:(NSArray*)headerTitles
                   singleIdentifier:(NSString*)singleIdentifier
                   pluralIdentifier:(NSString*)pluralIdentifier;

- (void)setCurrentManagerSettingsWithTopHierarchyTitle:(NSString *)topHierarchyTitle
                                  rootSingleIdentifier:(NSString *)rootSingleIdentifier
                                  rootPluralIdentifier:(NSString *)rootPluralIdentifier;

- (BOOL)isModalCurrentlyShown;

- (void)dismissCurrentModal;

@end
