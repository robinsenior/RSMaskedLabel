//
//  MaskedLabelViewController.m
//  RSMaskedLabel
//
//  Created by Robin Senior on 12-01-04.
//  Copyright (c) 2012 Robin Senior. All rights reserved.
//

#import "MaskedLabelViewController.h"

@implementation MaskedLabelViewController
@synthesize maskedLabel;
@synthesize labelTextField;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[self maskedLabel] setFont:[UIFont boldSystemFontOfSize:64]];
    [[self maskedLabel] setTextAlignment:NSTextAlignmentCenter];
    
    [[self maskedLabel] setText:[labelTextField text]];
}

- (void)viewDidUnload
{
    [self setLabelTextField:nil];
    [self setMaskedLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[self maskedLabel] setText:[labelTextField text]];
    return YES;
}

- (void)dealloc {
    [labelTextField release];
    [maskedLabel release];
    [super dealloc];
}

@end
