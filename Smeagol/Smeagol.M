//
//  Smeagol.m
//  Smeagol
//
//  Created by Physics Admin on 11/11/16.
//  Copyright © 2016 PhysicsTeam398. All rights reserved.
//

#import "Smeagol.h"

@implementation Smeagol
-(void)awakeFromNib // This starts the programme
{
    NSRect box = [self bounds];
    [self translateOriginToPoint:NSMakePoint(box.size.width/2.0, box.size.height /2.0)]; // This moves the origin of the View to the center, or in this case towards the center of the Sun
    
    Zoom = 1;
    [ZoomText setDoubleValue:Zoom];
    
    width = 540; // This is the number of pixels in the display
    
    converter = Zoom / width;
    
    G = 39.4; // This is Newton's gravitational constant in AU and solar masses
    
    TE = 1; // Periods are going to equal one earth orbit
    dEarthSun = 1.0;

    Magnitude = 0;
    //Magnitude = 1.003;
    Angle = - M_PI_2;
    

    hasFiredAt = 0;
    
    GreaterOrLesserValue = 0;
    Applying = 2.06;
    SecondBoost = 0.85;
    SecondAngle = 4 * M_PI / 3.0;
    
    hasFiredAt = false;
    
    [MagnitudeText setDoubleValue:Magnitude]; [SecondBoostText setDoubleValue:SecondBoost];
    [AngleText setDoubleValue:Angle]; [SecondAngleText setDoubleValue:SecondAngle];
    [WhenApplyText setDoubleValue:Applying];
    
      
    dt = 1e-5;
    
    [self reset:self];
    //[self CreateTrajectories];
}

-(IBAction)reset:(id)sender // This will reset the programme for when the angle has been changed
{
    Magnitude = [MagnitudeText doubleValue];
    Angle = [AngleText doubleValue];
    

    
    SecondBoost = [SecondBoostText doubleValue];
    SecondAngle = [SecondAngleText doubleValue];
    
    Applying = [WhenApplyText doubleValue];
    
    t = 0;
    
    double AlterVx =  Magnitude * cos(Angle);
    double AlterVy =  Magnitude * sin(Angle);
    
    double OrbiterLevel = 0; //4.3e-5;
    double OrbiterSpeed = 0; //sqrt(G * ME / OrbiterLevel);
    
    Vel[x] = AlterVx - (dEarthSun * Tau * sin(Tau * t / TE))/ TE; Vel[y] = OrbiterSpeed + AlterVy + (dEarthSun * Tau * cos(Tau * t / TE)) / TE; Vel[z] = 0;
    Pos[x][0] = dEarthSun * cos(Tau * t / TE) + OrbiterLevel; Pos[y][0] = dEarthSun * sin(Tau * t / TE); Pos[z][0] = 0;
    
    cPos[x] = Pos[x][0]; cPos[y] = Pos[y][0]; cPos[z] = Pos[z][0];
    
    
    ////////// for second moving body
    

    
    Vel2[x] = AlterVx - (dEarthSun * Tau * sin(Tau * t / TE))/ TE; Vel2[y] = OrbiterSpeed + AlterVy + (dEarthSun * Tau * cos(Tau * t / TE)) / TE; Vel[z] = 0;
    Pos2[x][0] = dEarthSun * cos(Tau * t / TE) + OrbiterLevel; Pos2[y][0] = dEarthSun * sin(Tau * t / TE); Pos2[z][0] = 0;
    
    cPos2[x] = Pos2[x][0]; cPos2[y] = Pos2[y][0]; cPos2[z] = Pos2[z][0];

    
    
    
    
    
    [self CreateTrajectories];
}

