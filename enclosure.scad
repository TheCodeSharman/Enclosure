$fn=50;

plastic_thickness=2.0;
tolerance=0.22;

// Specify enclosure dimensions
enclosure_height=475.0;

enclosure_depth=535.0;

// Wall panel dimensions
panel_thickness=6.0;
panel_height=450.0;
panel_width=535.0;
panel_offset_z = enclosure_height - panel_height;

// Door panel dimensions
door_panel_thickness=3.0;
door_panel_width=250.0;
door_panel_height=475.0;
door_hinge_offset=6.5;

// Frame
frame_corner_width=30.0;
frame_corner_height=79.0;
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
hinge_gap = 9.6;
hinge_clearance = 1.5;
hinge_ring_thickness=3.0;
hinge_thickness=plastic_thickness*2 + door_panel_thickness;
hinge_offset=6.5+plastic_thickness;

enclosure_width=2*(frame_corner_width+plastic_thickness+hinge_gap+door_hinge_offset) + door_panel_width*2 +tolerance;

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

// translates an imperceptible difference to avoid coincident faces
// in CSG operations. this is used to remove glitches in preview
module fix_preview() {
    translate($preview?[-0.001,-0.001,-0.001]:[0,0,0])
        children(0);
}

module fix_preview2() {
    translate($preview?[-0.001,0.001,-0.001]:[0,0,0])
        children(0);
}

module fix_preview3() {
    translate($preview?[-0.001,0.001,0.001]:[0,0,0])
        children(0);
}


module wall_panel() {
    cube([panel_height,panel_width,panel_thickness]);
}

module door_panel() {
     cube([door_panel_width,door_panel_height,door_panel_thickness]);
}

module left_wall_panel() {
    translate([panel_thickness,0,panel_offset_z]) 
        rotate([0,-90,0]) 
            wall_panel();
}

module back_wall_panel() {
    translate([(enclosure_width-panel_width)/2,enclosure_depth-panel_thickness-plastic_thickness,panel_offset_z]) 
        rotate([-90,-90,0]) 
            wall_panel();
}

module right_wall_panel() {
    translate([enclosure_width,0,panel_offset_z]) 
        rotate([0,-90,0]) 
            wall_panel();
}

module left_door(open=false) {
    translate([frame_corner_width+plastic_thickness+hinge_gap,hinge_inner_diameter/2,0]) 
        rotate([90,0,open?-90:0]) 
            translate([door_hinge_offset,0,hinge_offset-door_panel_thickness/2])
                door_panel();
}

module right_door(open=false) {
    translate([enclosure_width,0,0])  
        mirror([1,0,0]) left_door(open);
}

module interlock() {
    ra = knob_diameter/2;
    rb = lug_diameter/2;
    
    color("DarkSeaGreen")
        rotate([0,90,90]) 
            rotate_extrude()
                polygon([[0,0],[0,lug_height],[rb,lug_height],[rb,2.5],[ra,1],[ra,0]]);
}

module frame_corner( width, height, thickness, roundCorners ) {         
    color("SteelBlue") 
        cornerize()
            linear_extrude(height=height)
                apply_roundness(roundCorners, $fs =0.01) 
                square( [thickness, width] );
}

module add_lugs() {   
    union() {
        children(0);

        translate([interlock_offset_x,-lug_height,interlock_offset_z]) 
            interlock();

        translate([interlock_offset_x,-lug_height,interlock_offset_z+interlock_gap])
            interlock(); 
    } 
}

module back_left_bottom_corner() {
    difference() {
        translate([0,enclosure_depth,0])
            mirror([0,1,0])
                add_lugs()
                    frame_corner( frame_corner_width, frame_corner_height,frame_thickness, 0.9);
        fix_preview2() left_wall_panel();
        fix_preview2() back_wall_panel();
    }
}

module back_left_top_corner() {              
    difference() {
        translate([0,enclosure_depth,enclosure_height-frame_corner_height])
            mirror([0,1,0]) 
                add_lugs() frame_corner( frame_corner_width, frame_corner_height,frame_thickness, 0.9);   
        fix_preview3() left_wall_panel();
        fix_preview3() back_wall_panel();
    }
}

