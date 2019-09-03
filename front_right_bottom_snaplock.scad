include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>
use <front_right_bottom_corner.scad>

module front_right_bottom_snaplock() {
    translate([enclosure_width - snaplock_size, 0, -shelf_height])
        color("Magenta")
        snaplock();
}

%front_right_bottom_corner();
translate([0,-30,0])
    front_right_bottom_snaplock();