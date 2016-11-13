//
//  Smeagol.h
//  Smeagol
//
//  Created by Physics Admin on 11/11/16.
//  Copyright © 2016 PhysicsTeam398. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define sqr(x) ((x)*(x))
#define cub(x) ((x)*(x)*(x))
#define Tau (2 * M_PI)

#define NSMakePointC(x,y) NSMakePoint((x) / converter, (y) /converter)
#define NSMakeRectC(x,y,w,h) NSMakeRect((x) / converter, (y) / converter, (w) / converter, (h) / converter)

enum indices {x,y,z};
const short DIM = 3;

const long double MS = 1; // Mass of the Sun in solar units
const long double ME = 3.003e-6; // Mass of the Earth in solar units
const int runTime = 1e5;

@interface Smeagol : NSView
{
    IBOutlet id MagnitudeText; double Magnitude;
    IBOutlet id AngleText; double Angle;
      
    IBOutlet id WhenApplyText; double Applying;
    //IBOutlet id GreaterOrLesser;
    int GreaterOrLesserValue;
    IBOutlet id SecondBoostText; double SecondBoost;
    IBOutlet id SecondAngleText; double SecondAngle;
    
    IBOutlet id ZoomText; double Zoom;
    
    IBOutlet id NumberOfIncreasesText; double NumberOfIncreases;
    IBOutlet id IncreaseValueText; double IncreaseValue;
    
    double Pos[DIM][runTime]; // This is the position of the transport
    double Vel[DIM]; // This is the velocity of the transport
    
    double Pos2[DIM][runTime]; // This is the position of the transport
    double Vel2[DIM]; // This is the velocity of the transport
    
    double cPos[DIM]; // This is a cover variable so that the code is easier for me to write RK4
    double cPos2[DIM]; // This is a cover variable so that the code is easier for me to write RK4
    
    double PosEarth[DIM][runTime]; // This gives the position of earth
    double TE; // This is the period of the Earth around the sun
    double dEarthSun; // This is the distance between the earth and the sun
    
    double G; // Newton's gravitational constant
    
    double t; // this is the over all run time of the program
    double dt; // This is the time step for the programme
    
    double width;
    double converter; // This is a factor which is going to convert points so they display better on the screen
    
    int hasFiredAt;
}

-(void)awakeFromNib; // This starts the programme
-(IBAction)reset:(id)sender; // This will reset the programme for when the angle has been changed

-(IBAction)Zooming:(id)sender; // This or decreases the field of view

-(IBAction)increaseMag:(id)sender; // This allows us to find at what magnitude the program will cross the asteroid belt
-(IBAction)choiceGreaterOrLesser:(id)sender;

-(void)PlanetaryMovement:(int)n; // Currently this will predict the path of earth but in the future will expand to include the inner four planets

-(void)CreateTrajectories;
-(void)RK4:(int)n; // This will execute the path for the transport
-(void)givenR:(double *)rVec returnA:(double *)aVec andGive:(int)n; // This is a method meant to help the RK4 method

-(void)RK4_second:(int)n; // This will execute the path for the transport



@end
