include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

/*
Each seperate enclosure component has a seperate module; they are built using the
construction.scad modules in various configurations.
*/
use <back_left_bottom_corner.scad>
use <back_right_bottom_corner.scad>
use <back_left_top_corner.scad>
use <back_right_top_corner.scad>
use <bottom_left_hinge.scad>
use <bottom_right_hinge.scad>
use <top_left_hinge.scad>
use <top_right_hinge.scad>
use <front_left_top_corner.scad>
use <front_left_bottom_corner.scad>
use <front_right_bottom_corner.scad>
use <front_right_top_corner.scad>
use <front_left_vertical_a.scad>
use <front_left_vertical_b.scad>
use <front_right_vertical_a.scad>
use <front_right_vertical_b.scad>
use <back_right_vertical_a.scad>
use <back_right_vertical_b.scad>
use <back_left_vertical_a.scad>
use <back_left_vertical_b.scad>
use <front_right_bottom_snaplock.scad>
use <back_right_bottom_snaplock.scad>
use <front_right_top_snaplock.scad>
use <back_right_top_snaplock.scad>
/* Alter the following to change the global configuration displayed in preview */
open=true;         // are the doors open or closed?
exploded=false;     // show the verticl pieces in an exploded view
plater=false;       // turn on the plater view even when in preview mode

/*
Each instance of an enclosure piece is created and positionined in 3D space
to fit with the support objects in preview mode. When rendering for final
print the peices are placed in a plater arrangement ready for import into
slicing software.
*/
if (!plater) {
    if (exploded) {
        exploded_view();
    } else {
        context_assembly();
    }
} else {
    plater_assembly();
}

module plater_assembly() {
    translate([-20,-75,hinge_height-hinge_inner_diameter]) 
        rotate([0,180,-90])
            bottom_left_hinge();
    front_left_bottom_corner();
    translate([0,-50,-frame_corner_height])
        front_left_vertical_a();
}

module exploded_view() {

    translate([0,0,30])
    explode([0,0,30]) {
        back_left_bottom_corner();
        back_left_vertical_a();
        back_left_vertical_b();
        back_left_top_corner();
    }

    translate([0,0,30])
    explode([0,0,30]) {
        back_right_bottom_corner();
        back_right_vertical_a();
        back_right_vertical_b();
        back_right_top_corner();
    }

    explode([0,0,30]) {
        bottom_left_hinge();
        front_left_bottom_corner();
        front_left_vertical_a();
        front_left_vertical_b();
        front_left_top_corner();
        top_left_hinge();
    }

    explode([0,0,30]) {
        bottom_right_hinge();
        front_right_bottom_corner();
        front_right_vertical_a();
        front_right_vertical_b();
        front_right_top_corner();
        top_right_hinge();
    }

    translate([0,-30,30])
        front_right_bottom_snaplock();
    
    translate([0,-30,shelf_height+frame_corner_height])
        front_right_top_snaplock();
   
    translate([0,30,30])
        back_right_bottom_snaplock();

    translate([0,30,shelf_height])
        back_right_top_snaplock();
}

module context_assembly() {
    %left_wall_panel();
    %back_wall_panel();
    %right_wall_panel();

    %left_door(open);
    %right_door(open);
    
    back_left_bottom_corner();
    back_left_vertical_a();
    back_left_vertical_b();
    back_left_top_corner();

    bottom_left_hinge(open);
    front_left_bottom_corner();
    front_left_vertical_a();
    front_left_vertical_b();
    front_left_top_corner();
    top_left_hinge(open);
    
    bottom_right_hinge(open);
    front_right_bottom_corner();
    front_right_vertical_a();
    front_right_vertical_b();
    front_right_top_corner();
    top_right_hinge(open);
    front_right_bottom_snaplock();
    front_right_top_snaplock();

    back_right_bottom_corner();
    back_right_vertical_a();
    back_right_vertical_b();
    back_right_top_corner();
    back_right_bottom_snaplock();
    back_right_top_snaplock();
}