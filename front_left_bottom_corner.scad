include <parameters.scad>
use <utility.scad>
use <support.scad>
use <construction.scad>

module front_left_bottom_corner() {
    difference() {
        add_hinge_post(top=false)
        add_lugs()
        add_connector() 
        extend_frame_x()
            color("SteelBlue")
            frame_corner( frame_corner_width, 
                frame_corner_height,frame_thickness, 
                corner_roundness);
        fix_preview() left_wall_panel();
    }
}

%left_wall_panel();
front_left_bottom_corner();