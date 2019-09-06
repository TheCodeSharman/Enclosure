include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>
use <bottom_right_hinge.scad>

module front_right_bottom_corner() {
    difference() {
        translate([enclosure_width,0,0])
            mirror([1,0,0])
                add_snap_lock_slot(top=false) 
                add_hinge_post(top=false)
                add_connector()  
                add_outside_frame(frame_corner_height) 
                extend_frame_x()          
                    color("SteelBlue") 
                    frame_corner( frame_corner_width, 
                        frame_corner_height,frame_thickness, 
                        corner_roundness);                   
        fix_preview() right_wall_panel();
    }
}

%right_wall_panel();
%bottom_right_hinge();
front_right_bottom_corner();
