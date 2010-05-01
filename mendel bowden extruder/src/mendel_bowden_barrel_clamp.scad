<mendel_bowden_common_lib.scad>
// Parametric Mendel Extruder in SCAD by Vik, based on SCAD conversion by rbisping
// vik@diamondage.co.nz, 2010-01-02
// Pinch bearing & filament size is parametric. Also added pointy tops to horizontal holes.

module barrel_clamp()
{
rotate([90,0,0])translate ([40,45,0]) translate([-40,10,0])rotate(90,[1,0,0])
{
difference()
	{
	union()
		{
		// PTFE holder (for woodscrews instead of epoxy)
		translate([filament_x_offset-2-12,0,0])cube([12,extruder_thick,barrel_clamp_height], center = false);
		}
	union()
		{
		// PTFE barrel hole
		translate([filament_x_offset,extruder_thick/2,0]) rotate ([90,0,0]) rotate([90,0,0])cylinder(h=barrel_clamp_height+2.5+30,r=ptfe_rad,center=true);
		
		// M4 thermal barrier barrel clamp holes
		translate([filament_x_offset,5.5,barrel_clamp_height/2+2]) rotate([0,90,0]) m4_hole_horiz(50);
		translate([filament_x_offset,extruder_thick-5.5,barrel_clamp_height/2+2]) rotate([0,90,0]) m4_hole_horiz(50);
		
		}
	}
}
}

// Put it in X+ve, Y+ve
if (interface)
{
}
else
{
	barrel_clamp();
}