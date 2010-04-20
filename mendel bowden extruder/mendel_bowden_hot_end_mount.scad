// Parametric Mendel Extruder in SCAD by Vik, based on SCAD conversion by rbisping
// vik@diamondage.co.nz, 2010-01-02
// Pinch bearing & filament size is parametric. Also added pointy tops to horizontal holes.

m4_clearance_rad=2.6;
bearing_clearance_rad=8;
filament_rad=1.6;		// Includes some clearance.
ptfe_rad=9.2;			// 18mm dia PTFE spacer. May well be 16mm rad for you.

nut_rad = 8.3;			// M8 nut on the bowden cable
extruder_thick=20;
extruder_height=34;
extruder_clamp_thick=30;
filament_x_offset=26.497;

module box(w,h,d) {
	scale ([w,h,d]) cube(1, true);
}

module roundedBox(w,h,d,f){
	difference(){
		box(w,h,d);
		translate([-w/2,h/2,0]) cube(w/(f/2),true);
		translate([w/2,h/2,0]) cube(w/(f/2),true);
		translate([-w/2,-h/2,0]) cube(w/(f/2),true);
		translate([w/2,-h/2,0]) cube(w/(f/2),true);
	}
	translate([-w/2+w/f,h/2-w/f,-d/2]) cylinder(d,w/f, w/f);
	translate([w/2-w/f,h/2-w/f,-d/2]) cylinder(d,w/f, w/f);
	translate([-w/2+w/f,-h/2+w/f,-d/2]) cylinder(d,w/f, w/f);
	translate([w/2-w/f,-h/2+w/f,-d/2]) cylinder(d,w/f, w/f);
}
module hexagon(height, depth) {
	boxWidth=height/1.75;
		union(){
			box(boxWidth, height, depth);
			rotate([0,0,60]) box(boxWidth, height, depth);
			rotate([0,0,-60]) box(boxWidth, height, depth);
		}
}

module m4_hole_horiz(l) {
	cylinder(l,m4_clearance_rad+0.2,m4_clearance_rad+0.2,center=true);
	translate ([m4_clearance_rad*0.6,0,0]) rotate ([0,0,45])
		cube([m4_clearance_rad,m4_clearance_rad,l],center=true);
}

module m8_hole_horiz(l) {
	cylinder(l,m8_clearance_rad,m4_clearance_rad,center=true);
	translate ([m8_clearance_rad*0.6,0,0]) rotate ([0,0,45])
		cube([m8_clearance_rad,m8_clearance_rad,l],center=true);
}

module m4_hole_vert(l) {
	cylinder(l,m4_clearance_rad+0.2,m4_clearance_rad+0.2,center=true);
}

module m6_hole_horiz(l) {
	cylinder(l,m6_clearance_rad,m6_clearance_rad,center=true);
	translate ([m6_clearance_rad*0.6,0,0]) rotate ([0,0,45])
		cube([m6_clearance_rad,m6_clearance_rad,l],center=true);
}
module m8_hole_horiz(l) {
	cylinder(l,m8_clearance_rad,m8_clearance_rad,center=true);
	translate ([m8_clearance_rad*0.6,0,0]) rotate ([0,0,45])
		cube([m8_clearance_rad,m8_clearance_rad,l],center=true);
}

// No .4 3/4 inch countersunk woodscrew (includes a lot of headspace)
module small_woodscrew() {
	rotate ([0,0,30]) {
		translate ([0,0,-7.5]) cylinder(h=3,r1=0.2,r2=1.8,center=true);
		cylinder(h=12,r1=1.8,r2=2.0,center=true);
		translate([0,0,6]) cylinder(h=4, r1=2.0, r2=4.0);
	}
}

// For nut cavities, "height" is the max distance between two points on the hex.
module m4_nut_cavity(l) {
	hexagon(height=8,depth=l);
}

module m8_nut_cavity(l) {
	hexagon(height=14,depth=l);
}

module m4_hole_vert_with_hex(l) {
	union () {
		m4_hole_vert(l);
		translate ([0,0,-l/4]) rotate ([0,0,30]) m4_nut_cavity(l/2);
	}
}

module m4_hole_horiz_with_hex(l) {
	union () {
		m4_hole_horiz(l);
		translate ([0,0,-l/4]) rotate ([0,0,0]) m4_nut_cavity(l/2);
	}
}

module m3_slot() {
	cube([7.149,extruder_thick*2.1,3.4],center=true);
}

filament_oversize=0.4;	// If your extruder is perfect this can be zero :)
module filament_cavity() {
	union () {
		cylinder(100,filament_rad+filament_oversize,filament_rad+filament_oversize,center=true);
		translate ([0.6*filament_rad,0,0]) rotate ([0,0,45])
			cube([filament_rad+filament_oversize,filament_rad+filament_oversize,100],center=true);
	}
}

module pinchwheel()
{
translate([-40,10,0])rotate(90,[1,0,0])
{
difference()
	{
	union()
		{
		// Main block of the thing.
       		translate([30,extruder_thick/2,22])cube([60,extruder_thick,extruder_height], center = true);
		// PTFE holder (for woodscrews instead of epoxy)
		translate([filament_x_offset,extruder_thick/2,0])cube([22,extruder_thick,20], center = true);
		}
	union()
		{
translate([filament_x_offset,extruder_thick/2,21.635])rotate([0,0,90]) filament_cavity();

		// Horizontal M4 holes
		translate([5,extruder_thick/2,22.0])rotate([0,0,90]) m4_hole_horiz(extruder_height*1.1);
		translate([55,extruder_thick/2.09,22])rotate([0,0,90]) m4_hole_horiz(extruder_height*1.1);

//Hex Filament Nut Hole
#translate([filament_x_offset,extruder_thick/2,40]) rotate ([90,0,0]) rotate([90,90,0])cylinder(h=20,r=nut_rad,center=true, $fn=6);

		// Split PTFE holder
		#translate([filament_x_offset,extruder_thick/2,-2.5]) rotate ([90,0,0]) rotate([90,0,0])cylinder(h=20,r=ptfe_rad,center=true);
		#translate([filament_x_offset ,extruder_thick/2, -2.5])cube([3.4,20.889,18],center = true);
		// 3mm holes for woodscrews
		#translate([filament_x_offset-6.5,extruder_thick/2,-1.4]) rotate ([90,0,0]) cylinder(h=extruder_thick*2,r=2.5,center=true);
		#translate([filament_x_offset+6.5,extruder_thick/2,-1.4]) rotate ([90,0,0]) cylinder(h=extruder_thick*2,r=2.5,center=true);
		}
	}
}
}

// Put it in X+ve, Y+ve
translate ([40,45,0]) pinchwheel();