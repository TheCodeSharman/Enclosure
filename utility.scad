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