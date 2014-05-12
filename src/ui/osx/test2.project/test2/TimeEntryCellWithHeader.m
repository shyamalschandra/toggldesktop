//
//  TableViewCell.m
//  kopsik_ui_osx
//
//  Created by Tambet Masik on 9/26/13.
//  Copyright (c) 2013 TogglDesktop developers. All rights reserved.
//

#import "TimeEntryCellWithHeader.h"
#import "UIEvents.h"
#import "ConvertHexColor.h"

@implementation TimeEntryCellWithHeader

- (IBAction)continueTimeEntry:(id)sender {
  NSLog(@"TimeEntryCell continueTimeEntry GUID=%@", self.GUID);

  [[NSNotificationCenter defaultCenter] postNotificationName:kCommandContinue
                                                      object:self.GUID];
}

- (void)render:(TimeEntryViewItem *)view_item {
  NSAssert([NSThread isMainThread], @"Rendering stuff should happen on main thread");

  self.GUID = view_item.GUID;
  self.durationTextField.stringValue = view_item.duration;
  self.dateDurationTextField.stringValue = view_item.dateDuration;
  self.formattedDateTextField.stringValue = view_item.formattedDate;

  // Time entry has a description
  if (view_item.Description && [view_item.Description length] > 0) {
    self.descriptionTextField.stringValue = view_item.Description;
    self.descriptionTextField.toolTip = view_item.Description;
  } else {
    self.descriptionTextField.stringValue = @"(no description)";
    self.descriptionTextField.toolTip = nil;
  }
    
  // Set project and description to tag constraints
  [self toggleProjectConstraints: (view_item.billable || [view_item.tags count])];

  // Set billable and tag constraints
  [self toggleTagConstraints: (view_item.billable && [view_item.tags count])];

  // Set billable label
  if (YES == view_item.billable) {
    [self.billableFlag setHidden:NO];
  } else {
    [self.billableFlag setHidden:YES];
  }
    
  // Time entry tags icon
  if ([view_item.tags count]) {
    [self.tagFlag setHidden:NO];
  } else {
    [self.tagFlag setHidden:YES];
  }
  
  // Time entry has a project
  if (view_item.ProjectAndTaskLabel && [view_item.ProjectAndTaskLabel length] > 0) {
      self.projectTextField.stringValue = view_item.ProjectAndTaskLabel;
    [self.projectTextField setHidden:NO];
    self.projectTextField.toolTip = view_item.ProjectAndTaskLabel;
    self.projectTextField.textColor =
      [ConvertHexColor hexCodeToNSColor:view_item.ProjectColor];
    [self setClient:self.projectTextField];
    return;
  }

  // Time entry has no project
  self.projectTextField.stringValue = @"";
  [self.projectTextField setHidden:YES];
  self.projectTextField.toolTip = nil;
}

-(void)setClient:(NSTextField*)inTextField
{
    NSArray *chunks = [[inTextField stringValue] componentsSeparatedByString: @"."];

    if ([chunks count] == 1) {
        return;
    }

    NSMutableAttributedString *clientName = [[NSMutableAttributedString alloc] initWithString:chunks[1]];
    [clientName setAttributes:
       @{
         NSFontAttributeName : [NSFont systemFontOfSize:[NSFont systemFontSize]],
         NSForegroundColorAttributeName:[NSColor disabledControlTextColor]
       }
       range:NSMakeRange(0, [clientName length])];

    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:[chunks[0] stringByAppendingString:@" "]];
    [string appendAttributedString: clientName];

    // set the attributed string to the NSTextField
    [inTextField setAttributedStringValue: string];
}


- (void)toggleProjectConstraints:(BOOL)flag {
    if(YES==flag) {
        if (!self.projectConstraint) {
            NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_descriptionTextField, _tagFlag);
            self.descriptionConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"[_descriptionTextField]-3@900-[_tagFlag]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:viewsDict];

            NSDictionary *viewsDict_ = NSDictionaryOfVariableBindings(_projectTextField, _tagFlag);
            self.projectConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"[_projectTextField]-3@900-[_tagFlag]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDict_];
        }
        [self addConstraints:self.projectConstraint];
        [self addConstraints:self.descriptionConstraint];
        self.projectConstraintsAdded = YES;
    } else {
        if (self.projectConstraintsAdded) {
            [self removeConstraints:self.projectConstraint];
            [self removeConstraints:self.descriptionConstraint];
            self.projectConstraintsAdded = NO;
        }
    }
}


- (void)toggleTagConstraints:(BOOL)flag {
    if(YES==flag) {
        if (!self.billableConstraint) {
            NSLog(@"Create constraints");
            NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_billableFlag, _tagFlag);
            self.billableConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"[_tagFlag]-8@1000-[_billableFlag]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:viewsDict];
        }
        [self addConstraints:self.billableConstraint];
        self.constraintsAdded = YES;
    } else {
        if (self.constraintsAdded) {
            [self removeConstraints:self.billableConstraint];
            self.constraintsAdded = NO;
        }
    }
}

@end
