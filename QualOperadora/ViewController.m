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
@synthesize spinner;

- (void)viewDidLoad
{
  [super viewDidLoad];
  // UIFont *customFont = [UIFont fontWithName:@"Raleway-Light.otf" size:20];
  
  // Deixa o BG transparente para a imagem de BG aparecer
  self.view.backgroundColor = [UIColor clearColor];
  
  
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner setCenter:CGPointMake(160, 400)];
    [self.view addSubview:spinner];
    
//  UIFont *raleWay = [UIFont fontWithName:@"Museo Sans" size:16];
//  weightLabel.font = museoSans;
  
  [consultTextField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)consultTouchUpInside:(id)sender {
    [consultTextField resignFirstResponder];
    
    [spinner startAnimating];

    NSString *phone = [self unformatPhoneNumber:consultTextField.text];
    NSString *urlString = [NSString stringWithFormat:@"http://qualoperadora.herokuapp.com/consulta/%@", phone];
  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        UIFont *ralewayMedium = [UIFont fontWithName:@"Raleway-Medium.otf" size:18];
        resultLabel.text = [NSString stringWithFormat:@" A operadora é \n%@", [responseObject valueForKeyPath:@"operadora"]];
        resultLabel.font = ralewayMedium;
        
        [UIView animateWithDuration:0.5 animations:^{
            [resultView setFrame:CGRectMake(0, 360, 320, 520)];
            [spinner stopAnimating];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

- (IBAction)callPhone:(id)sender {
  
  NSString *phone = [self unformatPhoneNumber:consultTextField.text];
  
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:0%@", phone]]];
}

- (IBAction)showPicker:(id)sender {
    
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    self.consultTextField.text = phone;
    CFRelease(phoneNumbers);
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

-(NSString*)unformatPhoneNumber:(NSString*)phoneNumber {
  phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
  phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
  phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
  phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
  
  return phoneNumber;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
