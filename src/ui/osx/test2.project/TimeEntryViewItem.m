//
//  TimeEntryViewItem.m
//  kopsik_ui_osx
//
//  Created by Tanel Lebedev on 25/09/2013.
//  Copyright (c) 2013 TogglDesktop developers. All rights reserved.
//

#import "TimeEntryViewItem.h"

@implementation TimeEntryViewItem

- (void)load:(KopsikTimeEntryViewItem *)te {
  self.GUID = [NSString stringWithUTF8String:te->GUID];
  self.duration_in_seconds = te->DurationInSeconds;
  self.Description = [NSString stringWithUTF8String:te->Description];
  if (te->ProjectAndTaskLabel) {
    self.ProjectAndTaskLabel = [NSString stringWithUTF8String:te->ProjectAndTaskLabel];
  } else {
    self.ProjectAndTaskLabel = nil;
  }
  self.WorkspaceID = te->WID;
  self.ProjectID = te->PID;
  self.TaskID = te->TID;
  if (te->Color) {
    self.ProjectColor = [NSString stringWithUTF8String:te->Color];
  } else {
    self.ProjectColor = nil;
  }
  self.duration = [NSString stringWithUTF8String:te->Duration];
  if (te->Tags) {
    NSString *tagList = [NSString stringWithUTF8String:te->Tags];
    self.tags = [tagList componentsSeparatedByString:@"|"];
  } else {
    self.tags = nil;
  }
  if (te->Billable) {
    self.Billable = YES;
  } else {
    self.Billable = NO;
  }
  self.started = [NSDate dateWithTimeIntervalSince1970:te->Started];
  self.ended = [NSDate dateWithTimeIntervalSince1970:te->Ended];
  if (te->StartTimeString) {
    self.startTimeString = [NSString stringWithUTF8String:te->StartTimeString];
  } else {
    self.startTimeString = nil;
  }
  if (te->EndTimeString) {
    self.endTimeString = [NSString stringWithUTF8String:te->EndTimeString];
  } else {
    self.endTimeString = nil;
  }
  if (te->UpdatedAt) {
    self.updatedAt = [NSDate dateWithTimeIntervalSince1970:te->UpdatedAt];
  } else {
    self.updatedAt = nil;
  }
  self.formattedDate = [NSString stringWithUTF8String:te->DateHeader];
  if (te->DateDuration) {
    self.dateDuration = [NSString stringWithUTF8String:te->DateDuration];
  } else {
    self.dateDuration = nil;
  }

  self.durOnly = NO;
  if (te->DurOnly) {
    self.durOnly = YES;
  }
}

- (NSString *)description {
  return [NSString stringWithFormat:@"GUID: %@, description: %@, started: %@, ended: %@, project: %@, seconds: %lld, duration: %@, color: %@, billable: %i, tags: %@",
          self.GUID, self.Description, self.started, self.ended,
          self.ProjectAndTaskLabel, self.duration_in_seconds, self.duration,
          self.ProjectColor, self.billable, self.tags];
}

@end
