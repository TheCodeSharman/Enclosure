include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>
use <back_right_bottom_corner.scad>

module back_right_bottom_snaplock() {
    translate([enclosure_width - snaplock_size, enclosure_depth, -shelf_height])
        color("Magenta")
        mirror([0,1,0])
        snaplock();
}

%back_right_bottom_corner();
translate([0,30,0])
    back_right_bottom_snaplock();