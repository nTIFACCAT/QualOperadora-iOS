//
//  ViewController.h
//  QualOperadora
//
//  Created by Carlos Eduardo Corrêa on 5/3/14.
//  Copyright (c) 2014 Carlos Eduardo Corrêa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *consultTextField;
@property (weak, nonatomic) IBOutlet UIButton *consultButton;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

- (IBAction)consultTouchUpInside:(id)sender;

@end
