include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module bottom_right_hinge(open=false) {
    difference() {
        translate([enclosure_width - (frame_corner_width+plastic_thickness+hinge_gap),
                (hinge_inner_diameter)/2,0]) 
            mirror([1,0,0])
                rotate([0,0,open?-90:0]) 
                color("Salmon")
                hinge();
        fix_preview() right_door(open);
    }
}

%fix_preview() right_door();
bottom_right_hinge();