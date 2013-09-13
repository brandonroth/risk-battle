//
//  ViewController.m
//  Risk Battle
//
//  Created by Brandon Roth on 8/4/13.
//  Copyright (c) 2013 Rocketmade. All rights reserved.
//

#import "MainController.h"

@interface MainController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *attackerArmySizeField;
@property (weak, nonatomic) IBOutlet UITextField *defenderArmySizeField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *attackerDiceControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *defenderDiceControl;
@property (weak, nonatomic) IBOutlet UIButton *battleOptions;

@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimissKeyboardWithTap:)];
    [self.view addGestureRecognizer:tapGesture];

    [self clearButtonPressed:nil];
    [self setAttackDiceControll];
    [self setDefendDiceControll];

    self.attackerArmySizeField.delegate = self;
    self.defenderArmySizeField.delegate = self;
}

- (void)dimissKeyboardWithTap:(UIGestureRecognizer*)sender
{
    [self.attackerArmySizeField resignFirstResponder];
    [self.defenderArmySizeField resignFirstResponder];
}


#pragma mark - Action Methods

- (IBAction)battleOptionPressed:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

- (IBAction)clearButtonPressed:(id)sender
{
    self.attackerArmySizeField.text = @"";
    self.defenderArmySizeField.text = @"";

    [self setAttackDiceControll];
    [self setDefendDiceControll];
}

- (IBAction)battleButtonPressed:(id)sender
{
    if (self.battleOptions.selected)
    {
        [self doBattle];
    }
    else
    {
        while ([self.attackerArmySizeField.text intValue] > 1  && [self.defenderArmySizeField.text intValue] > 0)
        {
            [self doBattle];
        }
    }
}

#pragma mark - Battle Methods

-(void)doBattle
{
    NSMutableArray *attackerDice = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *defenderDice = [[NSMutableArray alloc] initWithCapacity:2];

    for (int i = 0; i <= self.attackerDiceControl.selectedSegmentIndex; i++)
    {
        [attackerDice addObject:@(arc4random()%6 + 1)];
    }

    for (int i = 0; i <= self.defenderDiceControl.selectedSegmentIndex; i++)
    {
        [defenderDice addObject:@(arc4random()%6 + 1)];
    }

    NSArray *attacker = [attackerDice sortedArrayUsingSelector:@selector(intValue)];
    NSArray *defender = [defenderDice sortedArrayUsingSelector:@selector(intValue)];

    if (attackerDice.count > 0 && defenderDice.count > 0)
    {
        [self compareAttackDie:[attacker[0] intValue]  withDefenderDice:[defender[0] intValue]];
    }

    if (attackerDice.count > 1 && defenderDice.count > 1)
    {
        [self compareAttackDie:[attacker[1] intValue]  withDefenderDice:[defender[1] intValue]];
    }

    [self setAttackDiceControll];
    [self setDefendDiceControll];
}

- (void)compareAttackDie:(int)attackerDice withDefenderDice:(int)defenderDice
{
    if (attackerDice > defenderDice)
    {
        int defenderArmySize = [self.defenderArmySizeField.text intValue];
        self.defenderArmySizeField.text = [@(defenderArmySize -1) stringValue];
    }
    else
    {
        int attackerArmySize = [self.attackerArmySizeField.text intValue];
        self.attackerArmySizeField.text = [@(attackerArmySize -1) stringValue];
    }
}

#pragma mark - Other Methods

- (void)setAttackDiceControll
{
    int attackArmySize = [self.attackerArmySizeField.text intValue];

    [self.attackerDiceControl setEnabled:(attackArmySize > 1) forSegmentAtIndex:0];
    [self.attackerDiceControl setEnabled:(attackArmySize > 2) forSegmentAtIndex:1];
    [self.attackerDiceControl setEnabled:(attackArmySize > 3) forSegmentAtIndex:2];

    int currentSelection = self.attackerDiceControl.selectedSegmentIndex;
    
    if (currentSelection < 0 || [self.attackerDiceControl isEnabledForSegmentAtIndex:currentSelection] == NO)
    {
        if (attackArmySize > 1)
        {
            self.attackerDiceControl.selectedSegmentIndex = 0;
        }

        if (attackArmySize > 2)
        {
            self.attackerDiceControl.selectedSegmentIndex = 1;
        }

        if (attackArmySize > 3)
        {
            self.attackerDiceControl.selectedSegmentIndex = 2;
        }
    }
}

- (void)setDefendDiceControll
{
    int defenderArmySize = [self.defenderArmySizeField.text intValue];

    [self.defenderDiceControl setEnabled:(defenderArmySize > 0) forSegmentAtIndex:0];
    [self.defenderDiceControl setEnabled:(defenderArmySize > 1) forSegmentAtIndex:1];

    int currentSelection = self.defenderDiceControl.selectedSegmentIndex;

    if (currentSelection < 0 || [self.defenderDiceControl isEnabledForSegmentAtIndex:currentSelection] == NO)
    {
        if (defenderArmySize > 0)
        {
            self.defenderDiceControl.selectedSegmentIndex = 0;
        }
        if (defenderArmySize > 1)
        {
            self.defenderDiceControl.selectedSegmentIndex = 1;
        }
    }
}

#pragma mark - UITextfieldDelgate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];

    if (textField == self.attackerArmySizeField)
    {
        [self setAttackDiceControll];
    }
    else if (textField == self.defenderArmySizeField)
    {
        [self setDefendDiceControll];
    }
}

@end
