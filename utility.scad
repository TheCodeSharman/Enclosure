/*
Generically useful utility functions.
*/

// applies roundness without altering dimensions of object
module apply_roundness(r)
    offset(r) offset(delta=-r) children(0);

// makes a corner piece by mirroring and rotating one side
module cornerize() {
    union() {
        children(0);
        mirror([0,1,0]) 
            rotate([0,0,-90])
                children(0);
    }
} 

module explode(vector) {
    for(i=[0:$children-1])
        translate(vector*i)
            children(i);

}

module fillet_cube(size,center,fillet_radius) {
    translate([(center?0:fillet_radius),(center?0:fillet_radius),(center?-size[2]/2:0)])
    linear_extrude(size[2])
        offset(fillet_radius) 
            square(size=[size[0]-fillet_radius*2,size[1]-fillet_radius*2],center=center);
}

/*
 The fix_preview series of functions are used to make small
 translations in order to reduce conincident plane artifacts
 from the preview mode. 

 It would be nice to have just one module for this but I haven't
 figured out a way of doing this generically - so the following
 uses a small translation in different directions depending on
 the use case needed.
*/
module fix_preview() {
    translate($preview?[-0.001,-0.001,-0.001]:[0,0,0])
        children(0);
}

module fix_preview2() {
    translate($preview?[-0.001,0.001,-0.001]:[0,0,0])
        children(0);
}

module fix_preview3() {
    translate($preview?[-0.001,0.001,0.001]:[0,0,0])
        children(0);
}