//
//  ViewController.m
//  QualOperadora
//
//  Created by Carlos Eduardo Corrêa on 5/3/14.
//  Copyright (c) 2014 Carlos Eduardo Corrêa. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize consultButton;
@synthesize consultTextField;
@synthesize resultLabel;
@synthesize resultView;

- (void)viewDidLoad
{
  [super viewDidLoad];
  // UIFont *customFont = [UIFont fontWithName:@"Raleway-Light.otf" size:20];
  
  // Deixa o BG transparente para a imagem de BG aparecer
  self.view.backgroundColor = [UIColor clearColor];
  
  
//  UIFont *raleWay = [UIFont fontWithName:@"Museo Sans" size:16];
//  weightLabel.font = museoSans;
  
  
  
  [consultTextField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)consultTouchUpInside:(id)sender {
    [consultTextField resignFirstResponder];

    NSLog(@"consult touched");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://private-61fc-rodrigoknascimento.apiary-mock.com/consulta/5199999999" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@" A operadora é %@", [responseObject valueForKeyPath:@"operadora"]);
      
        UIFont *ralewayMedium = [UIFont fontWithName:@"Raleway-Medium.otf" size:18];
        resultLabel.text = [NSString stringWithFormat:@" A operadora é \n%@", [responseObject valueForKeyPath:@"operadora"]];
        resultLabel.font = ralewayMedium;
      
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        [resultView setFrame:CGRectMake( 0.0f, 360, 320.0f, 520)]; //notice this is ON screen!
        [UIView commitAnimations];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

- (IBAction)callPhone:(id)sender {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", consultTextField.text]]];
  
  NSLog(@"Tentando ligar para : %@", consultTextField.text);
}


#pragma mark textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    int length = [self getPhoneLength:textField.text];
    
    if (length == 12) {
        
        if(range.length == 0)
            return NO;
    }
    
    if(length == 10)
    {
        NSString *num = [self formatPhoneNumber:textField.text];
        
        textField.text = [NSString stringWithFormat:@"(%@) %@-%@",[num substringWithRange:NSMakeRange(0, 2)],[num substringWithRange:NSMakeRange(2, 5)], [num substringFromIndex:7]];
        
    } else if (length == 11) {
        
        if(range.length == 0)
            return NO;
        
        NSString *num = [[NSString alloc] initWithString:textField.text];
        
        num = [num stringByReplacingOccurrencesOfString:@"(" withString:@""];
        num = [num stringByReplacingOccurrencesOfString:@")" withString:@""];
        num = [num stringByReplacingOccurrencesOfString:@" " withString:@""];
        num = [num stringByReplacingOccurrencesOfString:@"+" withString:@""];
        num = [num stringByReplacingOccurrencesOfString:@"-" withString:@""];
        num = [num stringByReplacingOccurrencesOfString:@"." withString:@""];
        num = [num stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        textField.text = [NSString stringWithFormat:@"(%@) %@-%@",[num substringWithRange:NSMakeRange(0, 2)],[num substringWithRange:NSMakeRange(2, 4)], [num substringFromIndex:6]];
        
    }
    
    if(length == 2)
    {
        NSString *num = [self formatPhoneNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:2]];
    }
    else if(length == 6)
    {
        NSString *num = [self formatPhoneNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:2],[num substringFromIndex:2]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:2],[num substringFromIndex:2]];
    }

    if (([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound) && !(textField.tag == 6) && !(textField.tag == 5)){
        return NO;
    }
    return YES;
    
}

-(int) getPhoneLength:(NSString*)phoneNumber
{
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    int length = [phoneNumber length];
    
    return length;
}

-(NSString*)formatPhoneNumber:(NSString*)phoneNumber
{
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"/" withString:@""];
    
    int length = [phoneNumber length];
    if(length > 10)
    {
        phoneNumber = [phoneNumber substringFromIndex: length-10];
    }
    
    return phoneNumber;
}



@end
