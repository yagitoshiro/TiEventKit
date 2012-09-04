/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiEventkitModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <EventKit/EventKit.h>

@implementation TiEventkitModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"c69e9ee8-e460-4fc1-ae68-8fce4b38b198";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.eventkit";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
    self.eventStore = [[EKEventStore alloc] init];
    self.eventsList = [[NSMutableArray alloc] initWithArray:0];
    self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
    [eventStore release];
 	[eventsList release];
	[defaultCalendar release];
    
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(BOOL)newEvent:(id)args {
    ENSURE_SINGLE_ARG(args, NSDictionary);
    id startDate = [args valueForKey:@"startDate"];
    id endDate = [args valueForKey:@"endDate"];
    id title = [args valueForKey:@"title"];
    id location = [args valueForKey:@"location"];
    id notes = [args valueForKey:@"notes"];
    id recur = [args valueForKey:@"recur"];
    
    //*** See what's coming in.  Comment this out for final build
    //NSLog(@"[OBJ-C] startDate is: %@", [args valueForKey:@"startDate"]);
    //NSLog(@"[OBJ-C] endDate is: %@", [args valueForKey:@"endDate"]);
    //NSLog(@"[OBJ-C] title is: %@", [args valueForKey:@"title"]);
    //NSLog(@"[OBJ-C] location is: %@", [args valueForKey:@"location"]);
    //NSLog(@"[OBJ-C] notes: %@", [args valueForKey:@"notes"]);
    //NSLog(@"[OBJ-C] recur is: %@", [args valueForKey:@"recur"]);

    //*** Instantiate EventKit objects
    //EKEventStore *eventDB = [[EKEventStore alloc] init];
    EKEvent *theEvent  = [EKEvent eventWithEventStore:self.eventStore];
    
    //*** Create date formater and timezone object
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZoneGMT = [NSTimeZone timeZoneWithName:@"GMT"];
    
    [dateFormatter setTimeZone: timeZoneGMT];
    [dateFormatter setDateFormat: @"yyyy-MM-dd hh:mm:ss Z"];
    
    if(recur){
        ENSURE_SINGLE_ARG(recur, NSDictionary);
        NSLog(@"[OBJ-C] recur frequency is: %@", [recur valueForKey:@"frequency"]);
        NSLog(@"[OBJ-C] recur endCount is: %@", [recur valueForKey:@"endCount"]);
        
        id frequency = [recur valueForKey:@"frequency"];
        EKRecurrenceFrequency  recur_frequency;
        BOOL isRecurrenceFrequencyExists = TRUE;
        
        if([frequency isEqualToString:@"daily"]){
            EKRecurrenceFrequency recur_frequency = EKRecurrenceFrequencyDaily;
        }else if([frequency isEqualToString:@"weekly"]){
            EKRecurrenceFrequency recur_frequency = EKRecurrenceFrequencyWeekly;
        }else if([frequency isEqualToString:@"monthly"]){
            EKRecurrenceFrequency recur_frequency = EKRecurrenceFrequencyMonthly;
        }else if([frequency isEqualToString:@"yearly"]){
            EKRecurrenceFrequency recur_frequency = EKRecurrenceFrequencyYearly;
        }else{
            isRecurrenceFrequencyExists = FALSE;
        }

        if(isRecurrenceFrequencyExists){
            EKRecurrenceEnd *end = nil;
            if([recur valueForKey:@"endCount"]){
                EKRecurrenceEnd *end = [recur valueForKey:@"endCount"];
            }else if([recur valueForKey:@"endDate"]){
                EKRecurrenceEnd *end = [EKRecurrenceEnd recurrenceEndWithEndDate:[dateFormatter dateFromString: [recur valueForKey:@"endDate"]]];
            }
            
            // TODO
            id daysOfTheWeek = [recur valueForKey:@"daysOfTheWeek"];
            id daysOfTheMonth = [recur valueForKey:@"daysOfTheMonth"];
            id monthsOfTheYear = [recur valueForKey:@"monthsOfTheYear"];
            id weeksOfTheYear = [recur valueForKey:@"weeksOfTheYear"];
            id daysOfTheYear = [recur valueForKey:@"daysOfTheYear"];
            id setPositions = [recur valueForKey:@"setPosition"];

            NSInteger interval;
            interval = 1;
            if([recur valueForKey:@"interval"]){
                id interval = [recur valueForKey:@"interval"];
            }
            
            EKRecurrenceRule* recur_rule =
            [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:recur_frequency
                                                         interval:interval
                                                              end:end];
 
            theEvent.recurrenceRule = recur_rule;
        }
    }
    
    //*** Provide POSIX date formatting to prevent date from drifting into a format that iCal won't accept
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [enUSPOSIXLocale release];
    
    //*** Read data into the event
    theEvent.startDate = [dateFormatter dateFromString: startDate];
    theEvent.endDate   = [dateFormatter dateFromString: endDate];
    theEvent.title     = title;
    theEvent.location  = location;
    theEvent.notes     = notes;
    theEvent.allDay = NO;
    
    //*** Set the calendar
    [theEvent setCalendar:self.defaultCalendar];
    
    //*** Provide error trapping
    NSError *err;
    //*** Do save
    [self.eventStore saveEvent:theEvent span:EKSpanThisEvent error:&err];
    
    [dateFormatter release];
    
    //*** Return.  YES returns as 1, NO as 0
    if (err == noErr) {
        return YES;
    } else {
        return NO;
    }
    
}

@end
