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

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

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
