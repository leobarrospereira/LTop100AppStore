//
//  Aplicativo+Create.h
//  LTop100AppStore
//
//  Created by Leonardo Barros on 29/01/14.
//  Copyright (c) 2014 Leonardo Barros. All rights reserved.
//

#import "Aplicativo.h"

@interface Aplicativo (Create)

+ (Aplicativo *)aplicativoComDadosAppStore:(NSDictionary *)appDictionary
                   comManagedObjectContext:(NSManagedObjectContext *)context
                                 naPosicao:(int)posicao;

@end
