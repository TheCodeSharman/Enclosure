$fn=50;

// Wall thickness and tolerance
plastic_thickness=2.0;
tolerance=0.22;

// Specify enclosure dimensions
enclosure_height=475.0;
enclosure_depth=535.0;

// Wall panel dimensions
panel_thickness=6.0;
panel_height=450.0;
panel_width=535.0;
panel_offset_z = enclosure_height - panel_height;

// Door panel dimensions
door_panel_thickness=3.0;
door_panel_width=250.0;
door_panel_height=475.0;
door_hinge_offset=6.5;

// Frame
frame_corner_width=30.0;
frame_corner_height=79.0;
frame_thickness = plastic_thickness*2 + panel_thickness;
frame_side = (enclosure_height - frame_corner_height*2)/2;
frame_clip_height=50.5;
corner_roundness=0.9;
frame_vertical_height = (enclosure_height-frame_corner_height*2)/2;
frame_connector_depth = 8.0;

// Interlock
knob_diameter=9.8;
lug_diameter=6.2;
lug_gap=1.4;
lug_height = lug_gap+2.15;
interlock_offset_x=15.0;
interlock_offset_z=27.0;
interlock_gap=32;

// Door hinge
hinge_inner_diameter=10;
hinge_height=25;
hinge_length=53;
hinge_gap = 9.6;
hinge_clearance = 1.5;
hinge_ring_thickness=3.0;
hinge_thickness=plastic_thickness*2 + door_panel_thickness;
hinge_offset=6.5+plastic_thickness;

enclosure_width=2*(frame_corner_width+plastic_thickness+hinge_gap
    +door_hinge_offset) + door_panel_width*2 +tolerance;