//
//  Dispositivo.m
//  TCC-Hugo
//
//  Created by Hugo Saraiva on 17/11/14.
//  Copyright (c) 2014 Saraiva. All rights reserved.
//

#import "Dispositivo.h"

@implementation Dispositivo

@synthesize identificador = _identificador, descricao = _descricao, status = _status;

-(id)initWithId:(int)ident comDescricao:(NSString *)desc comStatus:(NSString *)stat {
    _identificador = ident;
    _descricao = desc;
    _status = stat;
    return self;
}

@end
