// Specify enclosure dimensions
enclosureHeight=475.0;
enclosureWidth=535.0; // depth is same as width

// Panel
panelThickness=6.0;
panelHeight=450.0;
panelWidth=535.0;

// Frame
plasticThickness=2.0;
cornerThickness=30.0;
cornerHeight=68.0;
frameOffsetV = enclosureHeight - panelHeight;
frameThickness = plasticThickness*2 + panelThickness;

// Interlock
knobDiameter=9.8;
lugDiameter=6.0;
lugGap=1.5;
lugHeight = lugGap+2.15;
interlockOffsetX=15.0;
interlockOffsetZ=27.0;
interlockGap=32;

// Door hinge
hingeInnerDiameter=10;
hingeHeight=25;
hingeLength=53;

tolerance=0.4;
hingeRingThickness=3.0;
seeThroughPanelThickness=3.0;
hingeThickness=plasticThickness*2 + seeThroughPanelThickness;




// applies roundness without altering dimensions of object
module applyRoundness(r)
    offset(r) offset(delta=-r) children(0);

// makes a corner piece by mirroring and rotating one side
module cornerize() {
    union() {
        children(0);
        mirror([0,1,0]) 
            rotate([0,0,-90])
                children(0);
    }
} 

module interlock() {
    ra = knobDiameter/2;
    rb = ra - lugDiameter/2;
    
    rotate([0,90,180]) 
        rotate_extrude()
            polygon([[0,0],[0,lugHeight],[rb,lugHeight],[rb,2.5],[ra,1],[ra,0]]);
}

module frameCorner(
    width, height, thickness, // outer dimensions
    roundCorners              // radius to round corners by
) { 
    union() {
        translate([thickness,0,0]) 
            rotate([0,0,90]) 
                cornerize()
                    linear_extrude(height=height)
                      applyRoundness(roundCorners, $fs =0.01) 
                        square( [thickness, width] );

        translate([thickness+lugHeight,interlockOffsetX,interlockOffsetZ]) 
                interlock($fn=50);
        translate([thickness+lugHeight,interlockOffsetX,interlockOffsetZ+interlockGap])
                interlock($fn=50);
     }
}

module backLeftBottomCorner() {
    mirror([1,0,0])
        difference() {
            frameCorner( cornerThickness, cornerHeight,frameThickness, 0.9);
            
            // remove a gap to allow the left hand panel to fit
            translate([-cornerThickness+frameThickness,0,frameOffsetV]) 
                cube([cornerThickness,panelThickness,cornerThickness*2]);
            
            // remove a gap for the back panel to be held in place
            translate( [frameThickness/2 - panelThickness/2, frameThickness, frameOffsetV] ) 
                cube([panelThickness,cornerThickness,cornerHeight],false);
        }
}

module hingePost() {
    difference() {
        union() {
            translate([-hingeInnerDiameter,0,hingeHeight-hingeInnerDiameter/2+tolerance]) 
                cube([hingeInnerDiameter*2,hingeInnerDiameter,hingeInnerDiameter],true);
            cylinder(d=hingeInnerDiameter, hingeHeight+tolerance, $fn=60);
        }
        
        // add a chamfer
        translate([4,0,33]) rotate([0,30,0]) cube(20,true);
    }
}

module hinge() {
    height = hingeHeight-hingeInnerDiameter;
    width = hingeInnerDiameter+tolerance+hingeRingThickness;
    
    difference() {
        
        // create the base shape for the hinge
        union() {
            cylinder(d=width, height, $fn=60);
                translate([hingeInnerDiameter*3,0,height/2]) 
                    cube([hingeLength,hingeThickness,height],true);
        }
        
        // remove a hole for the hinge post to slide into
        cylinder(d=hingeInnerDiameter+tolerance, height, $fn=60);
        
        // remove the groove for the perspex panel
        translate([hingeInnerDiameter*3+hingeRingThickness,0,height/2+plasticThickness]) 
            cube([hingeLength,seeThroughPanelThickness,height],true);
        
        // add a chamfer
        translate([hingeLength+8,0,height+25]) rotate([0,45,0]) cube(50,true);
    }
        
}

module frontLeftBottomCorner() {
    hingePosition=[hingeInnerDiameter/2,cornerThickness+hingeInnerDiameter/2-hingeInnerDiameter/2+plasticThickness+tolerance,0];
    union() {
        difference() {
            // base model
            frameCorner( cornerThickness, cornerHeight,frameThickness, 0.9);
            
            // subtract gap for left wall
            translate([-cornerThickness+frameThickness,0,frameOffsetV]) 
                cube([cornerThickness,panelThickness,cornerThickness*2]);
            
            // subtract a space for the hinge post
            translate([-frameThickness/2,-(hingeInnerDiameter/2+plasticThickness+tolerance),0])
            translate(hingePosition) 
                cube([frameThickness,hingeInnerDiameter*2,hingeHeight]);
        }
        translate(hingePosition) 
            rotate([0,0,90]) hingePost();
    }
}

translate([-enclosureWidth,0,0]) backLeftBottomCorner();
frontLeftBottomCorner();
translate([(hingeInnerDiameter)/2,cornerThickness+plasticThickness+tolerance,0]) hinge();
