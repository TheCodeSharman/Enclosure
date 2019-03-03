include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module front_right_top_corner() {
    difference() {
        translate([enclosure_width,0,enclosure_height-frame_corner_height]) 
            mirror([1,0,0])
            difference() {
                add_hinge_post(top=true)  
                add_outside_frame(frame_corner_height) 
                extend_frame_x()
                    frame_corner( frame_corner_width, 
                        frame_corner_height,frame_thickness, 
                        corner_roundness);
                scale(0.9999) frame_connector_corner();
            }
        fix_preview() right_wall_panel();
    }
}