//
//  RURadioButtonView.m
//  Resplendent
//
//  Created by Benjamin Maer on 7/23/13.
//  Copyright (c) 2013 Resplendent G.P.. All rights reserved.
//

#import "RURadioButtonView.h"
#import "RUCompatability.h"
#import "RUDLog.h"
#import "RUConstants.h"





@interface RURadioButtonView ()

//Returns nil if ready, otherwise returns
@property (nonatomic, readonly) NSString* reasonUnableToDraw;

@end





@implementation RURadioButtonView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setNumberOfRows:1];
    }

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    if (_buttons.count)
    {
        NSUInteger numberOfRows = self.numberOfRows;
        NSUInteger numberOfColumns = ceil((double)self.buttonTitles.count / (double)numberOfRows);
        CGFloat buttonPadding = self.buttonPadding;
        CGFloat buttonWidth = ((CGRectGetWidth(self.frame) + buttonPadding) / (double)numberOfColumns) - buttonPadding;
        CGFloat buttonHeight = ((CGRectGetHeight(self.frame) + buttonPadding) / (double)numberOfRows) - buttonPadding;

        NSUInteger row = 0;
        NSUInteger column = 0;

        for (UIButton* button in _buttons)
        {
            CGFloat xCoord = (row * (buttonWidth + buttonPadding));
            CGFloat yCoord = (column * (buttonHeight + buttonPadding));

            [button setFrame:(CGRect){xCoord, yCoord ,buttonWidth,buttonHeight}];

            if (row == numberOfColumns - 1)
            {
                row = 0;
                column++;
            }
            else
            {
                row++;
            }
        }
    }
}

-(NSString *)description
{
    return RUStringWithFormat(@"%@ %@",[super description],@{@"Button titles": self.buttonTitles});
}

#pragma mark - New Button
-(UIButton*)newButtonAtIndex:(NSUInteger)index
{
	if (index >= self.buttonTitles.count)
	{
		NSAssert(false, @"out of bounds");
		return nil;
	}

	NSString* title = [self.buttonTitles objectAtIndex:index];

	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:self.font];
    [button setTitleColor:self.textColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectedTextColor forState:UIControlStateSelected];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

#pragma mark - Getters
-(NSString *)reasonUnableToDraw
{
    if (!self.numberOfRows)
    {
        return @"need non-zero number of rows";
    }
    else if (!self.font)
    {
        return @"need non-nil font";
    }
    else if (!self.textColor)
    {
        return @"need non-nil textColor";
    }
//    else if (!self.selectedTextColor)
//    {
//        return @"need non-nil selectedTextColor";
//    }

    return nil;
}

-(UIButton *)selectedButton
{
    if (self.selectedButtonIndex != NSNotFound)
    {
        return [self.buttons objectAtIndex:self.selectedButtonIndex];
    }

    return nil;
}

#pragma mark - Setters
-(void)setSelectedButtonIndex:(NSUInteger)selectedButtonIndex
{
    UIButton* unSelectButton = self.selectedButton;
    [unSelectButton setSelected:NO];

    _selectedButtonIndex = selectedButtonIndex;

    UIButton* selectedButton = self.selectedButton;
    [selectedButton setSelected:YES];
}

-(void)setButtonTitles:(NSArray *)buttonTitles
{
	NSAssert(buttonTitles.count > 0, @"Pass an array with at least one title");
	
	_buttonTitles = [buttonTitles copy];
	
	NSString* reasonUnableToDraw = self.reasonUnableToDraw;
	if (reasonUnableToDraw)
	{
		RUDLog(@"%@",reasonUnableToDraw);
	}
	else
	{
		NSMutableArray* newButtons = [NSMutableArray array];
		
		for (NSInteger buttonIndex = 0; buttonIndex < self.buttonTitles.count; buttonIndex++)
		{
			UIButton* newButton = [self newButtonAtIndex:buttonIndex];
			
			NSAssert(newButton != nil, @"unhandled");
			if (newButton)
			{
				[newButtons addObject:newButton];
				[self addSubview:newButton];
			}
		}
		
		_buttons = [newButtons copy];
		
		[self setSelectedButtonIndex:0];
	}
}

#pragma mark - Actions
-(void)pressedButton:(UIButton*)button
{
    NSUInteger buttonIndex = [_buttons indexOfObject:button];
    if (buttonIndex == NSNotFound)
    {
        RUDLog(@"button %@ not found in buttons %@",button,_buttons);
    }
    else
    {
        if (self.deSelectButtonOnPress)
        {
            if (buttonIndex == self.selectedButtonIndex)
            {
                buttonIndex = NSNotFound;
            }
        }
        [self setSelectedButtonIndex:buttonIndex];
        [self.selectionDelegate radioButtonView:self selectedButtonAtIndex:buttonIndex];
    }
}

@end
