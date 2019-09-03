include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>
use <front_right_top_corner.scad>

module front_right_top_snaplock() {
    difference() {
        translate([enclosure_width, 0, enclosure_height+shelf_height])
            mirror([1,0,0])
            mirror([0,0,1])
                color("Magenta")
                snaplock(top=true);
        fix_preview() right_wall_panel();
    }
}

fix_preview() %right_wall_panel();
%front_right_top_corner();
translate([0,-30,0])
    front_right_top_snaplock();