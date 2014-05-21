//
//  ViewController.h
//  QualOperadora
//
//  Created by Carlos Eduardo Corrêa on 5/3/14.
//  Copyright (c) 2014 Carlos Eduardo Corrêa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController : UIViewController<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *consultTextField;
@property (weak, nonatomic) IBOutlet UIButton *consultButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)consultTouchUpInside:(id)sender;
- (IBAction)callPhone:(id)sender;

- (IBAction)showPicker:(id)sender;

@end
