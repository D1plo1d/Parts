<common_lib.scad>

bearing_screw_offset = 1/4;

bearing_center_x_spacing = (bearing_radius+bearing_radius2) + x_rod_spacing;
bearing_center_y_spacing = 3;

laser_mount_screw_size = 1/4;
laser_mount_screw_center_spacing = 1;

xCarriage();

module xCarriage() difference()
{
	union()
	{
		square([plate_width, plate_length], center=true);
	}
	union()
	{
		translate([plate_width/2 - bearing_screw_size/2 - bearing_screw_offset,0])
		{
			bearing_hole();
			//rod mochup
			%translate([-bearing_radius-rod_radius*2/3, 4, 0.75+bearing_height+bearing_collar_height+0.1/2]) rotate([90,90]) cylinder(r=rod_radius, h = 8, centered = true);

			translate([-bearing_center_x_spacing,0])
			{
				//rod mochup
				%translate([bearing_radius+rod_radius*2/3, 4, 0.75+bearing_height+bearing_collar_height+0.1/2]) rotate([90,90]) cylinder(r=rod_radius, h = 8, centered = true);
				//bearing holes
				translate([0,bearing_center_y_spacing/2]) bearing_hole();
				translate([0,-bearing_center_y_spacing/2]) bearing_hole();

				//laser/extruder mount screws
				translate([0, laser_mount_screw_center_spacing/2]) drill_hole(laser_mount_screw_size/2);
				translate([0, -laser_mount_screw_center_spacing/2]) drill_hole(laser_mount_screw_size/2);
			}
		}
	}
}