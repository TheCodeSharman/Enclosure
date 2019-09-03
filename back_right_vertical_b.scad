include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module back_right_vertical_b() {
    difference() {
        translate([enclosure_width,enclosure_depth,frame_corner_height+frame_vertical_height])
            mirror([0,1,0])
            mirror([1,0,0])
                add_outside_frame(frame_vertical_height) 
                    color("SteelBlue")
                    frame_vertical();
        fix_preview() right_wall_panel();
    }
}