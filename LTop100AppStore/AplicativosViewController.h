//
//  AplicativosViewController.h
//  LTop100AppStore
//
//  Created by Leonardo Barros on 29/01/14.
//  Copyright (c) 2014 Leonardo Barros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface AplicativosViewController : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
