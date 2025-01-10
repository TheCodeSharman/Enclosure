
# %%
from ocp_vscode import *
from build123d import *
from copy import *

# %% [markdown]

# # 3d Printer Enclosure

# In order to get high quality prints, particularly when the 3d printer is in a uncooontrolled
# environment, it's important to have an enclosure, I wanted to have something a little bit
# more permanent that a box, and I was space challenged, so I wanted to be able to build the
# enclosure into an existing shelf.
#
# ## Requirements
# 1. MUST eliminate drafts and retain heat well enough for reliable prints.
# 2. MUST allow a smooth feed from filament dry boxes mounted on the wall outside the enclosure.
# 3. MUST have transparent doors for observation purposes.
# 4. MUST have power supply outside the enclosure.
# 5. MUST integrate into existing shelf space.
# 6. SHOULD use as little filament as possible.
# 7. SHOULD avoid very long prints times.
# 8. SHOULD prefer non printed parts when simple geometry (e.g. a strip of wood) will work.
# 9. SHOULD have web camera for monitoring remotely.
# 10. SHOULD have active heating in order to avoid MIN_TEMP errors in winter.
# 11. SHOULD have a cooling fan to allow printing PLA in summer.
# 12. SHOULD integrate with Octoprint in order to behave like printer with a heated chamber.

# %% [markdown]
# Firstly, in order to use as a reference for the placement of printed parts, we model the non
# printed parts used in the enclosure assembly:
#  - The wall panels 
#  - The door panels
#  - The existing shelf space we need to fit into
#  - The metal shelf edging that we need to connect into


# %%

# Define space we have available for enclosure
boundary=Box(600.0,535.0,475.0)
boundary.label="boundary"
boundary.color=Color("tomato", 0.1)

# Some reference geometry for later to make things easier
left_face = (boundary.faces() > Axis.X)[0]
back_face = (boundary.faces() < Axis.Y)[0]
right_face = (boundary.faces() < Axis.X)[0]
front_left_edge = (left_face.edges() > Axis.Y)[0]
front_right_edge = (right_face.edges() > Axis.Y)[0]

show(boundary, render_joints=True)

# %%

# Model the MDF panels used to build the enclosure walls.
panel = Box(535.0, 450.0, 6.0)
panel.label = "panel"
panel.color = Color("wheat")

RigidJoint(
    label="top", 
    to_part=panel, 
    joint_location=(panel.faces() < Axis.Z)[0].center_location
)

# Add sone joints to the enclosure to position panels correctly
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

left_panel, right_panel, back_panel = copy(panel), copy(panel), copy(panel)

boundary.joints["right panel"].connect_to(left_panel.joints["top"])
boundary.joints["left panel"].connect_to(right_panel.joints["top"])
boundary.joints["back panel"].connect_to(back_panel.joints["top"])

show(boundary, left_panel, right_panel, back_panel, render_joints=True)

# %%

# Model the transparent doors.
door_panel = Box(253.0, 2.75, 475.0)
door_panel.label = "door panel"
door_panel.color = Color("gray", 0.3)
door_bottom_face = (door_panel.faces() > Axis.Z)[0]
door_hinge_offset_h=25
door_hinge_offset_v=12

doors_opened = True

RigidJoint(
    label="hinge", 
    to_part=door_panel, 
    joint_location=(door_bottom_face.edges() > Axis.X)[0].location*Pos(-door_hinge_offset_h,door_hinge_offset_v,0)
)

# Door hinge joints
hinge_offset_h=22
hinge_offset_v=12

RevoluteJoint(
    label="left door hinge", 
    to_part=boundary, 
    axis=Axis(front_left_edge).located(Pos(hinge_offset_h,hinge_offset_v,0)),
    angular_range=(270,360)
)

RevoluteJoint(
    label="right door hinge", 
    to_part=boundary, 
    axis=Axis(front_right_edge.reversed()).located(Pos(-hinge_offset_h,hinge_offset_v,0)),
    angular_range=(270,360)
)

left_door, right_door = copy(door_panel), copy(door_panel)


boundary.joints["left door hinge"].connect_to(left_door.joints["hinge"], angle=270 if doors_opened else 360)
boundary.joints["right door hinge"].connect_to(right_door.joints["hinge"], angle=270 if doors_opened else 360)

#show(boundary, left_door, right_door, render_joints=True)


# %%

# Assemble all the component above to use as a guide to build printed parts.
assembly = Compound(
    label="enclosure", 
    children=[boundary, left_panel, right_panel, back_panel, left_door, right_door]
)

show(assembly, render_joints=False)
# %%
clearance=0.2 * MM
diameter=6.0 * MM
hinge_length=100.0 * MM

# %% Create profile for hinge joint
with BuildSketch() as hinge_profile:
    # Create one half of the hinge joint profile
    hinge_section_length=hinge_length/3
    Rectangle(width=hinge_length/2,height=diameter/2,align=Align.MIN)
    # Construct an edge to cut out the clearance to make the hinge joint mechanism
    with BuildLine():
        l1 = PolarLine(start=(hinge_section_length/2,0), angle=90, length=clearance)
        l2 = PolarLine(start=l1@1, angle=45, length=diameter/2-clearance*2, length_mode=LengthMode.VERTICAL)
        l3 = PolarLine(start=l2@1, angle=90, length=clearance)
    # Sweep the perpendicular line to ensure that the clearance is respected
    sweep(sections=l2.perpendicular_line(length=clearance,u_value=0.5),transition=Transition.RIGHT,mode=Mode.SUBTRACT)
    # Create the rest of the hinge profile by symmetry
    mirror(about=Plane.YZ)

show(hinge_profile,reset_camera=Camera.KEEP)
# %%
