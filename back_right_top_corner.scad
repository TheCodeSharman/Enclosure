include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module back_right_top_corner() {
    difference() {
        translate([enclosure_width,enclosure_depth,enclosure_height-frame_corner_height])
            mirror([0,1,0])
            mirror([1,0,0])
                difference() {
                    add_snap_lock_slot(top=true)
                    add_outside_frame(frame_corner_height) 
                    extend_frame_x()
                        color("SteelBlue")
                        frame_corner( frame_corner_width, 
                            frame_corner_height,frame_thickness,
                            corner_roundness);
                    frame_connector_corner();
                }
                    
        fix_preview2() right_wall_panel();
        fix_preview3() back_wall_panel();
    }
}

%fix_preview2() right_wall_panel();
%fix_preview3() back_wall_panel();
back_right_top_corner();