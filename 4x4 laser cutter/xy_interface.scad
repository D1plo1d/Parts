<common_lib.scad>

bearing_screw_offset = 1/4;

bearing_center_x_spacing = bearing_radius*4/3 + rod_radius*2;
bearing_center_y_spacing = 3;

l_bracket_mount_screw_size = 1/4;
l_bracket_mount_screw_center_spacing = 1;

pulley_height = 0.5;

ubolt_size = 1/4;
ubolt_width = 1.5;

ubolt_offset = 1/4;
ubolt_x_spacing = 3/4;
ubolt_y_spacing = 1/4;

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
				//bearing holes
				translate([0,bearing_center_y_spacing/2]) bearing_hole();
				translate([0,-bearing_center_y_spacing/2]) bearing_hole();
			}
		}
				//laser/extruder mount screws
				translate([l_bracket_mount_screw_center_spacing/2, pulley_height]) drill_hole(l_bracket_mount_screw_size/2);
				translate([-l_bracket_mount_screw_center_spacing/2, pulley_height]) drill_hole(l_bracket_mount_screw_size/2);
		translate([-plate_width/2+ubolt_offset+ubolt_size/2,0])
		{
			for (x = [0, 1]) for (y=[-1,1])
			translate ([ubolt_x_spacing*x,(ubolt_y_spacing+(ubolt_width+ubolt_size)/2)*y])
			{
				rotate(90) ubolt();
			}
		}
	}
}

module ubolt()
{
	translate([-ubolt_width/2, 0]) drill_hole(ubolt_size/2);
	translate([+ubolt_width/2,0]) drill_hole(ubolt_size/2);
}