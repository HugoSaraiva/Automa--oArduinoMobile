//
//  ViewController.m
//  TCC-Hugo
//
//  Created by Hugo Saraiva on 17/11/14.
//  Copyright (c) 2014 Saraiva. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [super viewDidLoad];
    txtIP.text = appDelegate.ip;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) btnEntrar:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.ip = txtIP.text;
    [appDelegate executarConsulta:[NSString stringWithFormat:@"http://%@/mobile", appDelegate.ip]];
}

@end
