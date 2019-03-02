include <parameters.scad>;
use <utility.scad>;
use <support.scad>;
use <construction.scad>;

/*
Each seperate enclsoure piece has a seperate module; they are built using the
constrcution.scad modules in various configurations.
*/
use <back_left_bottom_corner.scad>;
use <back_left_top_corner.scad>;
use <bottom_left_hinge.scad>;

/* Alter the following to change the global configuration displayed in preview */
open=true;         // are the doors open or closed?
exploded=false;     // show the verticl pieces in an exploded view
plater=false;       // turn on the plater view even when in preview mode
working=true;

/*
Each instance of an enclosure piece is created and positionined in 3D space
to fit with the support objects in preview mode. When rendering for final
print the peices are placed in a plater arrangement ready for import into
slicing software.
*/
if ($preview && !plater) {
    if (exploded) {
        exploded_view();
    } else if (working) { 
        working_view();
    } else {
        context_view();
    }
} else {
    plater_view();
}

module working_view() {
    front_right_bottom_corner();
}

module plater_view() {
    // ready for printing
    translate([-20,-75,hinge_height-hinge_inner_diameter]) 
        rotate([0,180,-90])
            bottom_left_hinge();
    front_left_bottom_corner();
    translate([0,-50,-frame_corner_height])
        front_left_vertical_a();
}

module exploded_view() {
    translate([0,0,90])
        front_left_top_corner();
    
    translate([0,0,30])
        front_left_vertical_a();
    
    translate([0,0,60])
        front_left_vertical_b();
    
    front_left_bottom_corner();
    
    translate([0,0,120])
        top_left_hinge();
    
    translate([0,0,-30])
        bottom_left_hinge();
}

module context_view() {
    %left_wall_panel();
    %back_wall_panel();
    %right_wall_panel();

    %left_door(open);
    %right_door(open);
    
    back_left_bottom_corner();
    back_left_top_corner();

    front_left_top_corner();
    front_left_vertical_a();
    front_left_vertical_b();
    front_left_bottom_corner();

    top_left_hinge(open);
    bottom_left_hinge(open);
    
    front_right_top_corner();
    front_right_vertical_a();
    front_right_vertical_b();
    front_right_bottom_corner();
    
    top_right_hinge(open);
    bottom_right_hinge(open);
}


module bottom_right_hinge(open=false) {
    difference() {
        translate([enclosure_width - (frame_corner_width+plastic_thickness+hinge_gap),
                (hinge_inner_diameter)/2,0]) 
            mirror([1,0,0])
                rotate([0,0,open?-90:0]) hinge();
        fix_preview() left_door(open);
    }
}

module top_left_hinge(open=false) {
    difference() {
        translate([0,0,enclosure_height])
            translate([frame_corner_width+plastic_thickness+
                hinge_gap,(hinge_inner_diameter)/2,0])
                mirror([0,0,1]) 
                rotate([0,0,open?-90:0]) hinge();
        fix_preview() left_door(open);
    }
}

module top_right_hinge(open=false) {
    difference() {
        translate([0,0,enclosure_height])
            translate([enclosure_width - (frame_corner_width+plastic_thickness+
                hinge_gap),(hinge_inner_diameter)/2,0])
                mirror([1,0,0]) 
                    mirror([0,0,1]) 
                        rotate([0,0,open?-90:0]) hinge();
        fix_preview() left_door(open);
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

module front_left_top_corner() {
    difference() {
        translate([0,0,enclosure_height-frame_corner_height]) 
            difference() {
                add_hinge_post(top=true) 
                    add_lugs() 
                        frame_corner( frame_corner_width, 
                            frame_corner_height,frame_thickness, 
                            corner_roundness);
                scale(0.9999) frame_connector_corner();
            }
        fix_preview() left_wall_panel();
    }
}

module front_left_bottom_corner() {
    add_hinge_post(top=false)
        add_lugs()
            add_connector() 
                difference() {
                    frame_corner( frame_corner_width, 
                        frame_corner_height,frame_thickness, 
                        corner_roundness);
                    fix_preview() left_wall_panel();
                }
}

module front_right_bottom_corner() {
    translate([enclosure_width,0,0])
        mirror([1,0,0])
            add_hinge_post(top=false)
                add_connector() 
                    difference() {
                        union() {
                            frame_corner( frame_corner_width, 
                                frame_corner_height,frame_thickness, 
                                corner_roundness);
                            /*frame( frame_thickness, frame_corner_height, frame_thickness,
                                corner_roundness);*/
                        }
                        fix_preview() right_wall_panel();
                    }
}

module front_right_top_corner() {
    difference() {
        translate([enclosure_width,0,enclosure_height-frame_corner_height]) 
            mirror([1,0,0])
            difference() {
                add_hinge_post(top=true)  
                        frame_corner( frame_corner_width, 
                            frame_corner_height,frame_thickness, 
                            corner_roundness);
                scale(0.9999) frame_connector_corner();
            }
        fix_preview() right_wall_panel();
    }
}

module front_left_vertical() {
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

module front_left_vertical_a() {
    difference() {
        translate([0,0,frame_corner_height])
            front_left_vertical();
        fix_preview() left_wall_panel();
    }
}

module front_left_vertical_b() {
    difference() {
        translate([0,0,frame_corner_height+frame_vertical_height])
            front_left_vertical();
        fix_preview() left_wall_panel();
    }
}

module front_right_vertical_a() {
    difference() {
        translate([enclosure_width,0,frame_corner_height])
            mirror([1,0,0])
                front_left_vertical();
        fix_preview() right_wall_panel();
    }
}

module front_right_vertical_b() {
    difference() {
        translate([enclosure_width,0,frame_corner_height+frame_vertical_height])
            mirror([1,0,0])
                front_left_vertical();
        fix_preview() right_wall_panel();
    }
}


