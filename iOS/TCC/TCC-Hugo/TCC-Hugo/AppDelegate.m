//
//  AppDelegate.m
//  TCC-Hugo
//
//  Created by Hugo Saraiva on 17/11/14.
//  Copyright (c) 2014 Saraiva. All rights reserved.
//

#import "AppDelegate.h"
#import "LeitorXML.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize ip = _ip;

- (void) executarConsulta:(NSString *)caminho {
    LeitorXML *leitor = [[LeitorXML alloc] init];
    [leitor consultarServidor:caminho];
}

-(void) irLista:(NSMutableArray*) listaDispostivos{
    
}

- (void) retornoDeDados:(NSMutableArray *)listaDispositivos {
    if([listaDispositivos count] > 0){
        if (!_telaItens) {
            _telaItens = [[TelaDeItens alloc] initWithNibName:@"TelaDeItens" bundle:nil];
        }
        [_telaItens alterarLista:listaDispositivos];
        [self.window addSubview:_telaItens.view];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _ip = @"192.168.0.177";
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