-(void)increaseMag:(id)sender
{
    NumberOfIncreases = [NumberOfIncreasesText doubleValue];
    IncreaseValue = [IncreaseValueText doubleValue];
    
    Applying = [WhenApplyText doubleValue];
    
    BOOL DeusVult = YES; //This bool is meant for the display message so that only one message is sent to the user; the first time it enters the asteroid belt
    
    for (int n = 0; n < NumberOfIncreases; n++)
    {
        
        Magnitude += IncreaseValue;
        [MagnitudeText setDoubleValue:Magnitude];
        
        
        
        
        
        [self reset:self];
        for(int n1 = 0; n1 < runTime; n1++)
        {
            double sep = sqrt(sqr(Pos[x][n1]) + sqr(Pos[y][n1]) + sqr(Pos[z][n1])); // This radius of the transporter
            
            if (DeusVult)
            {
                if (sep > Applying)
                {
                    NSLog(@"The transport has gone into the asteroid belt at Mag: %f", Magnitude);
                    NSLog(@"%f \t %f \t %f", Pos[x][n1],Pos[y][n1],Pos[z][n1]);
                    
                } // This finds if the transporter has gone beyond the asteroid belt

                if (sep < 5e-3)
                {
                    NSLog(@"Look Frodo The Shire: %f", Magnitude);
                }
                
                DeusVult = NO;
            }


        }
    }
}

-(void)choiceGreaterOrLesser:(id)sender
{
    switch ([sender tag])
    {
        case 0: GreaterOrLesserValue = 0; break; // This chooses Greater
        case 1: GreaterOrLesserValue = 1; break; // This chooses Lesser
    }
}

