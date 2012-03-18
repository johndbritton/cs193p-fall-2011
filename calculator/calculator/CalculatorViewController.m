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
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize programDisplay = _programDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
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
    NSRange rangeOfDecimalPoint = [self.display.text rangeOfString:@"."];
    if (rangeOfDecimalPoint.location == NSNotFound) {
        [self digitPressed:sender];
        self.userIsInTheMiddleOfEnteringANumber = YES;        
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.programDisplay.text = [self.programDisplay.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", self.display.text]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)clearPressed {
    [self.brain clear];
    self.display.text = @"0";
    self.programDisplay.text = @"";	
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)backspacePressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        int displayLength = [self.display.text length];
        if (displayLength > 1) {
            NSRange range = {0, displayLength-1};
            self.display.text = [self.display.text substringWithRange:range];
        } else if (displayLength == 1) {
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }

}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if ([sender.currentTitle isEqualToString:@"±"]) {
            self.display.text = [NSString stringWithFormat:@"%g", ([self.display.text doubleValue] * -1)];
            return;
        } else {
            [self enterPressed];
        }
    }
    double result = [self.brain performOperation:sender.currentTitle];
    self.programDisplay.text = [self.programDisplay.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", sender.currentTitle]];
    self.programDisplay.text = [self.programDisplay.text stringByAppendingString:[NSString stringWithFormat:@"= "]];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}
@end