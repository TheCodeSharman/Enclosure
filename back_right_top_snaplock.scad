include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>
use <back_right_top_corner.scad>

module back_right_top_snaplock() {
    translate([enclosure_width, enclosure_depth, enclosure_height+shelf_height])
        color("Magenta")
         mirror([1,0,0])
        mirror([0,0,1])
        mirror([0,1,0])
        snaplock(top=true);
}

%back_right_top_corner();
translate([0,30,0])
    back_right_top_snaplock();