plastic_thickness=2.0;
tolerance=0.22;

// Specify enclosure dimensions
enclosure_height=475.0;
enclosure_width=535.0;
enclosure_depth=535.0;

// Wall panel dimensions
panel_thickness=6.0;
panel_height=450.0;
panel_width=535.0;

// Door panel dimensions
door_panel_thickness=3.0;
door_panel_width=250.0;
door_panel_height=475.0;

// Frame
frame_corner_width=30.0;
frame_corner_height=79.0;
frame_offset_v = enclosure_height - panel_height;
frame_thickness = plastic_thickness*2 + panel_thickness;
frame_side = (enclosure_height - frame_corner_height*2)/2;
frame_clip_height=50.5;

// Interlock
knob_diameter=9.8;
lug_diameter=6.2;
lug_gap=1.4;
lug_height = lug_gap+2.15;
interlock_offset_x=15.0;
interlock_offset_z=27.0;
interlock_gap=32;

// Door hinge
hinge_inner_diameter=10;
hinge_height=25;
hinge_length=53;
hinge_gap = 2.0;
hinge_ring_thickness=3.0;
hinge_thickness=plastic_thickness*2 + door_panel_thickness;

// applies roundness without altering dimensions of object
module apply_roundness(r)
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
    ra = knob_diameter/2;
    rb = lug_diameter/2;
    
    rotate([0,90,180]) 
        rotate_extrude()
            polygon([[0,0],[0,lug_height],[rb,lug_height],[rb,2.5],[ra,1],[ra,0]]);
}

module frame_corner( width, height, thickness, roundCorners ) {         
    cornerize()
        linear_extrude(height=height)
            apply_roundness(roundCorners, $fs =0.01) 
            square( [thickness, width] );
}

module frame_corner_with_lugs( width, height, thickness, roundCorners ) { 
    union() {
        translate([thickness,0,0]) 
            rotate([0,0,90])
                frame_corner( width, height, thickness, roundCorners );
        translate([thickness+lug_height,interlock_offset_x,interlock_offset_z]) 
                interlock($fn=50);
        translate([thickness+lug_height,interlock_offset_x,interlock_offset_z+interlock_gap])
                interlock($fn=50);
    }
}

module back_left_bottom_corner() {
    mirror([1,0,0])
        render()
        difference() {
            frame_corner_with_lugs( frame_corner_width, frame_corner_height,frame_thickness, 0.9);
            
            // remove a gap to allow the left hand panel to fit
            translate([-frame_corner_width+frame_thickness,0,frame_offset_v]) 
                cube([frame_corner_width,panel_thickness,frame_corner_width*2]);
            
            // remove a gap for the back panel to be held in place
            translate( [frame_thickness/2 - panel_thickness/2, frame_thickness, frame_offset_v] ) 
                cube([panel_thickness,frame_corner_width,frame_corner_height],false);
        }
}

module back_left_top_corner() {
    mirror([1,0,0])
        render()
        difference() {
            frame_corner_with_lugs( frame_corner_width, frame_corner_height,frame_thickness, 0.9);
            
            // remove a gap to allow the left hand panel to fit
            translate([-frame_corner_width+frame_thickness,0,0]) 
                cube([frame_corner_width,panel_thickness,frame_corner_height]);
            
            // remove a gap for the back panel to be held in place
            translate( [frame_thickness/2 - panel_thickness/2, frame_thickness, 0] ) 
                cube([panel_thickness,frame_corner_width,frame_corner_height],false);
        }
}

module hinge_post() {
    difference() {
        union() {
            translate([-hinge_inner_diameter,0,hinge_height-hinge_inner_diameter/2+tolerance]) 
                cube([hinge_inner_diameter*2,hinge_inner_diameter,hinge_inner_diameter],true);
            cylinder(d=hinge_inner_diameter, hinge_height+tolerance, $fn=60);
        }
        
        // add a chamfer
        translate([2,0,33]) rotate([0,30,0]) cube(20,true);
    }
}

module hinge() {
    height = hinge_height-hinge_inner_diameter;
    width = hinge_inner_diameter+tolerance+hinge_ring_thickness;
    render()
    difference() {
        
        // create the base shape for the hinge
        union() {
            cylinder(d=width, height, $fn=60);
                translate([hinge_inner_diameter*3,0,height/2]) 
                    cube([hinge_length,hinge_thickness,height],true);
        }
        
        // remove a hole for the hinge post to slide into
        cylinder(d=hinge_inner_diameter+tolerance, height, $fn=60);
        
        // remove the groove for the perspex panel
        translate([hinge_inner_diameter*3+hinge_ring_thickness,0,height/2+plastic_thickness]) 
            cube([hinge_length,door_panel_thickness,height],true);
        
        // add a chamfer
        translate([hinge_length+8,0,height+25]) rotate([0,45,0]) cube(50,true);
    }
        
}

module add_hinge_post( top=false ) {
    hinge_position=[hinge_inner_diameter/2,frame_corner_width+plastic_thickness+hinge_gap, (top?frame_corner_height:0)];
    cutout_height=hinge_height - hinge_inner_diameter + tolerance;
    union() {
        difference() {
            // base model
            children(0);

            // subtract a space for the hinge post
            translate([-frame_thickness/2,-hinge_inner_diameter/2+hinge_gap-hinge_ring_thickness-tolerance*3,(top?-cutout_height:0)])
            translate(hinge_position) 
                cube([frame_thickness,hinge_inner_diameter*2,cutout_height]);
        }
        translate(hinge_position) mirror((top?[0,0,1]:[0,0,0]))
            rotate([0,0,90]) hinge_post();
    }
}


module front_left_top_corner() {
    render()
    difference() {
        add_hinge_post(top=true)
            frame_corner_with_lugs( frame_corner_width, frame_corner_height,frame_thickness, 0.9);
        
        // subtract gap for left wall
        translate([-frame_corner_width+frame_thickness,0,0]) 
            cube([frame_corner_width,panel_thickness,frame_corner_height*2]);
    }
}

module front_left_bottom_corner() {
    render()
    difference() {
        add_hinge_post(top=false)
            frame_corner_with_lugs( frame_corner_width, frame_corner_height,frame_thickness, 0.9);
        
        // subtract gap for left wall
        translate([-frame_corner_width+frame_thickness,0,frame_offset_v]) 
            cube([frame_corner_width,panel_thickness,frame_corner_height]);
    }

}

translate([-enclosure_depth,0,0]) back_left_bottom_corner();

translate([-enclosure_depth,0,enclosure_height-frame_corner_height]) back_left_top_corner();

translate([0,0,enclosure_height-frame_corner_height]) 
    front_left_top_corner();
translate([(hinge_inner_diameter)/2,
    frame_corner_width+plastic_thickness+hinge_gap,
    enclosure_height]) 
        rotate([180,0,90]) 
            hinge();

front_left_bottom_corner();
translate([(hinge_inner_diameter)/2,frame_corner_width+plastic_thickness+hinge_gap,0]) rotate([0,0,90]) hinge();
