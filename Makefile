SCADC?=openscad -q

SCAD_FILES = back_left_bottom_corner.scad \
		back_left_top_corner.scad \
		back_left_vertical_a.scad \
		back_left_vertical_b.scad \
		back_right_bottom_corner.scad \
		back_right_bottom_snaplock.scad \
		back_right_top_corner.scad \
		back_right_top_snaplock.scad \
		back_right_vertical_a.scad \
		back_right_vertical_b.scad \
		bottom_left_hinge.scad \
		bottom_right_hinge.scad \
		front_left_bottom_corner.scad \
		front_left_top_corner.scad \
		front_left_vertical_a.scad \
		front_left_vertical_b.scad \
		front_right_bottom_corner.scad \
		front_right_bottom_snaplock.scad \
		front_right_top_corner.scad \
		front_right_top_snaplock.scad \
		front_right_vertical_a.scad \
		front_right_vertical_b.scad \
		top_left_hinge.scad \
		top_right_hinge.scad

STL_TARGETS=$(SCAD_FILES:.scad=.stl)

.PHONY: models clean
models: $(STL_TARGETS)

%.stl: %.scad
	$(SCADC) -o $@ $<

clean:
	rm -f *.stl