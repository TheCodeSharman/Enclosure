/*
Provides support objects that are used to model the environment of the enclosure
to ensure the pieces slot together and fit properly.
*/
include <parameters.scad>;
use <utility.scad>;

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
    translate([(enclosure_width-panel_width)/2,
            enclosure_depth-panel_thickness-plastic_thickness,
            0]) 
        rotate([-90,-90,0]) 
            wall_panel();
}

module right_wall_panel() {
    translate([enclosure_width,0,panel_offset_z]) 
        rotate([0,-90,0]) 
            wall_panel();
}

module left_door(open=false) {
    translate([frame_corner_width+plastic_thickness+hinge_gap,
            hinge_inner_diameter/2,0]) 
        rotate([90,0,open?-90:0]) 
            translate([door_hinge_offset,0,hinge_offset-
                    door_panel_thickness/2])
                door_panel();
}

module right_door(open=false) {
    translate([enclosure_width,0,0])  
        mirror([1,0,0]) left_door(open);
}