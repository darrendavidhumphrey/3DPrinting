
outerRad = 21.5;
innerRad = 10.5;
height = 40;
bandWidth = 8;
bandThickness = 3;
bandInsetFromEdge = 2;

e = 0.2;

$fa = 6;
$fs = 0.4;

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
        e = 0.2;
        cylinder(r=outer,h=height);
        translate([0,0,-e]);
        cylinder(r=outer-thickness,h=height+e);
    }
}

// Make half of a thin cylinder
module half_cylinder_oth(outer,thickness,height) {
   difference() {
        e = 0.2;
        cylinder_oth(outer,thickness,height);
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