-(void)Zooming:(id)sender
{
    Zoom = [ZoomText doubleValue];
    
    converter = Zoom / width;
    
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    //////////////////////SUN STUFF
    const double SolRadius = 1 * converter;
    
    [[NSColor blackColor] set];
    NSRectFill(dirtyRect);
    
    [[NSColor yellowColor] set];
    NSBezierPath *SunPath = [NSBezierPath bezierPath];
    {
        NSRect SolBox = NSMakeRectC(-SolRadius, -SolRadius, 2 * SolRadius, 2 * SolRadius);
        [SunPath appendBezierPathWithOvalInRect:SolBox];
    }
    [SunPath fill];
    //////////////////////SUN STUFF
    
    
    

    ///////////////////// Path of Transport1
    //for (int n1 = 0; n1 < runTime; n1++)
    {
        //[[NSColor colorWithHue:(0.8 * n1) / (runTime -2) saturation:1.0 brightness:1.0 alpha:1.0] set];
        [[NSColor redColor] set];
        NSBezierPath *transportPath = [NSBezierPath bezierPath];
        {
            [transportPath setLineWidth:3.0];
            
            [transportPath moveToPoint:NSMakePointC(Pos[x][0], Pos[y][0])];
            for (int n = 0; n < hasFiredAt; n++)
            {
                [transportPath lineToPoint:NSMakePointC(Pos[x][n], Pos[y][n])];
            }
        }
        [transportPath stroke];
        
        [[NSColor orangeColor] set];
        NSBezierPath *transportPath2 = [NSBezierPath bezierPath];
        {
            [transportPath2 setLineWidth:3.0];
            
            [transportPath2 moveToPoint:NSMakePointC(Pos[x][hasFiredAt], Pos[y][hasFiredAt])];
            for (int n = hasFiredAt; n < runTime; n++)
            {

                [transportPath2 lineToPoint:NSMakePointC(Pos[x][n], Pos[y][n])];
            }
        }
        [transportPath2 stroke];

        
        // This places a circle at the point which Frodo and Bilbo seperate
        if (hasFiredAt != 0)
        {
            const double SeperationPointValue = 2 * converter;
            
            [[NSColor brownColor] set];
            NSBezierPath *seperationPoint = [NSBezierPath bezierPath];
            {
                [seperationPoint setLineWidth:1.0];
                
                NSRect seperationPointBox = NSMakeRectC(Pos[x][hasFiredAt] - SeperationPointValue, Pos[y][hasFiredAt] - SeperationPointValue, 2 * SeperationPointValue, 2 * SeperationPointValue);
                [seperationPoint appendBezierPathWithOvalInRect:seperationPointBox];
            }
            [seperationPoint stroke];
        }
        
    }
    ////////////////////
    
    ///////////////////// Path of Transport2
    //for (int n1 = 0; n1 < runTime; n1++)
    {
        //[[NSColor colorWithHue:(0.8 * n1) / (runTime -2) saturation:1.0 brightness:1.0 alpha:1.0] set];
        [[NSColor whiteColor] set];
        NSBezierPath *transportPath = [NSBezierPath bezierPath];
        {
            [transportPath setLineWidth:3.0];
            
            [transportPath moveToPoint:NSMakePointC(Pos2[x][0], Pos2[y][0])];
            for (int n = 0; n < runTime; n++)
            {
                [transportPath lineToPoint:NSMakePointC(Pos2[x][n], Pos2[y][n])];
            }
        }
        [transportPath stroke];
    }
    /////////////////////
    
    
    
    // Path of Earth
    
    [[NSColor blueColor] set];
    NSBezierPath *EarthPath = [NSBezierPath bezierPath];
    {
        [EarthPath setLineWidth:2.0];
        
        [EarthPath moveToPoint:NSMakePointC(PosEarth[x][0], PosEarth[y][0])];
        for (int n = 0; n < runTime; n++)
        {
            [EarthPath lineToPoint:NSMakePointC(PosEarth[x][n], PosEarth[y][n])];
        }
    }
    [EarthPath stroke];
    
    // Earth's Last Position
    
    const double EarthRadiusShown = 1 * converter;
    
    [[NSColor whiteColor] set];
    NSBezierPath *EarthCircle = [NSBezierPath bezierPath];
    {
        NSRect EarthBox = NSMakeRectC(PosEarth[x][runTime-1] -EarthRadiusShown, PosEarth[y][runTime-1] - EarthRadiusShown, 2 * EarthRadiusShown, 2 * EarthRadiusShown);
        [EarthCircle appendBezierPathWithOvalInRect:EarthBox];
    }
    [EarthCircle stroke];
    
    //Asteroid Belt Inner
    const double asteroidDiskInnerRadius = 2.06;
    
    [[NSColor purpleColor] set];
    NSBezierPath *asteroidBeltInner = [NSBezierPath bezierPath];
    {
        [asteroidBeltInner setLineWidth:1];
        
        NSRect asteroidBoxInner = NSMakeRectC(- asteroidDiskInnerRadius, -asteroidDiskInnerRadius, 2 * asteroidDiskInnerRadius, 2 * asteroidDiskInnerRadius);
        [asteroidBeltInner appendBezierPathWithOvalInRect:asteroidBoxInner];
    }
    [asteroidBeltInner stroke];
    
    // Asteroid Belt Outer
    const double asteroidDiskOuterRadius = 3.27;
    
    [[NSColor purpleColor] set];
    NSBezierPath *asteroidBeltOuter = [NSBezierPath bezierPath];
    {
        [asteroidBeltOuter setLineWidth:1];
        
        NSRect asteroidBoxOuter = NSMakeRectC(- asteroidDiskOuterRadius, -asteroidDiskOuterRadius, 2 * asteroidDiskOuterRadius, 2 * asteroidDiskOuterRadius);
        [asteroidBeltOuter appendBezierPathWithOvalInRect:asteroidBoxOuter];
    }
    [asteroidBeltOuter stroke];
    
    
    // To let us know completion of the drawing
//    NSBeep();
//    NSBeep();
//    NSBeep();

}

