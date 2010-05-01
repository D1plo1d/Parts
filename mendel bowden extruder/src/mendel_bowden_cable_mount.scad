<mendel_bowden_common_lib.scad>

// Parametric Mendel Extruder in SCAD by Vik, based on SCAD conversion by rbisping
// vik@diamondage.co.nz, 2010-01-02
// Pinch bearing & filament size is parametric. Also added pointy tops to horizontal holes.

extruder_height=15;		// The overall height of this part when 

module pinchwheel()
{
translate([-40,10,0])rotate(90,[1,0,0])
{
difference()
	{
	union()
		{
		// Main block of the thing.
       		translate([30,extruder_thick/2,extruder_height/2+10])cube([60,extruder_thick,extruder_height], center = true);
		}
	union()
		{
		// Bowden Cable hole
translate([filament_x_offset,extruder_thick/2,21.635])rotate([0,0,90]) cylinder(100,bowden_cable_rad+filament_oversize,bowden_cable_rad+filament_oversize,center=true);

		// Horizontal M4 holes
		translate([5,extruder_thick/2,extruder_height/2+10])rotate([0,0,90]) m4_hole_vert(extruder_height*1.1);
		translate([55,extruder_thick/2.09,extruder_height/2+10])rotate([0,0,90]) m4_hole_vert(extruder_height*1.1);

//Hex Filament Nut Hole
#translate([filament_x_offset,extruder_thick/2,extruder_height/2+nut_inset_depth/2+10+1]) rotate ([90,0,90]) rotate([90,90,0])cylinder(h=nut_inset_depth+1,r=nut_rad,center=true, $fn=6);

		}
	}
}
}

// Put it in X+ve, Y+ve
rotate([-90,0,0])translate ([40,45,0]) pinchwheel();