include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module bottom_left_hinge(open=false) {
    difference() {
        translate([frame_corner_width+plastic_thickness+hinge_gap,
                (hinge_inner_diameter)/2,0]) 
            rotate([0,0,open?-90:0]) hinge();
        fix_preview() left_door(open);
    }
}

bottom_left_hinge();