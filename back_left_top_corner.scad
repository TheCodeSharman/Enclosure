include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module back_left_top_corner() {              
    difference() {
        translate([0,enclosure_depth,
                enclosure_height-frame_corner_height])
            mirror([0,1,0]) 
                difference() {
                    add_lugs() 
                    extend_frame_x()
                        color("SteelBlue")
                        frame_corner( frame_corner_width,
                            frame_corner_height,frame_thickness,
                            corner_roundness);   
                    frame_connector_corner();
                }
        fix_preview3() left_wall_panel();
        fix_preview3() back_wall_panel();
    }
}

%fix_preview3() left_wall_panel();
%fix_preview3() back_wall_panel();
back_left_top_corner();