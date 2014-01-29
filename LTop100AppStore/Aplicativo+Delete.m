//
//  Aplicativo+Delete.m
//  LTop100AppStore
//
//  Created by Leonardo Barros on 29/01/14.
//  Copyright (c) 2014 Leonardo Barros. All rights reserved.
//

#import "Aplicativo+Delete.h"

@implementation Aplicativo (Delete)

+ (void)apagarTodosNoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Aplicativo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"posicao" ascending:YES]];
    request.predicate = nil; // trazer todos.
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    for (Aplicativo *app in result) {
        [context deleteObject:app];
    }
}

@end
