//
//  OCKHeartWeekView.m
//  CareKit
//
//  Created by Umer Khan on 1/29/16.
//  Copyright © 2016 carekit.org. All rights reserved.
//


#import "OCKCareCardWeekView.h"
#import "OCKWeekView.h"
#import "OCKHeartView.h"
#import "OCKColors.h"


const static CGFloat HeartButtonSize = 20.0;

@implementation OCKCareCardWeekView {
    OCKWeekView *_weekView;
    NSMutableArray <UIButton *> *_heartButtons;
    OCKHeartView *_heartView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareView];
    }
    return self;
}

- (void)prepareView {
    if (!_weekView) {
        _weekView = [[OCKWeekView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25.0)];
        [self addSubview:_weekView];
        
        NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:[NSDate date]] - 1;
        [_weekView highlightDay:weekday];
        _selectedIndex = weekday;
    }
    
    _heartButtons = [NSMutableArray new];
    for (int i = 0; i < 7; i++) {
        UIButton *heart = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, HeartButtonSize, HeartButtonSize)];
        heart.translatesAutoresizingMaskIntoConstraints = NO;
        
        _heartView = [[OCKHeartView alloc] initWithFrame:CGRectMake(0, 0, HeartButtonSize + 10, HeartButtonSize + 10)];
        _heartView.animate = NO;
        _heartView.adherence = [_adherenceValues[i] floatValue];
        _heartView.userInteractionEnabled = NO;
        [heart addSubview:_heartView];
        
        [heart addTarget:self
                  action:@selector(updateDayOfWeek:)
        forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:heart];
        [_heartButtons addObject:heart];
    }

    [self setUpConstraints];
}

- (void)setUpConstraints {
    NSMutableArray *constraints = [NSMutableArray new];
    
    _weekView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [constraints addObjectsFromArray:@[
                                       [NSLayoutConstraint constraintWithItem:_weekView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0.0],
                                       [NSLayoutConstraint constraintWithItem:_weekView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0.0]
                                       ]];
    
    for (int i = 0; i < _heartButtons.count; i++) {
        UILabel *dayLabel = (UILabel *)_weekView.weekLabels[i];
        [constraints addObjectsFromArray:@[
                                           [NSLayoutConstraint constraintWithItem:dayLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_heartButtons[i]
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0
                                                                         constant:0.0],
                                           [NSLayoutConstraint constraintWithItem:dayLabel
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_heartButtons[i]
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.0
                                                                         constant:0.0]
                                           ]];
    }
    
    
    [NSLayoutConstraint activateConstraints:constraints];
}

- (void)setAdherenceValues:(NSArray *)adherenceValues {
    _adherenceValues = adherenceValues;
    [self prepareView];
}

- (void)updateDayOfWeek:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger dayOfWeek = [_heartButtons indexOfObject:button];
    _selectedIndex = dayOfWeek;
    
    if (_delegate &&
        [_delegate respondsToSelector:@selector(careCardWeekViewSelectionDidChange:)]) {
        [_delegate careCardWeekViewSelectionDidChange:self];
    }
}

@end
