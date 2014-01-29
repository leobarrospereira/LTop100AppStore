//
//  AplicativosViewController.m
//  LTop100AppStore
//
//  Created by Leonardo Barros on 29/01/14.
//  Copyright (c) 2014 Leonardo Barros. All rights reserved.
//

#import "AplicativosViewController.h"
#import "Aplicativo+Create.h"
#import "Aplicativo+Delete.h"


@implementation AplicativosViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Define o action do refreshControl da table view.
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self usarAplicativoDocument];
}


#pragma mark - CoreData

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Aplicativo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"posicao" ascending:YES]];
        request.predicate = nil; // trazer todos.
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

// Cria, abre ou usa o Document para o CoreData.
- (void)usarAplicativoDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"AppDocument"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success){
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
                  [self refresh];
              }
          }];
        
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
        
    } else {
        self.managedObjectContext = document.managedObjectContext;
    }

}

// Atualiza as informações do Top 100 da AppStore.
- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_queue_t buscaApp = dispatch_queue_create("Busca AppStore", NULL);
    
    dispatch_async(buscaApp, ^{
        NSString *url = @"https://itunes.apple.com/br/rss/topfreeapplications/limit=100/json";
        
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        
        NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alerta = [[ UIAlertView alloc]
                                       initWithTitle:@"Erro ao recuperar informações da AppStore. Tente novamente."
                                       message:nil
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
                [alerta show];

            });

        } else {
            [self.managedObjectContext performBlock:^{
                NSDictionary *feed = [resultado objectForKey:@"feed"];
                NSArray *apps = [feed objectForKey:@"entry"];
                int posicao = 0;
                
                // Apaga todos os dados do banco de dados para popular com os novos dados.
                [Aplicativo apagarTodosNoManagedObjectContext:self.managedObjectContext];
                
                for (NSDictionary *app in apps) {
                    posicao++;
                    [Aplicativo aplicativoComDadosAppStore:app comManagedObjectContext:self.managedObjectContext naPosicao:posicao];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.refreshControl endRefreshing];
                });
            }];
        }
    });
}


#pragma mark - TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AppCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Aplicativo *app = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%d - %@", app.posicao.intValue, app.nome];
    cell.detailTextLabel.text = app.categoria;
    
    cell.imageView.image = nil;
     
    dispatch_queue_t downloadQueue = dispatch_queue_create("download imagem", NULL);
    dispatch_async(downloadQueue, ^{
        UIImage *imagem = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:app.imagemURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = imagem;
            [cell setNeedsLayout];
        });
    });

    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"setAplicativo:"]) {
            Aplicativo *app = [self.fetchedResultsController objectAtIndexPath:indexPath];
            
            if ([segue.destinationViewController respondsToSelector:@selector(setAplicativo:)]) {
                [segue.destinationViewController performSelector:@selector(setAplicativo:) withObject:app];
            }
        }
    }
}

@end
