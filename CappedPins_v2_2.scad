//CappedPins V2.2
//01 DEC 2020
//By mbrami
//https://www.thingiverse.com/mbrami

/* [ Cap ]*/

// Cap diameter [mm]
Cap_dia =  10;//[0.1:0.1:100]

// Cap height [mm]
Cap_h = 3;//[0.1:0.1:100]

// Cap shape
Cap_shape = "HEXAGON"; // [ROUND SMOOTH, CYLINDER, HEXAGON]

/* [ Pin ]*/

// Pin diameter [mm]
Pin_dia = 5;//[0.1:0.1:100]

// Pin height [mm]
Pin_h = 15;//[0.1:0.1:100]

//Pin orientation [deg]
Pin_rot = 0;//[0:0.1:359.9]

// Pin shape
Pin_shape = "CROSS"; // [ROUND, HEXAGON, CROSS]

//Pin cross width [mm] (only used with CROSS pin shape)
Pin_cross_w = 2;//[0.1:0.1:100]

Pin_cross_w_calc = Pin_cross_w >= Pin_dia/2 ? Pin_dia/2 : Pin_cross_w;

/* [ Pin split ] */

//Pin split
Pin_split = "YES";//[YES, NO]

//Pin split width [mm]
Pin_split_w = 1;//[0:0.1:100]
Pin_split_w_calc = Pin_split_w * 2 <= Pin_dia - 2 ? Pin_split_w : (Pin_dia-2)/2;

//Pin split rotate on z axis [deg]
Pin_split_rot = 90;//[0:0.1:359.9]

/* [ Pin end ] */

//Chamfer pin end
Pin_end_chamfer = "YES";//[YES, NO]

//Chamfer position [% of pin height]
Pin_end_chamfer_position = 0.25;//[0:0.01:1]

//Chamfer minimum diameter [% of pin diameter]
Pin_end_chamfer_min_dia = 0.5;//[0:0.01:1]

/* [ Pin Groove ] */

//Groove
Groove = "NO";//[YES, NO]

//Groove width [mm]
Groove_w= 4;//[0:0.1:100]

//Groove depth [% of Pin diameter]
Groove_d= 0.15;//[0:0.01:1]

//Groove start [% of Pin height]
Groove_start = 0; //[0:0.01:1]

//Groove orientation [deg]
Groove_rot = 0;//[0:0.1:359.9]

//Generators

//Cap generators
module cap_round(smoothed, n_subdiv){
    if (smoothed){
        union(){
            cylinder(h=Cap_h-(Cap_dia/2), d=Cap_dia);  
            intersection(){
                cylinder(h=Cap_h, d=Cap_dia);
                translate([0,0, Cap_h-Cap_dia]) difference(){
                    sphere (Cap_dia, $fn=36);
                    translate([-Cap_dia,-Cap_dia,-Cap_dia*2]) cube(Cap_dia*2);
                    };
                }
            }
        }
    else {
        cylinder(h=Cap_h, d=Cap_dia, $fn=n_subdiv);
        }
};

//Pin Generators
module pin_round(n_subdiv){
    rotate ([0,0,Pin_rot]) translate([0,0,-Pin_h]) cylinder (h=Pin_h, d=Pin_dia, $fn = n_subdiv);
    }
module pin_cross(){
    
    module crossComponent(){
        scale([Pin_dia,Pin_dia,Pin_h]) cube (1);
        }
    difference(){ 
        pin_round(36);
        union(){
            translate([-Pin_dia-(Pin_cross_w/2),Pin_cross_w/2,-Pin_h]) crossComponent() ;
            translate([-Pin_dia-(Pin_cross_w/2),-Pin_dia-Pin_cross_w/2,-Pin_h]) crossComponent() ;
            translate([(Pin_cross_w/2),-Pin_dia-Pin_cross_w/2,-Pin_h]) crossComponent() ;
            translate([Pin_cross_w/2,Pin_cross_w/2,-Pin_h]) crossComponent() ;
            }
        };
}

//Split generator    
module split(){
        rotate([0,0,45])union(){
            translate([0, Pin_dia, -Pin_split_w_calc])rotate([90,0,0]) cylinder (h= Pin_dia*2, d= Pin_split_w_calc*2, $fn=36);
            rotate([0,0,90])translate([-Pin_dia/2, -Pin_split_w_calc/2, -Pin_h])scale([Pin_dia, Pin_split_w_calc, Pin_h])cube (1);
    };
}


module cap(){
    if (Cap_shape=="ROUND SMOOTH"){cap_round(true, 36);}
    else if (Cap_shape=="CYLINDER"){cap_round(false, 36);}
    else if (Cap_shape== "HEXAGON"){cap_round(false, 6);}
}

module pin(){
        if (Pin_shape == "ROUND") {pin_round(36);}
        else if (Pin_shape == "HEXAGON") {pin_round(6);}
        else if (Pin_shape == "CROSS") {pin_cross();};
}

module chamfer(){
    if (Pin_end_chamfer == "YES") {
        difference(){
            pin();
            difference(){    
                translate([0,0,-Pin_h])cylinder(h = Pin_h * Pin_end_chamfer_position, r1 = Pin_dia/2, r2 = Pin_dia/2, $fn=36);
                translate([0,0,-Pin_h])cylinder(h = Pin_h * Pin_end_chamfer_position, r1 = (Pin_dia * Pin_end_chamfer_min_dia)/2, r2 = Pin_dia/2, $fn=36);
            };
        };
    } else {pin();};
}

//Putting all together

difference(){
    union(){
        cap();
        if (Pin_split=="YES") {
            difference (){
                chamfer();        
                rotate([0,0,Pin_split_rot])split();
            }
        } else {chamfer();};
    };
    if (Groove =="YES") {
        rotate(a=Groove_rot, v=[0,0,1])
        translate([Pin_dia/2-(Groove_d*Pin_dia), -Groove_w/2, -Pin_h ])  
        cube(size = [Groove_d * Pin_dia, Groove_w, Pin_h * (1- Groove_start)]);
    } else {
        cube (0);
    };
}
        