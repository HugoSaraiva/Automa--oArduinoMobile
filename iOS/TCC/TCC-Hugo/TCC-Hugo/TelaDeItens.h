//
//  TelaDeItens.h
//  TCC-Hugo
//
//  Created by Hugo Saraiva on 17/11/14.
//  Copyright (c) 2014 Saraiva. All rights reserved.
//

#import "ViewController.h"

@interface TelaDeItens : ViewController<UITableViewDelegate> {
    IBOutlet UITableView *tabDispositivos;
    NSMutableArray *_listaDispositivos;
}

@property (strong, nonatomic) UITableView *tabDispositivos;

- (void) alterarLista:(NSMutableArray *)listaDispositivos;

@end
