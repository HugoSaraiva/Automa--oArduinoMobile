//
//  AppDelegate.h
//  TCC-Hugo
//
//  Created by Hugo Saraiva on 17/11/14.
//  Copyright (c) 2014 Saraiva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TelaDeItens.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    TelaDeItens *_telaItens;
    NSString *_ip;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSString *ip;

- (void) executarConsulta:(NSString *)caminho;
- (void) retornoDeDados:(NSMutableArray *)listaDispositivos;


@end

