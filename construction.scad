/*
Specialized construction functions specifically for the enclosure.
By combining these operators the various instances of enclosure pieces 
can be constructed.
*/
include <parameters.scad>;
use <utility.scad>;

module lug() {
    ra = knob_diameter/2;
    rb = lug_diameter/2;
    rotate([0,90,90]) 
        rotate_extrude()
            polygon([[0,0],[0,lug_height],[rb,lug_height],
                [rb,2.5],[ra,1],[ra,0]]);
}

// extend the corner frame to be symmetrical with the front corner
module extend_frame_x(height=frame_corner_height) {
    union() {
        children();
        color("SteelBlue")
        translate([hinge_inner_diameter*2, hinge_inner_diameter,0]) 
            rotate([0,0,-90])
                frame( hinge_inner_diameter*3+1, 
                    height, hinge_inner_diameter, 
                    corner_roundness );
    }
}

module frame( width, height, thickness, roundness ) {
        linear_extrude(height=height)
            apply_roundness(roundness, $fs =0.01) 
                    square( [thickness, width] );
}

module frame_corner( width, height, thickness, roundness ) {    
    union() {
        mirror([0,1,0]) 
            rotate([0,0,-90])
                frame( width, height, thickness, roundness );
        frame( width, height, thickness + panel_thickness, roundness );
    }   
}

module frame_connector_corner(clearance=0) {
    translate([panel_thickness*1.7,panel_thickness*0.70, 0]) 
        cornerize()
            frame( frame_corner_width*0.75, frame_connector_depth, 
                frame_thickness*.20+clearance, corner_roundness );
        
}

module add_lugs() {   
    union() {
        children();

        color("DarkSeaGreen")
        translate([lug_offset_x,-lug_height,lug_offset_z]) 
            lug();

        color("DarkSeaGreen")
        translate([lug_offset_x,-lug_height,
                lug_offset_z+lug_offset_gap])
            lug(); 
    } 
}

module add_connector(height=frame_corner_height) {
    union() {
        children();

        color("SteelBlue")
        translate([0,0,height])
            frame_connector_corner();
    }
}

module add_hinge_post( top=false ) {
    union() {
        difference() {
            children();

            // create a negative space that snuggly fits the hinge
            translate([frame_corner_width+plastic_thickness+hinge_gap,
                hinge_inner_diameter/2, (top?frame_corner_height:0)])
                mirror(top?[0,0,1]:[0,0,0])
                    union() {
                        height = hinge_height-hinge_inner_diameter;
                        translate([0,0,height/2-0.65]) 
                            cube([hinge_inner_diameter+2,
                                hinge_inner_diameter+2,height],true);
                        
                        // hinge open
                        rotate([0,0,-90]) 
                            translate([0,0,-1.4]) 
                                scale(1.05) hinge();
                        // hinge closed
                        rotate([0,0,0]) 
                            translate([0,0,-1.4]) 
                                scale(1.05) hinge();
                    }
            
        }
        color("SteelBlue")
        translate([frame_corner_width+plastic_thickness+hinge_gap,hinge_inner_diameter/2,0])
            cylinder(d=hinge_inner_diameter, frame_corner_height);
    }
}

module add_outside_frame( height ) {
    union() {
        children();
        translate([-plastic_thickness,-plastic_thickness,0])
            color("SteelBlue")
            frame( frame_corner_width+plastic_thickness, height, frame_thickness,
                corner_roundness);
        translate([14.5,0.05,height/2])
            color("SteelBlue")
            rotate([0,0,8])
            cube([frame_corner_width/2,plastic_thickness,height],true);
    }
}

module hinge() {
    height = hinge_height-hinge_inner_diameter;
    width = hinge_inner_diameter+hinge_ring_thickness;
    difference() {
        
        // create the base shape for the hinge
        union() {    
            cylinder(d=width, height);
            
            translate([hinge_inner_diameter*3+hinge_clearance,
                -hinge_offset,height/2-plastic_thickness/2]) 
                cube([hinge_length,hinge_thickness,
                    height+plastic_thickness],true);
           
            translate([2.52,-5.2,height/2]) 
                rotate([0,0,40]) 
                    cube([hinge_inner_diameter,
                        width+1,height],true);
        }
        
        // remove a hole for the hinge post to slide into
        cylinder(d=hinge_inner_diameter+tolerance_smooth, height+1);
        
        // trim the left corner
        translate([4,-17.5,height/2-1]) 
            rotate([0,0,145]) 
                cube([50,width-2,height+3],true);
        
        // smooth the tranistion to the bottom edge
        translate([19,-10,height/2-17.85]) 
            rotate([-88.5,0.1,96]) 
                cube([40,20,100],true);
        
        // add a chamfer to right corner
        translate([hinge_length+8,0,height+25]) 
            rotate([0,45,0]) 
            cube(50,true);
    }   
}

module add_connector_slot() {
    difference() {
        children();
        frame_connector_corner(tolerance_tight);
    }
}

module frame_vertical() {
    add_connector_slot()
    add_connector(frame_vertical_height)
    extend_frame_x(frame_vertical_height)
        frame_corner( frame_corner_width, 
            frame_vertical_height, frame_thickness, 
            corner_roundness );          
}

module add_snap_lock_slot() {
    difference() {
        children();
        translate([0,0,-shelf_height])
            snaplock(tolerance_tight);
    }
}

module snaplock(clearance=0) {
    
    union() {
        difference() {
            translate([snaplock_size,-snaplock_thickness*3,-plastic_thickness])
                rotate([0,0,90])
                    frame(snaplock_size+clearance,shelf_height+snaplock_connector_size+plastic_thickness+clearance,
                        snaplock_width*2+plastic_thickness, corner_roundness);
            fix_preview2() cube([snaplock_size*1.1,snaplock_width+plastic_thickness,shelf_height]);
        }
        // lug at bottom
        translate([snaplock_size - snaplock_size/2 - plastic_thickness/2,plastic_thickness-0.2,1])
            rotate([90,90,90])
                frame(plastic_thickness,plastic_thickness,plastic_thickness,corner_roundness);
        // connector
        translate([3*snaplock_size/4-connector_thickness/2,
            frame_connector_depth+snaplock_thickness,
            shelf_height+snaplock_connector_size/2 - (snaplock_connector_size/4)])
            rotate([90,0,0])
            frame(frame_connector_depth,snaplock_connector_size/2,
                connector_thickness,corner_roundness);
        translate([snaplock_size/4-connector_thickness/2,
            frame_connector_depth+snaplock_thickness,
            shelf_height+snaplock_connector_size/2 - (snaplock_connector_size/4)])
            rotate([90,0,0])
            frame(frame_connector_depth,snaplock_connector_size/2,
                connector_thickness,corner_roundness);
    }
}