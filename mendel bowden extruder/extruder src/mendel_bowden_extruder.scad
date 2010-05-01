// Parametric Mendel Extruder in SCAD by Erik de Bruijn
// Based on thing:1935 by Vik, vik@diamondage.co.nz, 2010-01-02
// based on SCAD conversion by rbisping
//
// Pinch bearing & filament size is parametric. Also added pointy tops to horizontal holes.

// Integrated Bowden captive nut coupling
enable_bowden_couping = 1; // set to 0 to disable.
tube_dia = 6.3; // diameter of the PTFE tube
nutSize = 11.16;// the nut on the tube of the bowden cable (M6=10mm)
nema23_cylinder_dia = 38.5;
nema23_recess_depth = 6; // actually 1.6 mm, but to save more material
nema23_hole_spacing = 47.14;

m4_clearance_rad=2.4;//made is slightly smaller, use a file to make it wider again, better to tight than too little material here!
bearing_clearance_rad=8;
filament_rad=1.6;		// Includes some clearance.
ptfe_rad=1.5;			// 18mm dia PTFE spacer. May well be 16mm rad for you.
extruder_clamp_thick=35;
filament_x_offset=26.497;
m5_slotwidth = 6;

extruder_thick=16;
extruder_height=nema23_hole_spacing+12+m5_slotwidth;
extruder_width=nema23_hole_spacing+12+m5_slotwidth;
extruder_diagonal = extruder_height*1.44;

// Put it in X+ve, Y+ve
//translate ([40,45,0]) 
  pinchwheel();

$fs=0.5; // def 1, 0.2 is high res
$fa=6;//def 12, 3 is very nice



module pinchwheel()
{

translate([-40,10,0])rotate(90,[1,0,0])
{
difference()
	{
	union()
	{
		// Main block of the thing.
       		translate([32.5,extruder_thick/2,22])
		{
			//cube([extruder_width,extruder_thick,extruder_height],center=true);
			translate([-0.5,extruder_thick/2,-1]) rotate([90,45,0]) scale([1,1,1]) cylinder(r=extruder_width/2-6,h=extruder_thick);

			translate([0,extruder_thick/2,0]) rotate([90,45,0]) scale([0.3,1,1]) cylinder(r=extruder_diagonal/2-4,h=extruder_thick);
			translate([0,extruder_thick/2,0]) rotate([90,-45,0]) scale([0.3,1,1]) cylinder(r=extruder_diagonal/2-4,h=extruder_thick);

		}
		if(enable_bowden_couping==1)
		{
			bowden_housing();

		}
		rotate([0,90,0]) translate([-extruder_height/2-3,0,11]) bowden_housing();
		rotate([0,90,0]) translate([-extruder_height+4,0,11]) bowden_housing();
		//translate([33/2,0,0]) bowden_housing();
		// Side piece for motor anti-slippage screw.
		//anti_slippage_screw();

	}
	union()
		{


		// Slotted holes for stepper motor
			//center of stepper motor
			translate([30.5+m5_slotwidth/2,9,21]) 
			{
				translate([-nema23_hole_spacing/2,0,-nema23_hole_spacing/2]) m5_slot();
				translate([nema23_hole_spacing/2,0,-nema23_hole_spacing/2]) m5_slot();
				translate([-nema23_hole_spacing/2,0,nema23_hole_spacing/2]) m5_slot();
				translate([nema23_hole_spacing/2,0,nema23_hole_spacing/2]) m5_slot();
			}

		//nema23_hole_spacing


		//The hole for the nema23's gear or splined shaft
		translate([30.5,9,21])rotate(90,[1,0,0])cylinder(24,6,6,center=true);
		translate([32.5,9,21])rotate(90,[1,0,0])cylinder(24,6.1,6.1,center=true);
		translate([34.5,9,21])rotate(90,[1,0,0])cylinder(24,6.2,6.2,center=true);

		translate([33.492,extruder_thick-3,20.988])
		{
			cube([27.975,21.63,bearing_clearance_rad*2],center=true);
		}

		// Cutout for bearing
		translate([29-bearing_clearance_rad-filament_rad,extruder_thick-3,21]) {
			// Circular recess for bearing
			rotate(90,[1,0,0])
				cylinder(21.63,bearing_clearance_rad,bearing_clearance_rad,center=true);
			// Bolt hole for bearing (bit of slack)
			rotate(90,[1,0,0]) cylinder(80,m4_clearance_rad+0.3,m4_clearance_rad+0.3,center=true);
			// Slants tangental to bearing edge.
			rotate(10,[0,1,0]) translate([0,-21.63/2,0])
				cube([13.258,21.63,bearing_clearance_rad],center=false);
			rotate(-10,[0,1,0]) translate([0,-21.63/2,-bearing_clearance_rad])
				cube([13.258,21.63,bearing_clearance_rad],center=false);
		}

		translate([filament_x_offset,extruder_thick/2,21.635])rotate([0,0,90]) 
		{
			if(enable_bowden_couping==1)
			{
				bowden_housing_cutouts();

			}
		// Side mounting T-slots
		rotate([90,0,0]) translate([0,11,6]) bowden_housing_cutouts();
		rotate([90,0,0]) translate([0,-14,6]) bowden_housing_cutouts();

			filament_cavity();
		}
		// Motor recess:
		translate([extruder_width/2+0,extruder_thick,21])
		{
			translate([-m5_slotwidth/2,1,0]) rotate([90,0,0]) cylinder(r=nema23_cylinder_dia/2,h=nema23_recess_depth+0.1);
			translate([m5_slotwidth/2,1,0]) rotate([90,0,0]) cylinder(r=nema23_cylinder_dia/2,h=nema23_recess_depth+0.1);
			translate([0,-2,0]) cube([m5_slotwidth,nema23_recess_depth,nema23_cylinder_dia],center=true);

		}

		// These mounting points from Vik's design are imcompatible. But a Bowden extruder will be mounted elsewhere anyway!
		// Horizontal M4 holes
		//translate([5,extruder_thick/2,22.0])rotate([0,0,90]) m4_hole_horiz(extruder_height*1.1);
		//translate([55,extruder_thick/2.09,22]) rotate([0,0,90]) m4_hole_horiz(extruder_height*1.1);
		

		}
	}
}

