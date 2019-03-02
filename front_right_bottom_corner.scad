include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module front_right_bottom_corner() {
    difference() {
        translate([enclosure_width,0,0])
            mirror([1,0,0])
                add_hinge_post(top=false)
                add_connector()  
                add_outside_frame(frame_corner_height)               
                    frame_corner( frame_corner_width, 
                        frame_corner_height,frame_thickness, 
                        corner_roundness);                   
        fix_preview() right_wall_panel();
    }
}

%right_wall_panel();
front_right_bottom_corner();