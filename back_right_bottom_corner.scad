include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module back_right_bottom_corner() {
    difference() {
        translate([enclosure_width,enclosure_depth,0])
            mirror([0,1,0])
            mirror([1,0,0])
                add_snap_lock_slot(top=false)
                add_outside_frame(frame_corner_height) 
                add_connector() 
                extend_frame_x()
                    color("SteelBlue")
                    frame_corner( frame_corner_width, 
                        frame_corner_height,frame_thickness,
                        corner_roundness);
                    
        fix_preview2() right_wall_panel();
        fix_preview2() back_wall_panel();
    }
}