	module anti_slippage_screw()
	{
		translate ([extruder_width/2+31.99,0,(extruder_height-38)/2]) 
		{
			difference()
			{
				union()
				{
					translate([2.50,extruder_thick+5,7]) rotate([0,90,0]) cylinder(r=7,h=5,center=true);
					cube([5,extruder_thick+5,14]);
				}
				// Hex cavity for sideways compression screw.
				translate([1,4.9+extruder_thick,7]) rotate([90,0,180]) rotate([0,-90,0])  m4_hole_horiz_with_hex(20);
			}
		}
	}
	module bowden_housing()
	{
			translate([extruder_width/2-5,extruder_thick/2,-1.2])
				cube([15,extruder_thick,15],center = true);
			translate([extruder_width/2-5,extruder_thick/2,extruder_height/2+10])
				cube([15,extruder_thick,20],center = true);
	}

	module bowden_housing_cutouts()
	{
			// Top cutout
			// Opening for bowden cable with a nut at the end.
			translate([0,0,-extruder_height/2+3])
			{
				cube([extruder_thick+2,tube_dia,6.5],center=true);
			}
			translate([0,0,-extruder_height/2+8]) 
			{
				cube([extruder_thick+2,nutSize,6.8],center=true);
					cube([6.9,6.9,6.8],center=true);
			}
			// Bottom cutout
			translate([0,0,extruder_height/2-2])
					cube([extruder_thick+2,tube_dia,6.5],center=true);
			translate([0,0,extruder_height/2-7]) 
				cube([extruder_thick+2,nutSize,6.8],center=true);

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

module m5_slot() {
	rotate([90,0,0])
translate([0,0,-1])
	union()
	{
		translate([m5_slotwidth/2,0,0])
			cylinder(r=5.25/2,h=extruder_thick*2.1+2,center=true);
		cube([m5_slotwidth,5.25,extruder_thick*2.1+2],center=true);
		translate([-m5_slotwidth/2,0,0])
			cylinder(r=5.25/2,h=extruder_thick*2.1+2,center=true);
	}
}

filament_oversize=0.4;	// If your extruder is perfect this can be zero :)
module filament_cavity() {
	union () {
		cylinder(100,filament_rad+filament_oversize,filament_rad+filament_oversize,center=true);
		translate ([0.6*filament_rad,0,0]) rotate ([0,0,45])
			cube([filament_rad+filament_oversize,filament_rad+filament_oversize,100],center=true);
	}
}

module rounded_cube(w,l,h)
{
	cube([w,l,h], center = true);
}


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
