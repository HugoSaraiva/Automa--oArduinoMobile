//
//  Dispositivo.h
//  TCC-Hugo
//
//  Created by Hugo Saraiva on 17/11/14.
//  Copyright (c) 2014 Saraiva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dispositivo : NSObject {
    int _identificador;
    NSString *_descricao;
    NSString *_status;
}
@property int identificador;
@property (nonatomic, retain) NSString *descricao;
@property (nonatomic, retain) NSString *status;


-(id)initWithId:(int)ident comDescricao:(NSString *)desc comStatus:(NSString *)stat;


@end
