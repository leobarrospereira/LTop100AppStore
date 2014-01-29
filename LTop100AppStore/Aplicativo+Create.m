//
//  Aplicativo+Create.m
//  LTop100AppStore
//
//  Created by Leonardo Barros on 29/01/14.
//  Copyright (c) 2014 Leonardo Barros. All rights reserved.
//

#import "Aplicativo+Create.h"

@implementation Aplicativo (Create)

+ (Aplicativo *)aplicativoComDadosAppStore:(NSDictionary *)appDictionary
                   comManagedObjectContext:(NSManagedObjectContext *)context
                                 naPosicao:(int)posicao
{
    Aplicativo *app = nil;
    
    NSString *idApp = [[[appDictionary objectForKey:@"id"] objectForKey:@"attributes"] objectForKey:@"im:id"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Aplicativo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"posicao" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"identificador = %@", idApp];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    // nil significa que ocorreu erro; mais que um seria impossível pois o id é único.
    // Não vai ocorrer pois a base de dados é apagada antes de ser populada.
    if (!result || ([result count] > 1)) {
        // tratar erro
        
    } else if (![result count]) { // não encontrou então cria o app com os dados informados.
        app = [NSEntityDescription insertNewObjectForEntityForName:@"Aplicativo" inManagedObjectContext:context];
        
        app.identificador = idApp;
        app.nome = [[appDictionary objectForKey:@"im:name"] objectForKey:@"label"];
        app.imagemURL = [[[appDictionary objectForKey:@"im:image"] objectAtIndex:0] objectForKey:@"label"];
        app.resumo = [[appDictionary objectForKey:@"summary"] objectForKey:@"label"];
        app.preco = [[appDictionary objectForKey:@"im:price"] objectForKey:@"label"];
        app.tipoConteudo = [[[appDictionary objectForKey:@"im:contentType"] objectForKey:@"attributes"] objectForKey:@"label"];
        app.direitos = [[appDictionary objectForKey:@"rights"] objectForKey:@"label"];
        app.titulo = [[appDictionary objectForKey:@"title"] objectForKey:@"label"];
        app.link = [[[appDictionary objectForKey:@"link"] objectForKey:@"attributes"] objectForKey:@"href"];
        app.desenvolvedor = [[appDictionary objectForKey:@"im:artist"] objectForKey:@"label"];
        app.categoria = [[[appDictionary objectForKey:@"category"] objectForKey:@"attributes"] objectForKey:@"label"];
        app.dataLancamento = [[[appDictionary objectForKey:@"im:releaseDate"] objectForKey:@"attributes"] objectForKey:@"label"];
        app.posicao = [[NSNumber alloc] initWithInt:posicao];
        app.posicao = [[NSNumber alloc] initWithInt:posicao];
        
    } else { // app já existe, então retorna. Não vai ocorrer pois a base de dados é apagada antes de ser populada.
        app = [result lastObject];
    }
    
    return app;
}

@end
