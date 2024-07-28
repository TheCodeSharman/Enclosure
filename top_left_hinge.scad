include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module top_left_hinge(open=false) {
    difference() {
        translate([0,0,enclosure_height])
            translate([frame_corner_width+plastic_thickness+
                hinge_gap,(hinge_inner_diameter)/2,0])
                mirror([0,0,1]) 
                    rotate([0,0,open?-90:0]) 
                    color("Salmon")
                    union() {
                        hinge();
                        door_frame_arm();
                    }
        fix_preview() left_door(open);
    }
}

%fix_preview() left_door();
top_left_hinge();
