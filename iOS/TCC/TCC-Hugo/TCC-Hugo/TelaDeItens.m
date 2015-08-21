//
//  TelaDeItens.m
//  TCC-Hugo
//
//  Created by Hugo Saraiva on 17/11/14.
//  Copyright (c) 2014 Saraiva. All rights reserved.
//

#import "TelaDeItens.h"
#import "Dispositivo.h"
#import "AppDelegate.h"

@interface TelaDeItens ()

@end

@implementation TelaDeItens

@synthesize tabDispositivos;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) alterarLista:(NSMutableArray *)listaDispositivos {
    _listaDispositivos = listaDispositivos;
    
    [tabDispositivos reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listaDispositivos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *labelTitulo = nil;
    UIButton *btnAlterar = nil;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        btnAlterar = [[UIButton alloc] initWithFrame:CGRectMake(tabDispositivos.frame.size.width - 160, 15, tabDispositivos.frame.size.width - 10, 40)];
        btnAlterar.tag = 3000;
        [btnAlterar addTarget:self action:@selector(btnAlterarClick:) forControlEvents:UIControlEventTouchUpInside];
        btnAlterar.backgroundColor = [UIColor darkGrayColor];
        [btnAlterar setTitleColor:[UIColor whiteColor] forState:0];
        [btnAlterar setTitle:@"Alterar" forState:0];
        [cell.contentView addSubview:btnAlterar];
        
        labelTitulo = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, tabDispositivos.frame.size.width - 165, 60)];
        labelTitulo.tag = 2000;
        labelTitulo.backgroundColor = [UIColor clearColor];
        labelTitulo.numberOfLines = 3;
        [cell.contentView addSubview:labelTitulo];
    }
    
    Dispositivo * dispostivo = ((Dispositivo *)[_listaDispositivos objectAtIndex:indexPath.row]);
    labelTitulo = (UILabel *)[cell.contentView viewWithTag:2000];
    labelTitulo.text = [NSString stringWithFormat:@"%@\n%@", dispostivo.descricao, dispostivo.status];
    btnAlterar = (UIButton *)[cell.contentView viewWithTag:3000];
    [btnAlterar setTitle:[NSString stringWithFormat:@"http://%@/mobileAlterar%i", appDelegate.ip, dispostivo.identificador] forState:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


-(IBAction) btnVoltarClick:(id)sender {
    [self.view removeFromSuperview];
}


-(IBAction) btnAlterarClick:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UIButton* botao = (UIButton *)sender;
    [appDelegate executarConsulta:[botao titleForState:1]];
}

@end