-(void)CreateTrajectories
{
    BOOL HasFired = NO;
    BOOL HasIncenerated = NO;
    
    for (int n = 0; n < runTime; n++)
    {
        [self PlanetaryMovement:n];
        
        
        
        [self RK4:n];
        Pos[x][n] = cPos[x]; Pos[y][n] = cPos[y]; Pos[z][n] = cPos[z];
        double sep = sqrt(sqr(Pos[x][n]) + sqr(Pos[y][n]) + sqr(Pos[z][n]));
        
        if ((HasFired == NO) and (GreaterOrLesserValue == 0))
        {
            if ((sep > Applying)) //This is where we allow the user to input a second energy also for when the object is into the asteroid belt
            {
                Vel[x] += SecondBoost * cos(SecondAngle);
                Vel[y] += SecondBoost * sin(SecondAngle);
                
                hasFiredAt = n;
                HasFired = YES;
                
            }
        }
        else if ((HasFired == NO) and (GreaterOrLesserValue == 1))
        {
            if ((sep < Applying)) //This is where we allow the user to input a second energy also for when the object is in the sun danger zone
            {
                Vel[x] += SecondBoost * cos(SecondAngle);
                Vel[y] += SecondBoost * sin(SecondAngle);
                
                hasFiredAt = n;
                HasFired = YES;
                
            }
        }
        
        if ((sep < 0.0668) and (HasIncenerated == NO)) // Is the object incenerated?
        {
            NSLog(@"Object entered the Danger Zone");
            Pos[x][n]= 0; Pos[y][n] = 0; Pos[z][n] =0;
            HasIncenerated = YES;
        }
        
        // for second guy, no second boost required?
        [self RK4_second:n];
        Pos2[x][n] = cPos2[x]; Pos2[y][n] = cPos2[y]; Pos2[z][n] = cPos2[z];
        
        t+=dt;
    }
    
    HasFired = NO;
    
    [self setNeedsDisplay:YES];
}

-(void)PlanetaryMovement:(int)n; // Currently this will predict the path of earth but in the future will expand to include the inner four planets
{
    PosEarth[x][n] = dEarthSun * cos(Tau * t / TE); PosEarth[y][n] = dEarthSun * sin(Tau * t / TE);
}

-(void)RK4:(int)n // This will execute the path for the transport
{
    double a1Vec[DIM], a2Vec[DIM], a3Vec[DIM], a4Vec[DIM];
    
    [self givenR:cPos returnA:a1Vec andGive:n];
    double dVx1 = a1Vec[x]*dt; double dVy1 = a1Vec[y]*dt;
    double dX1 = Vel[x] * dt; double dY1 = Vel[y] * dt;
    
    double r2[DIM] = {cPos[x] + dX1 / 2.0, cPos[y] + dY1 / 2.0};
    [self givenR:r2 returnA:a2Vec andGive:n];
    double dVx2 = a2Vec[x] * dt; double dVy2 = a2Vec[y] * dt;
    double dX2 = (Vel[x] + dVx1 / 2.0) * dt; double dY2 = (Vel[y] + dVy1 / 2.0) * dt;
    
    double r3[DIM] = {cPos[x] + dX2 / 2.0, cPos[y] + dY2 / 2.0};
    [self givenR:r3 returnA:a3Vec andGive:n];
    double dVx3 = a3Vec[x] * dt; double dVy3 = a3Vec[y] * dt;
    double dX3 = (Vel[x] + dVx2 / 2.0) * dt; double dY3 = (Vel[y] + dVy2 / 2.0) * dt;
    
    double r4[DIM] = {cPos[x] + dX3, cPos[y] + dY3};
    [self givenR:r4 returnA:a4Vec andGive:n];
    double dVx4 = a4Vec[x] * dt; double dVy4 = a4Vec[y] * dt;
    double dX4 = (Vel[x] + dVx3) * dt; double dY4 = (Vel[y] + dVy3) * dt;
    
    
    double dVx = (dVx1 + (2 * dVx2) + (2 * dVx3) + dVx4) / 6.0; double dVy = (dVy1 + (2 * dVy2) + (2 * dVy3) + dVy4) / 6.0;
    double dX = (dX1 + (2 * dX2) + (2 * dX3) + dX4) / 6.0; double dY = (dY1 + (2 * dY2) + (2 * dY3) + dY4) / 6.0;
    
    Vel[x] += dVx; Vel[y] += dVy;
    cPos[x] += dX; cPos[y] += dY;
}

