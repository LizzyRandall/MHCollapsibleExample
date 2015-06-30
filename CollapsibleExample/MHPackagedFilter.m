//
//  MHPackagedFilter.m
//  CollapsibleExample
//
//  Created by Lizzy Randall on 6/10/15.
//  Copyright (c) 2015 Lizzy Randall. All rights reserved.
//

#import "MHPackagedFilter.h"

@interface MHPackagedFilter()

@property (nonatomic, strong) NSMutableArray *filterKeyValuePairs;
@property (nonatomic, strong) NSString *stringId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL hierarchy;

@end

@implementation MHPackagedFilter

- (instancetype)initWithRootKey:(NSString*)rootKey rootValue:(NSString*)rootValue hierarchy:(BOOL)hierarchy{
    
    self = [self initWithKey:rootKey value:rootValue];
    self.filterKeyValuePairs = [[NSMutableArray alloc] init];
    self.hierarchy = hierarchy;
    
    return self;
}

- (void)setuniqueIdWithId:(NSString*)uniqueId name:(NSString*)name{
    
    self.stringId = uniqueId;
    self.name = name;
}

- (void)addFilterWithKey:(NSString*)key value:(NSString*)value{
    
    MHKeyValuePair *keyValue = [[MHKeyValuePair alloc] initWithKey:key value:value];
    [self.filterKeyValuePairs addObject:keyValue];
    keyValue = nil;
    
}

- (NSString*)returnValueAtIndex:(NSUInteger)index{
    
    MHKeyValuePair *keyValue = self.filterKeyValuePairs[index];
    NSString *value = keyValue.returnValue;
    keyValue = nil;
    return value;
}

- (NSString*)returnKeyAtIndex:(NSUInteger)index{
    
    MHKeyValuePair *keyValue = self.filterKeyValuePairs[index];
    NSString *key = keyValue.returnKey;
    keyValue = nil;
    return key;
}

- (BOOL)containsFilterKeyValues{
    
    BOOL ifRecordsExist = NO;
    
    if(self.filterKeyValuePairs.count > 0){
        
        ifRecordsExist = YES;
    }
    return ifRecordsExist;
}

- (NSString*)filterId{
    
    return self.stringId;
}

- (NSString*)filterName{
    
    return self.name;
}

- (NSUInteger)numberOfRows{
    
    return self.filterKeyValuePairs.count;
}

@end
