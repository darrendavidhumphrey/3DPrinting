
use <MCAD/boxes.scad>

inToMM = 25.4;
tagW = 4 * inToMM;
tagH =  3 * inToMM;
tagD = 3.0;

backD = 1.5;
shoulder = 5.0;
e = 0.01;
$fn=90;

holderX = 20;
holderY = 10;
holderShoulder = 3;

union() {
difference() {
roundedBox([tagW+shoulder*2,tagH+shoulder*2,tagD], 3, true);

translate([-tagW/2,-tagH/2,-e])
cube([tagW,tagH,(tagD-backD)+2*e]);
}

difference() {
translate([-holderX/2,tagH/2+shoulder,-tagD/2])
cube([holderX,holderY,tagD]);

translate([-holderX/2+holderShoulder,tagH/2+shoulder,-tagD/2-e])
cube([holderX-holderShoulder*2,holderY-holderShoulder*2,tagD+e*2]);
}
}