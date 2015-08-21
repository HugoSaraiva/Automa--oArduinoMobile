//
//  LeitorXML.h
//  TCC-Hugo
//
//  Created by Hugo Saraiva on 17/11/14.
//  Copyright (c) 2014 Saraiva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dispositivo.h"

@interface LeitorXML : UIResponder<NSXMLParserDelegate> {
    NSURLConnection *theConnection;
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSXMLParser *xmlParser;
    BOOL *recordResults;
    NSMutableArray *_listaDispositivos;
    NSString *_nomeDaTag;
}

@property (nonatomic, retain) NSMutableArray *listaDispositivos;

- (void) consultarServidor:(NSString *) caminho;

@end
