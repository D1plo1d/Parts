<mendel_bowden_common_lib.scad>

// Parametric Mendel Extruder in SCAD by Vik, based on SCAD conversion by rbisping
// vik@diamondage.co.nz, 2010-01-02
// Pinch bearing & filament size is parametric. Also added pointy tops to horizontal holes.

extruder_height=10;		// The overall height of this part when 

flat_pack = true;

// For use with only groove mount extruders (see makergear.com)
groove_mount_radius = 12.45/2;

module pinchwheel()
{
translate([-40,10])rotate(90)
{
difference()
	{
	union()
		{
		// Main block of the thing.
       		translate([30,extruder_thick/2]) square([60,extruder_thick], center = true);
		}
	union()
		{
		// Groove Mount
		translate([filament_x_offset,extruder_thick/2]) circle(r=groove_mount_radius,center=true);
		translate([filament_x_offset,extruder_thick/4-1]) square([groove_mount_radius*2,extruder_thick/2-1/2],center=true);
		
		// Horizontal M4 holes
		translate([5,extruder_thick/2]) circle(r=4.5/2, center = true);
		translate([55,extruder_thick/2.09]) circle(r=4.5/2, center = true);
		}
	}
}
}

pinchwheel();