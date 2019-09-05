include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>
use <front_right_bottom_corner.scad>
use <bottom_right_hinge.scad>

module front_right_bottom_snaplock() {
    translate([enclosure_width - snaplock_size, 0, -shelf_height])
        snaplock();
}

%front_right_bottom_corner();
%bottom_right_hinge();
translate([0,-30,0])
    front_right_bottom_snaplock();