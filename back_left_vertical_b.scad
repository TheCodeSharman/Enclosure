include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module back_left_vertical_b() {
    difference() {
        translate([0,enclosure_depth,frame_corner_height+frame_vertical_height])
            mirror([0,1,0])
                frame_vertical();
        fix_preview() back_wall_panel();
        fix_preview() left_wall_panel();
    }
}

%back_wall_panel();
back_left_vertical_b();