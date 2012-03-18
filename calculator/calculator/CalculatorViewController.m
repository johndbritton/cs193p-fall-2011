//
//  CalculatorViewController.m
//  calculator
//
//  Created by John Britton on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userIsEnteringDigitsAfterDecimalPoint;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize programDisplay = _programDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userIsEnteringDigitsAfterDecimalPoint = _userIsEnteringDigitsAfterDecimalPoint;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:sender.currentTitle];
    } else {
        self.display.text = sender.currentTitle;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)decimalPointPressed:(id)sender {
    if(!self.userIsEnteringDigitsAfterDecimalPoint){
        [self digitPressed:sender];
        self.userIsEnteringDigitsAfterDecimalPoint = YES;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.programDisplay.text = [self.programDisplay.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", self.display.text]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userIsEnteringDigitsAfterDecimalPoint = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    double result = [self.brain performOperation:sender.currentTitle];
    self.programDisplay.text = [self.programDisplay.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", sender.currentTitle]];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}
- (void)viewDidUnload {
    [self setProgramDisplay:nil];
    [super viewDidUnload];
}
@end