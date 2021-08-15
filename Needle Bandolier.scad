
// All units in mm 

outerRad = 23.0/2;  // Radius of outside (size of jar)

needleRadius = 10.5/2;

innerRad = needleRadius + 0.1;  // Radius of inside (size of needle + gap)

height = 40; // overall height

bandWidth = 6.5;   // Width of the band that holds the leather strap
bandThickness = 3; // How deep of a groove to make for band
bandInsetFromEdge = 1.5;  // How far band is from each end


// When cutting using the difference operator, it is necessary
// for the cutting tool to be slightly larger than the target to
// ensure that math errors don't happen
// "e" is the global 
e = 0.2;

// FA is minimum angle for an arc.  Smaller = smoother
// For faster previews, set $fa = 10
// For smooth renders, set $fa = 1.0 or less
$fa = 0.5;

// FS is the minimum fragment size
// There is no use having fragments smaller than layer height
$fs = 0.2;

// Make a cylinder defined by an inner and outer radius and height
module cylinder_oih(inner,outer,height) {
    difference() {
        offset = 1;
        cylinder(r=outer,h=height);
        translate([0,0,-offset]);
        cylinder(r=inner,h=height+offset);
    }
}

// Make a cylinder defined by outer radius, thickness and height
module cylinder_oth(outer,thickness,height) {
    difference() {
        cylinder(r=outer,h=height);
        translate([0,0,-e]);
        cylinder(r=outer-thickness,h=height+e);
    }
}

// Make half of a cylinder
module half_cylinder_oth(outer,thickness,height) {
   difference() {
        cylinder_oth(outer,thickness,height);
       
        // Make a cube to cut cylinder in half
        translate([0,-outer,-e]) cube([2*outer,2*outer,height +2*e]);
    }
}


difference() { 
    // Start with cylinder for main body
    cylinder_oih(innerRad,outerRad,height);

        // Now build a cutting tool to subtract from the cylinder
        // by combining several pieces of geometry
        union() {
            // First cut is a half ring, inset from the bottom edge
            translate([0,0,bandInsetFromEdge])
                    half_cylinder_oth(outerRad,bandThickness,bandWidth);

            // A second half ring, inset from the top edge
            translate([0,0,height-bandInsetFromEdge-bandWidth])
                    half_cylinder_oth(outerRad,bandThickness,bandWidth);
 
            // Cut out the middle using a cube
            translate([-outerRad,-outerRad,bandWidth+bandInsetFromEdge*2]) 
            cube([outerRad,2*outerRad,height-(bandWidth*2+bandInsetFromEdge*4) +2*e]);

        }
    }


