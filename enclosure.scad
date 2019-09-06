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
plater=true;       // turn on the plater view even when in preview mode

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

    gap_x = 53.5;
    gap_y = 35;

    translate([gap_x+15,-enclosure_depth+frame_corner_width-2,0])
        back_left_bottom_corner();

    translate([gap_x*2,-enclosure_depth-5,-frame_corner_height])
        back_left_vertical_a();

    translate([gap_x*3,-enclosure_depth-5,-(frame_corner_height+frame_vertical_height)])
        back_left_vertical_b();

    translate([gap_x*3,frame_corner_width,0])
        rotate([0,0,180])
            translate([0,-enclosure_depth+frame_corner_width,-(frame_corner_height+frame_vertical_height*2)])
            back_left_top_corner();

    translate([gap_x*5,gap_y*5-50,hinge_height-hinge_inner_diameter]) 
        rotate([0,180,0])
            bottom_left_hinge();

    translate([0,2,0])
        front_left_bottom_corner();

    translate([gap_x*0,-gap_y,-frame_corner_height]) 
        front_left_vertical_a();
    
    translate([gap_x,-gap_y,-(frame_corner_height+frame_vertical_height)]) 
        front_left_vertical_b();

translate([gap_x*4,0,frame_corner_height])
        rotate([0,180,0])
    translate([0,2,-(frame_corner_height+frame_vertical_height*2)])
        front_left_top_corner();

    translate([-30,gap_y*5-30,-(frame_corner_height*2+frame_vertical_height*2-hinge_height+hinge_inner_diameter)])
        top_left_hinge();
   
    translate([gap_x*2-5,gap_y*4+5,0])
        rotate([0,180,0]) 
            translate([-enclosure_depth,0,-hinge_height+hinge_inner_diameter])
                bottom_right_hinge();

    translate([-enclosure_width+frame_corner_width+20,gap_y,0])        
        front_right_bottom_corner();

    translate([-enclosure_width+frame_corner_width+60,gap_y*2,-frame_corner_height])
        front_right_vertical_a();
    
    translate([35,gap_y*3-10,0])
    rotate([0,0,180])
    translate([-enclosure_width+frame_corner_width,0,-(frame_corner_height+frame_vertical_height)])
        front_right_vertical_b();
 
 translate([gap_x*2-frame_corner_width-10,gap_y,frame_corner_height])
        rotate([0,180,0])
    translate([-enclosure_width,0,-(frame_corner_height+frame_vertical_height*2)])
        front_right_top_corner();
    
    translate([-enclosure_width+gap_x*5-20,gap_y*5-30,-(frame_corner_height*2+frame_vertical_height*2-hinge_height+hinge_inner_diameter)])
        top_right_hinge();
    
    translate([gap_x,gap_y*4-10,snaplock_thickness*3])
        rotate([90,0,90])
            translate([-enclosure_width,0,0])
                front_right_bottom_snaplock();

    translate([gap_x*2,gap_y*4-10,snaplock_thickness*3])
        rotate([90,0,90])
            translate([-enclosure_width,0,-enclosure_height])            
                front_right_top_snaplock();

    translate([-enclosure_width+gap_x*3-5,gap_y + frame_corner_width -enclosure_depth,0])  
        back_right_bottom_corner();

    translate([gap_x*2,gap_y*3-4,0])
    rotate([0,0,180])
    translate([-enclosure_width,frame_corner_width -enclosure_depth,-frame_corner_height])
        back_right_vertical_a();
    
    translate([-enclosure_width+gap_x*4-15,gap_y*2+frame_corner_width-enclosure_depth,-(frame_corner_height+frame_vertical_height)])
        back_right_vertical_b();
translate([gap_x*4-frame_corner_width-20,gap_y,frame_corner_height])
        rotate([0,180,0])
    translate([-enclosure_width,frame_corner_width-enclosure_depth,-(frame_corner_height+frame_vertical_height*2)])
        back_right_top_corner();

    translate([gap_x*5-25,20,snaplock_thickness*3])
        rotate([-90,0,0])
            translate([-enclosure_width,-enclosure_depth,0])
                back_right_bottom_snaplock();

    translate([gap_x*5-25,60,snaplock_thickness*3])
        rotate([-90,0,0])
            translate([-enclosure_width,-enclosure_depth,-enclosure_height])
                back_right_top_snaplock();
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

    translate([0,30,shelf_height+frame_corner_height])
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