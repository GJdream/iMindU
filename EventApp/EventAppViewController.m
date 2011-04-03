//
//  EventAppViewController.m
//  EventApp
//
//  Created by Sebastian Engel on 12.01.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventAppViewController.h"
#import <EventKit/EventKit.h>

@implementation EventAppViewController

@synthesize titleField;
@synthesize timeField;

-(IBAction) newEvent {
    EKEventStore *eventDB = [[EKEventStore alloc] init];    
    EKEvent *myEvent = [EKEvent eventWithEventStore:eventDB];    
    EKAlarm *myAlarm = [EKAlarm alarmWithRelativeOffset:0];    
    
    NSDate *dateTmp = [NSDate date];
    
    int myint = [timeField.text integerValue];  
    
    
    NSTimeInterval delta;
    if(segment.selectedSegmentIndex == 0){ 
        delta = 60  * myint;
    }
    else if (segment.selectedSegmentIndex == 1){
        delta = 60 * 60 * myint;
    }
    else {
        delta = 60 * 60 * 24 * myint;
    } 

    dateTmp = [dateTmp dateByAddingTimeInterval:delta];
    
    myEvent.title = titleField.text;
    myEvent.startDate = dateTmp;
    myEvent.endDate = dateTmp;
    myEvent.alarms = [[NSArray alloc] initWithObjects: myAlarm, nil];
     
    [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
    
    NSError *err;
    
    [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err];
    
    
    if (err == noErr) {
        NSDateFormatter* formatterTime = [[[NSDateFormatter alloc] init] autorelease];
        NSDateFormatter* formatterDate = [[[NSDateFormatter alloc] init] autorelease];
        
        [formatterTime setDateFormat:@"HH:mm"];
        [formatterDate setDateFormat:@"dd.MM.yyyy"];
        
        //TODO: dateTemp durch computeDate ersetzen
        NSString *alertTime = [formatterTime stringFromDate:dateTmp];
        NSString *alertDate = [formatterDate stringFromDate:dateTmp];
        
        NSString *alertText = [NSString stringWithFormat:@"%@\n%@ Uhr %@", titleField.text, alertTime, alertDate];
         
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alarm hinzugef�gt:"
                              message:alertText
                              delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
    [titleField setText:@""];
    [timeField setText:@""];
    
    
    //[myEvent release];
    [eventDB release];    
}

- (IBAction) timeChange {
    int myint = [timeField.text integerValue];  
    
    NSDate *dateTmp = [NSDate date];
    
    NSTimeInterval delta;
    if(segment.selectedSegmentIndex == 0){ 
        delta = 60  * myint;
    }
    else if (segment.selectedSegmentIndex == 1){
        delta = 60 * 60 * myint;
    }
    else {
        delta = 60 * 60 * 24 * myint;
    }
    
    dateTmp = [dateTmp dateByAddingTimeInterval:delta];
    
    
    
    NSDateFormatter* formatterTime = [[[NSDateFormatter alloc] init] autorelease];
    NSDateFormatter* formatterDate = [[[NSDateFormatter alloc] init] autorelease];
        
    [formatterTime setDateFormat:@"HH:mm"];
    [formatterDate setDateFormat:@"dd.MM.yyyy"];
    
    //TODO: dateTemp durch computeDate ersetzen
    NSString *alertTime = [formatterTime stringFromDate:dateTmp];
    NSString *alertDate = [formatterDate stringFromDate:dateTmp];
    
    NSString *titleText = [NSString stringWithFormat:@"%@", titleField.text];
    NSString *dateText = [NSString stringWithFormat:@"%@ Uhr %@", alertTime, alertDate];
        
           
    [previewTitle setText:titleText];
    [previewDate setText:dateText];
}

- (NSDate *) computeDate {
    int myint = [timeField.text integerValue];
    NSDate *dateTmp = [NSDate date];
    
    NSTimeInterval delta;
    if(segment.selectedSegmentIndex == 0){ 
        delta = 60  * myint;
    }
    else if (segment.selectedSegmentIndex == 1){
        delta = 60 * 60 * myint;
    }
    else {
        delta = 60 * 60 * 24 * myint;
    }
    
    dateTmp = [dateTmp dateByAddingTimeInterval:delta];
    
    return dateTmp;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [EKEvent release];
    [EKAlarm release];
    [titleField release];
    [timeField release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