module hinge_post() {
     union() {
        difference() {
            
            // add material to support the hinge and fill the gap betwen the perspex
            // doors and the patsic frame
            color("SteelBlue")
            translate([-hinge_inner_diameter*2,-hinge_inner_diameter/2,0]) 
                cube([hinge_inner_diameter*2,hinge_inner_diameter,frame_corner_height]);
            
            // create a negative space that snuggly fits the hinge
            union() {
                height = hinge_height-hinge_inner_diameter + tolerance;
                translate([0,0,height/2]) cube([hinge_inner_diameter+1,hinge_inner_diameter+1,height],true);
                
                rotate([0,0,-90]) scale(1.05) hinge();
            }
        }
        color("SteelBlue")
        cylinder(d=hinge_inner_diameter, frame_corner_height);
    }
}

module hinge() {
    height = hinge_height-hinge_inner_diameter;
    width = hinge_inner_diameter+hinge_ring_thickness;
    
    difference() {
        
        // create the base shape for the hinge
        color("Salmon") union() {
            cylinder(d=width, height);
            
            translate([hinge_inner_diameter*3+hinge_clearance,-hinge_offset,height/2]) 
                cube([hinge_length,hinge_thickness,height],true);
            
            translate([hinge_ring_thickness,-width/2.3,height/2]) 
                rotate([0,0,55]) 
                    cube([hinge_inner_diameter*0.7,width,height],true);
        }
        
        // remove a hole for the hinge post to slide into
        cylinder(d=hinge_inner_diameter+tolerance, height+1);
        
        // trim the left corner
        translate([hinge_inner_diameter/2,-width-hinge_inner_diameter/2.9,height/2]) rotate([0,0,70]) cube([hinge_inner_diameter,width,height],true);
        
        // add a chamfer to right corner
        translate([hinge_length+8,0,height+25]) rotate([0,45,0]) cube(50,true);
    }   
}

module bottom_left_hinge(open=false) {
    difference() {
        translate([frame_corner_width+plastic_thickness+hinge_gap,(hinge_inner_diameter)/2,0]) 
            rotate([0,0,open?-90:0]) hinge();
        fix_preview() left_door(open);
    }
}

module top_left_hinge(open=false) {
    difference() {
        translate([0,0,enclosure_height])
            translate([frame_corner_width+plastic_thickness+hinge_gap,(hinge_inner_diameter)/2,0])
                mirror([0,0,1]) 
                rotate([0,0,open?-90:0]) hinge();
        fix_preview() left_door(open);
    }
}

module add_hinge_post( top=false ) {
    hinge_position=[frame_corner_width+plastic_thickness+hinge_gap, hinge_inner_diameter/2, (top?frame_corner_height:0)];
    cutout_height=hinge_height - hinge_inner_diameter + tolerance;
    union() {
        children(0);
        fix_preview() translate(hinge_position) mirror(top?[0,0,1]:[0,0,0])
            rotate([0,0,0]) hinge_post();
    }
}

module front_left_top_corner() {
    difference() {
        translate([0,0,enclosure_height-frame_corner_height]) 
            add_hinge_post(top=true) 
                add_lugs() frame_corner( frame_corner_width, frame_corner_height,frame_thickness, 0.9);
        fix_preview() left_wall_panel();
    }
}

module front_left_bottom_corner() {
        add_hinge_post(top=false)
            add_lugs()
                difference() {
                    frame_corner( frame_corner_width, frame_corner_height,frame_thickness, 0.9);
                    fix_preview() left_wall_panel();
                }
}


/*%left_wall_panel();
%back_wall_panel();
%right_wall_panel();


%left_door(open);
%right_door(open);

back_left_bottom_corner();
back_left_top_corner();
front_left_top_corner();*/
front_left_bottom_corner();

//top_left_hinge(open);
bottom_left_hinge(open);
open=false;