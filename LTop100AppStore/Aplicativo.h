//
//  Aplicativo.h
//  LTop100AppStore
//
//  Created by Leonardo Barros on 29/01/14.
//  Copyright (c) 2014 Leonardo Barros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Aplicativo : NSManagedObject

@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSString * imagemURL;
@property (nonatomic, retain) NSString * resumo;
@property (nonatomic, retain) NSString * preco;
@property (nonatomic, retain) NSString * tipoConteudo;
@property (nonatomic, retain) NSString * direitos;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * identificador;
@property (nonatomic, retain) NSString * desenvolvedor;
@property (nonatomic, retain) NSString * categoria;
@property (nonatomic, retain) NSString * dataLancamento;
@property (nonatomic, retain) NSNumber * posicao;

@end
