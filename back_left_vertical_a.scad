include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module back_left_vertical_a() {
    difference() {
        translate([0,enclosure_depth,frame_corner_height])
            mirror([0,1,0])
                color("SteelBlue")
                frame_vertical();
        fix_preview() back_wall_panel();
        fix_preview() left_wall_panel();
    }
}

%fix_preview() left_wall_panel();
%fix_preview() back_wall_panel();
back_left_vertical_a();