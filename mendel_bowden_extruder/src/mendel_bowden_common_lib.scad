// Parametric Mendel Extruder in SCAD by Vik, based on SCAD conversion by rbisping
// vik@diamondage.co.nz, 2010-01-02
// Pinch bearing & filament size is parametric. Also added pointy tops to horizontal holes.

m4_clearance_rad=2.6;
bearing_clearance_rad=8;
filament_rad=2;		// Includes some clearance.
filament_oversize=0;	// Legacy
ptfe_rad=9.2;			// 18mm dia PTFE spacer. May well be 16mm rad for you.

//Bowden cable config
bowden_cable_rad=(6.4 + 1) / 2;	// Includes some clearance.
nut_inset_depth = 6.7;	// The depth of the hexoginal hole for the nut to sit in
nut_rad = (12.35 + 1.2) / 2;			// nut on the bowden cable

//Barrel clamp config
barrel_clamp_height = 10;
barrel_clamp_width = 40;

extruder_thick=nut_rad*2+15;
extruder_height=10;		// The overall height of this part when 

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

//Modded for more clearance on vertical holes
module m4_hole_vert(l) {
	cylinder(l,m4_clearance_rad+0.5,m4_clearance_rad+0.7,center=true);
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