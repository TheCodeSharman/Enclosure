use <support.scad>
use <construction.scad>

module back_left_bottom_corner() {
    difference() {
        translate([0,enclosure_depth,0])
            mirror([0,1,0])
                add_lugs()
                    add_connector()
                        frame_corner( frame_corner_width, 
                            frame_corner_height,frame_thickness,
                            corner_roundness);
        fix_preview2() left_wall_panel();
        fix_preview2() back_wall_panel();
    }
}