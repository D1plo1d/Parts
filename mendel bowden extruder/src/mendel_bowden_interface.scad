<mendel_bowden_common_lib.scad>
interface = true;
<mendel_bowden_barrel_clamp.scad>
// Parametric Mendel Extruder in SCAD by Vik, based on SCAD conversion by rbisping
// vik@diamondage.co.nz, 2010-01-02
// Pinch bearing & filament size is parametric. Also added pointy tops to horizontal holes.

module filament_cavity() {
	union () {
		cylinder(extruder_height+2,filament_rad+filament_oversize,filament_rad+filament_oversize,center=true);
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
       		translate([30,extruder_thick/2,extruder_height/2+10])cube([60,extruder_thick,extruder_height], center = true);
		}
	union()
		{
translate([filament_x_offset,extruder_thick/2,extruder_height/2+10])rotate([0,0,90]) filament_cavity();

		// Horizontal M4 holes
		translate([5,extruder_thick/2,extruder_height/2+10])rotate([0,0,90]) m4_hole_vert(extruder_height*1.1);
		translate([55,extruder_thick/2.09,extruder_height/2+10])rotate([0,0,90]) m4_hole_vert(extruder_height*1.1);
		
		}
	}
}
}

// Put it in X+ve, Y+ve
union()
{
	rotate([90,0,0])translate ([40,45,0]) pinchwheel();
	barrel_clamp();
}