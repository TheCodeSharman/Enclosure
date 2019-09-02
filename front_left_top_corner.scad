include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module front_left_top_corner() {
    difference() {
        translate([0,0,enclosure_height-frame_corner_height]) 
            difference() {
                add_hinge_post(top=true) 
                add_lugs() 
                extend_frame_x()
                    color("SteelBlue")
                    frame_corner( frame_corner_width, 
                        frame_corner_height,frame_thickness, 
                        corner_roundness);
                frame_connector_corner();
            }
        fix_preview() left_wall_panel();
    }
}