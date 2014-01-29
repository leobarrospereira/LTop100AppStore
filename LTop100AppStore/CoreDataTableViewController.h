//
//  CoreDataTableViewController.h
//  LTop100AppStore
//
//  Created by Leonardo Barros on 29/01/14.
//  Copyright (c) 2014 Leonardo Barros. All rights reserved.
//
//  Essa classe é apenas uma cópia do código existente na página de documentação do NSFetchedResultsController
//      criando uma subclasse do UITableViewController. Dica obtida no curso de iOS de Stanford.
//
//  Outras classes de TableViewController podem estender essa sendo necessário apenas definir o fetchedResultsController.
//  O único método do UITableViewDataSource que precisa ser implementado é o tableView:cellForRowAtIndexPath:.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;
@property BOOL debug;

- (void)performFetch;

@end