-(void)givenR:(double *)rVec returnA:(double *)aVec andGive:(int)n // This is a method meant to help the RK4 method
{
    double rStT[DIM] = {rVec[x], rVec[y], rVec[z]}; // Radius from Sol to Transport
    double rEtT[DIM] = {rVec[x] - PosEarth[x][n], rVec[y] - PosEarth[y][n], rVec[z] - PosEarth[z][n]}; // Radius from Earth to Transport
    
    double magRStT = sqrt(sqr(rStT[x])+sqr(rStT[y])+sqr(rStT[z]));
    double magREtT = sqrt(sqr(rEtT[x])+sqr(rEtT[y])+sqr(rEtT[z]));
    
    if(magREtT == 0 and t < 5e-3)
    {
        magREtT = 4.3e-5;
    }
    
    double gStT = - G * MS / cub(magRStT);
    double gEtT = - G * ME / cub(magREtT);
//
    double a[DIM]=
    {
        gStT * rStT[x],
        gStT * rStT[y],
        gStT * rStT[z]
    };
    
//    double a[DIM] =
//    {
//        (gStT * rStT[x]) + (gEtT * rEtT[x]),
//        (gStT * rStT[y]) + (gEtT * rEtT[y]),
//        (gStT * rStT[z]) + (gEtT * rEtT[z])
//    };
    
    aVec[x] = a[x]; aVec[y] = a[y]; aVec[z] = a[z];
}



-(void)RK4_second:(int)n // This will execute the path for the transport
{
    double a1Vec[DIM], a2Vec[DIM], a3Vec[DIM], a4Vec[DIM];
    
    [self givenR:cPos2 returnA:a1Vec andGive:n];
    double dVx1 = a1Vec[x]*dt; double dVy1 = a1Vec[y]*dt;
    double dX1 = Vel2[x] * dt; double dY1 = Vel2[y] * dt;
    
    double r2[DIM] = {cPos2[x] + dX1 / 2.0, cPos2[y] + dY1 / 2.0};
    [self givenR:r2 returnA:a2Vec andGive:n];
    double dVx2 = a2Vec[x] * dt; double dVy2 = a2Vec[y] * dt;
    double dX2 = (Vel2[x] + dVx1 / 2.0) * dt; double dY2 = (Vel2[y] + dVy1 / 2.0) * dt;
    
    double r3[DIM] = {cPos2[x] + dX2 / 2.0, cPos2[y] + dY2 / 2.0};
    [self givenR:r3 returnA:a3Vec andGive:n];
    double dVx3 = a3Vec[x] * dt; double dVy3 = a3Vec[y] * dt;
    double dX3 = (Vel2[x] + dVx2 / 2.0) * dt; double dY3 = (Vel2[y] + dVy2 / 2.0) * dt;
    
    double r4[DIM] = {cPos2[x] + dX3, cPos2[y] + dY3};
    [self givenR:r4 returnA:a4Vec andGive:n];
    double dVx4 = a4Vec[x] * dt; double dVy4 = a4Vec[y] * dt;
    double dX4 = (Vel2[x] + dVx3) * dt; double dY4 = (Vel2[y] + dVy3) * dt;
    
    
    double dVx = (dVx1 + (2 * dVx2) + (2 * dVx3) + dVx4) / 6.0; double dVy = (dVy1 + (2 * dVy2) + (2 * dVy3) + dVy4) / 6.0;
    double dX = (dX1 + (2 * dX2) + (2 * dX3) + dX4) / 6.0; double dY = (dY1 + (2 * dY2) + (2 * dY3) + dY4) / 6.0;
    
    Vel2[x] += dVx; Vel2[y] += dVy;
    cPos2[x] += dX; cPos2[y] += dY;
}



@end
