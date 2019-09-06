include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module front_left_vertical_b() {
    difference() {
        translate([0,0,frame_corner_height+frame_vertical_height])
            color("SteelBlue")
            frame_vertical();
        fix_preview() left_wall_panel();
    }
}

%fix_preview() left_wall_panel();
front_left_vertical_b();