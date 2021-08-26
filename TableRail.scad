// When cutting using the difference operator, it is necessary
// for the cutting tool to be slightly larger than the target to
// ensure that math errors don't happen
// "e" is the global fudge factor for cutting operations
e = 0.2;
e2 = 0.01;

// FA is minimum angle for an arc.  Smaller = smoother
// For faster previews, set $fa = 10
// For smooth renders, set $fa = 1.0 or less
$fa = 0.5;

// FS is the minimum fragment size
// There is no use having fragments smaller than layer height
$fs = 0.2;

// Smoothing for rounded box functions.  Set to 90 for final
smooth = 90;
    
// Unit are mm
railWidth = 89.0;
railHeightInner = 42.0;
railHeightOuter = 79.0;

cardRailShoulder = 4.0;
cardRailWidth = 6.0;
cardRailDepth = 10.0;

objectWidth = 3.0;
smallRadius = 2.0;
bigRadius = 14.0;
railChamferX = 15.0;
railChamferY = 25;

railLowerH = railHeightOuter-railHeightInner;
railLowerW = 60.0;

slotHeight = 19;
slotDepth = 35;
slotShoulder = 7.0;

// A box that is rounded on 2 edges along the x axis
module box_rounded_2x(box_l,box_w,box_h,edge1_r,edge2_r,smooth) {

    ctr = false;
    
    // Roundover by building cube and then subtracting from it using cutting tools 
    difference() {
       cube([box_l, box_w, box_h], center = ctr);
        
        // First rounded edge
        // Translate to front edge of box, make a cutting tool by subtracting a cylinder
        // from a cube
        translate([0, 0, box_h-edge1_r*2]) {
            difference() {
                color("green")
                translate([0,-edge1_r+e2,edge1_r+e2])
                   cube([box_l+2*e2, edge1_r*2+e2, edge1_r*2+e2]);
                color("purple")
                rotate(a=[0,90,0])
                translate([-edge1_r,edge1_r,0])
                    cylinder(box_l+4*e2,edge1_r,edge1_r,$fn=smooth);
            }
        }
           
        // Second rounded edge
        // Translate to back edge of box, make a cutting tool by subtracting a cylinder
        // from a cube
        translate([0, box_w-edge2_r*2, box_h]) 
        rotate([270,0,0]) {
            difference() {
                color("blue")
                translate([0,-edge2_r+e2,edge2_r+e2])
                    cube([box_l+2*e2, edge2_r*2+e2, edge2_r*2+e2], center = ctr);
                color("red") 
                rotate(a=[0,90,0])
                translate([-edge2_r,edge2_r,0])
                    cylinder(box_l+4*e2,edge2_r,edge2_r,center=ctr,$fn=smooth);
            }
        }
        
    }
}

module triangle_ext(points,height) {
    verts = [[0,1,2]];
    color("blue")
    linear_extrude(height = height, center = false, convexity = 10, twist = 0)
        polygon(points,verts);
}

module quad_ext(points,height) {
    verts = [[0,1,2,3]];
    color("blue")
    linear_extrude(height = height, center = false, convexity = 10, twist = 0)
        polygon(points,verts);
}

cardRailPoints = [ [0,cardRailDepth],[cardRailWidth,cardRailDepth],[cardRailWidth,0],[cardRailWidth-3,0]];

difference() {
    union() {

        difference() {
            box_rounded_2x(objectWidth,railWidth,railHeightInner,smallRadius,bigRadius,smooth);

            // Cut out card rail
            color("red")
            translate([0,cardRailShoulder,railHeightInner-cardRailDepth])
                rotate([90,0,90])
                quad_ext(cardRailPoints,objectWidth);
                
            // Cut out chamfer area in back
            translate([-e,railWidth-railChamferX,-e])
            color("red")
            cube([objectWidth+e*2,railChamferX,railHeightInner-bigRadius+e]);    
        }

        // Add in lower rail body
        color("blue")
        translate([0,railWidth-railLowerW-railChamferX,-railLowerH])
        cube([objectWidth,railLowerW,railLowerH]);

        // Add in chamfer on back of rail
        points = [ [0,0], [0,railChamferX],[railChamferY,railChamferX] ];
        color("red")
        translate([objectWidth,railWidth,railHeightInner-bigRadius])
        rotate([0,90,180])
        triangle_ext(points,objectWidth);
    }

    // Cut out slot
    color("red")
    rotate([10,0,0])
    translate([-e,railWidth-slotDepth-railChamferX,-railLowerH+slotShoulder])
        cube([objectWidth+e*2,slotDepth,slotHeight]);
}