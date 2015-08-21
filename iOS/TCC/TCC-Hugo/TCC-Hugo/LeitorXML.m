//
//  LeitorXML.m
//  TCC-Hugo
//
//  Created by Hugo Saraiva on 17/11/14.
//  Copyright (c) 2014 Saraiva. All rights reserved.
//

#import "LeitorXML.h"
#import "AppDelegate.h"

@implementation LeitorXML

-(Dispositivo *) obterDispositivoAtual {
    Dispositivo *dispositivo = nil;
    if ((_listaDispositivos) && ([_listaDispositivos count] > 0))
        dispositivo = (Dispositivo *)[_listaDispositivos objectAtIndex:[_listaDispositivos count]-1];
    return dispositivo;
}

-(void) consultarServidor:(NSString *) caminho {
    _listaDispositivos = [[NSMutableArray alloc] init];
    _nomeDaTag = @"";
    recordResults = FALSE;
    
    NSURL *url = [NSURL URLWithString:caminho];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/mobile" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: @"" forHTTPHeaderField:@"Content-Length"];
    //[theRequest setHTTPMethod:@"GET"];
    
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        if(!webData)
            webData = [NSMutableData data];
    }
    else
    {
        //NSLog(@"theConnection is NULL");
    }
}

- (NSString *) converterHTMLparaPlainText:(NSString *) textoHtml{
    //    UIWebView *webView = [[UIWebView alloc] init];
    //    NSString *textoTemp = [NSString stringWithFormat:@"<html><head></head><body>%@</body></html>", textoHtml];
    //    NSLog(textoTemp);
    //    [webView loadHTMLString:textoTemp baseURL:nil];
    //    return [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    return [textoHtml stringByReplacingOccurrencesOfString:@"\\u00" withString:@"&#x"];
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate retornoDeDados:_listaDispositivos];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate retornoDeDados:nil];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"DONE. Received Bytes: %d", [webData length]);
    //NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict
{
    if(!soapResults)
    {
        soapResults = [[NSMutableString alloc] init];
    }
    
    if( [elementName isEqualToString:@"Dispositivo"]) {
        [_listaDispositivos addObject:[[Dispositivo alloc] init]];
    }
    
    recordResults = NO;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ((_listaDispositivos) && ([_listaDispositivos count] > 0)) {
        Dispositivo *dispositivo = [_listaDispositivos objectAtIndex:[_listaDispositivos count]-1];
        
        if([elementName isEqualToString:@"Codigo"])
            dispositivo.identificador = [soapResults integerValue];
        else if([elementName isEqualToString:@"Descricao"])
            dispositivo.descricao = [NSString stringWithFormat:@"%@", soapResults];
        else if([elementName isEqualToString:@"Status"])
            dispositivo.status = [NSString stringWithFormat:@"%@", soapResults];
    }
    _nomeDaTag = @"";
    [soapResults setString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [[string stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [soapResults appendString:[NSString stringWithFormat:@"%@",string]];
}


@end
