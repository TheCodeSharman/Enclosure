/*
Specialized construction functions specifically for the enclosure.
By combining these operators the various instances of enclosur pieces 
can be constructed.
*/
include <parameters.scad>;
use <utility.scad>;

module interlock() {
    ra = knob_diameter/2;
    rb = lug_diameter/2;
    
    color("DarkSeaGreen")
        rotate([0,90,90]) 
            rotate_extrude()
                polygon([[0,0],[0,lug_height],[rb,lug_height],
                    [rb,2.5],[ra,1],[ra,0]]);
}

module frame( width, height, thickness, roundness ) {
    color("SteelBlue") 
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

module frame_connector_corner() {
    translate([panel_thickness*1.7,panel_thickness*0.70, 0]) 
        color("SteelBlue") cornerize()
            frame( frame_corner_width*0.75, frame_connector_depth, 
                frame_thickness*.20, corner_roundness );
        
}

module add_lugs() {   
    union() {
        children(0);

        translate([interlock_offset_x,-lug_height,interlock_offset_z]) 
            interlock();

        translate([interlock_offset_x,-lug_height,
                interlock_offset_z+interlock_gap])
            interlock(); 
    } 
}

module add_connector() {
    union() {
        children(0);
        translate([0,0,frame_corner_height])
            frame_connector_corner();
    }
}

module add_hinge_post( top=false ) {
    hinge_position=[frame_corner_width+plastic_thickness+hinge_gap,
          hinge_inner_diameter/2, (top?frame_corner_height:0)];
    union() {
        children(0);
        fix_preview() translate(hinge_position) 
            mirror(top?[0,0,1]:[0,0,0])
                hinge_post();
    }
}

module add_outside_frame( height ) {
    color("SteelBlue")
    union() {
        children(0);
        translate([-plastic_thickness,-plastic_thickness,0])
            frame( frame_corner_width+plastic_thickness, height, frame_thickness,
                corner_roundness);
        translate([14.5,0.05,height/2])
            rotate([0,0,8])
            cube([frame_corner_width/2,plastic_thickness,height],true);
    }
}

module hinge_post() {
     union() {
        difference() {
            
            // add material to support the hinge and fill 
            // the gap betwen the perspex doors and the plastic frame
            translate([-hinge_inner_diameter*2, 
                    hinge_inner_diameter/2,0]) 
                rotate([0,0,-90])
                    frame( hinge_inner_diameter*3+1, 
                        frame_corner_height, hinge_inner_diameter, 
                        corner_roundness );
            
            // create a negative space that snuggly fits the hinge
            union() {
                height = hinge_height-hinge_inner_diameter;
                translate([0,0,height/2]) 
                    cube([hinge_inner_diameter+1,
                        hinge_inner_diameter+1,height],true);
                
                rotate([0,0,-90]) 
                    translate([0,0,-1.4]) 
                        scale([1,1.05,1.1]) hinge();
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
        cylinder(d=hinge_inner_diameter+tolerance, height+1);
        
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

module frame_vertical() {
    difference() {
        union() {   
            frame_corner( frame_corner_width, 
                frame_vertical_height, frame_thickness, 
                corner_roundness );
            
             translate([hinge_inner_diameter*2, 
                    hinge_inner_diameter,0]) 
                rotate([0,0,-90])
                    frame( hinge_inner_diameter*3+2.6, 
                        frame_vertical_height, 
                        hinge_inner_diameter, 
                        corner_roundness );
            // add connector
            translate([0,0,frame_vertical_height])
                frame_connector_corner();
        }
        // make a tight fit
        scale(0.9999) frame_connector_corner();
    }
        
}