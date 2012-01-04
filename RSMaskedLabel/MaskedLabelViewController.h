//
//  MaskedLabelViewController.h
//  RSMaskedLabel
//
//  Created by Robin Senior on 12-01-04.
//  Copyright (c) 2012 Robin Senior. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSMaskedLabel.h"

@interface MaskedLabelViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet RSMaskedLabel *maskedLabel;
@property (retain, nonatomic) IBOutlet UITextField *labelTextField;

@end
