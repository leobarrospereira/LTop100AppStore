//
//  DetalhesAplicativoViewController.m
//  LTop100AppStore
//
//  Created by Leonardo Barros on 29/01/14.
//  Copyright (c) 2014 Leonardo Barros. All rights reserved.
//

#import "DetalhesAplicativoViewController.h"

@interface DetalhesAplicativoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconeImageView;
@property (weak, nonatomic) IBOutlet UILabel *nomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *desenvolvedorLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriaLabel;
@property (weak, nonatomic) IBOutlet UITextView *descricaoTextView;

@end

@implementation DetalhesAplicativoViewController

- (void)setAplicativo:(Aplicativo *)aplicativo
{
    _aplicativo = aplicativo;
    self.title = [NSString stringWithFormat:@"%d - %@", self.aplicativo.posicao.intValue, self.aplicativo.nome];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self atualizaDetalhesAplicativo];
}

- (void)atualizaDetalhesAplicativo
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("download imagem", NULL);
    dispatch_async(downloadQueue, ^{
        UIImage *imagem = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.aplicativo.imagemURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iconeImageView.image = imagem;
            [self.iconeImageView setNeedsLayout];
        });
    });
    
    self.nomeLabel.text = self.aplicativo.nome;
    self.desenvolvedorLabel.text = self.aplicativo.desenvolvedor;
    self.categoriaLabel.text = self.aplicativo.categoria;
    self.descricaoTextView.text = self.aplicativo.resumo;
}

@end
