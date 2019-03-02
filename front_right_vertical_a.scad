include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module front_right_vertical_a() {
    difference() {
        translate([enclosure_width,0,frame_corner_height])
            mirror([1,0,0])
                add_outside_frame(frame_vertical_height) 
                    frame_vertical();
        fix_preview() right_wall_panel();
    }
}