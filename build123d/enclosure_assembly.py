
# %%
from ocp_vscode import *
from build123d import *
from copy import *
# %% 

# Enclosures internal boundary
boundary=Box(603.0,535.0,475.0)
boundary.label="boundary"
boundary.color=Color("tomato", 0.1)

# Panel joints
left_face = (boundary.faces() > Axis.X)[0]
back_face = (boundary.faces() < Axis.Y)[0]
right_face = (boundary.faces() < Axis.X)[0]
front_left_edge = (left_face.edges() > Axis.Y)[0]
front_right_edge = (right_face.edges() > Axis.Y)[0]

RigidJoint(
    label="left panel", 
    to_part=boundary, 
    joint_location=left_face.center_location*Rot(0,0,90)*Pos(0,25/2,0)
)

RigidJoint(
    label="back panel", 
    to_part=boundary, 
    joint_location=back_face.center_location*Rot(0,0,90)*Pos(0,25/2,0)
)

RigidJoint(
    label="right panel", 
    to_part=boundary, 
    joint_location=right_face.center_location*Rot(0,0,90)*Pos(0,-25/2,0)
)

# Door hinge joints
hinge_offset=25

RevoluteJoint(
    label="left door hinge", 
    to_part=boundary, 
    axis=Axis(front_left_edge).located(Pos(hinge_offset,0,0)),
    angular_range=(270,360)
)

RevoluteJoint(
    label="right door hinge", 
    to_part=boundary, 
    axis=Axis(front_right_edge.reversed()).located(Pos(-hinge_offset,0,0)),
    angular_range=(270,360)
)

# Wall panels
panel = Box(535.0, 450.0, 6.0)
panel.label = "panel"

RigidJoint(
    label="top", 
    to_part=panel, 
    joint_location=(panel.faces() < Axis.Z)[0].center_location
)

# Doors
door_panel = Box(253.0, 2.75, 475.0)
door_panel.label = "door panel"
door_panel.color = Color("gray", 0.3)
door_bottom_face = (door_panel.faces() > Axis.Z)[0]

RigidJoint(
    label="hinge", 
    to_part=door_panel, 
    joint_location=(door_bottom_face.edges() > Axis.X)[0].location
)

# Assembly
left_panel, right_panel, back_panel = copy(panel), copy(panel), copy(panel)
left_door, right_door = copy(door_panel), copy(door_panel)

doors_opened = False
boundary.joints["right panel"].connect_to(left_panel.joints["top"])
boundary.joints["left panel"].connect_to(right_panel.joints["top"])
boundary.joints["back panel"].connect_to(back_panel.joints["top"])
boundary.joints["left door hinge"].connect_to(left_door.joints["hinge"], angle=270 if doors_opened else 360)
boundary.joints["right door hinge"].connect_to(right_door.joints["hinge"], angle=270 if doors_opened else 360)

assembly = Compound(
    label="enclosure", 
    children=[boundary, left_panel, right_panel, back_panel, left_door, right_door]
)

show(assembly, render_joints=True),
# %%
