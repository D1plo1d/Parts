//CAD LIB
//=======

// translates a imperial measurement in inches to meters
mm_per_inche =25.4;


//generates a motor mount for the specified nema standard #.
module stepper_motor_mount(nema_standard,slide_distance=0, mochup=true)
{
	//dimensions from:
	// http://www.numberfactory.com/NEMA%20Motor%20Dimensions.htm
	if (nema_standard == 17)
	{
		_stepper_motor_mount(
			motor_shaft_diameter = 0.1968*mm_per_inche,
			motor_shaft_length = 0.945*mm_per_inche,
			pilot_diameter = 0.866*mm_per_inche,
			pilot_length = 0.80*mm_per_inche,
			mounting_bolt_circle = 1.725*mm_per_inche,
			bolt_hole_size = 3.5,
			bolt_hole_distance = 1.220*mm_per_inche,
			slide_distance = slide_distance,
			mochup = mochup);
	}
	if (nema_standard == 23)
	{
		_stepper_motor_mount(
			motor_shaft_diameter = 0.250*mm_per_inche,
			motor_shaft_length = 0.81*mm_per_inche,
			pilot_diameter = 1.500*mm_per_inche,
			pilot_length = 0.062*mm_per_inche,
			mounting_bolt_circle = 2.625*mm_per_inche,
			bolt_hole_size = 0.195*mm_per_inche,
			bolt_hole_distance = 1.856*mm_per_inche,
			slide_distance = slide_distance,
			mochup = mochup);
	}
	
}

//inner mehod for creating a stepper motor mount of any dimensions
module _stepper_motor_mount(
	motor_shaft_diameter,
	motor_shaft_length,
	pilot_diameter,
	pilot_length,
	mounting_bolt_circle,
	bolt_hole_size,
	bolt_hole_distance,
	slide_distance = 0,
	motor_length = 40, //arbitray - not standardized
	mochup
)
{
	union()
	{
	// == centered mount points ==
	//mounting circle inset
	translate([0,slide_distance/2,0]) circle(r = pilot_diameter/2);
	square([pilot_diameter,slide_distance],center=true);
	translate([0,-slide_distance/2,0]) circle(r = pilot_diameter/2);

	//todo: motor shaft hole
	
	//mounting screw holes
	for (x = [-1,1])
	{
		for (y = [-1,1])
		{
			translate([x*bolt_hole_distance/2,y*bolt_hole_distance/2,0])
			{
				translate([0,slide_distance/2,0]) circle(bolt_hole_size/2);
				translate([0,-slide_distance/2,0]) circle(bolt_hole_size/2);
				square([bolt_hole_size,slide_distance],center=true);
			}
		}
	}
	// == motor mock-up ==
	//motor box
	if (mochup == true)
	{
		%translate([0,0,-5]) cylinder(h = 5, r = pilot_diameter/2);
		%translate(v=[0,0,-motor_length/2])
		{
			cube(size=[bolt_hole_distance+bolt_hole_size+5,bolt_hole_distance+bolt_hole_size+5,motor_length], center = true);
		}
		//shaft
		%translate(v=[0,0,-(motor_length-motor_shaft_length-2)/2])
		{
			%cylinder(r=motor_shaft_diameter/2,h=motor_length+motor_shaft_length--1, center = true);
		}
	}
	};
}

//Todo: placeholder; should generate standard + cusom bearing mounting holes
module bearing_hole(outer_radius, hole=true, mochup=true)
{
	union()
	{
		if (mochup==true) %translate([0,0,-1.5])cylinder(r=outer_radius,h=3);
		if (hole==true) circle(r=outer_radius);
	}
}

//REPRAP LIB
//=======

module flat_pack_nut_trap(screw_diameter, screw_length, nut_diameter, nut_length, include_mount_points = true, include_mochups = true,  include_screw_trap = true, include_nut_trap = true, mount_screws = [-1,1])
{
	if (include_mochups == true)
	{
		for (i=[-1,1]) translate([0,0,3*i]) difference()
		{
			square([nut_diameter+13, nut_length+9], center=true);
			flat_pack_nut_trap_holes(nut_diameter, nut_length, mount_screws);
		}
	}
	if (include_mount_points == true)
	{
		//mount holes
		flat_pack_nut_trap_holes(nut_diameter, nut_length, mount_screws);
		//nut trap
		if (include_nut_trap == true) square([nut_diameter, nut_length], center=true);
		//scew
		if ( include_screw_trap == true) translate([0,screw_length/2-(nut_length+9)/2]) square([screw_diameter, screw_length], center=true);
	}
}

module flat_pack_nut_trap_holes(nut_diameter, nut_length, mount_screws)
{
	for (x=mount_screws) for(y=[-1,1])
	{
		translate([(nut_diameter-1.5)*x,(nut_length)*y])
		{
				circle(3.5/2);
		}
	}
}





//Part
//=======================================

bearing_screw_slot_length = 7;//the length of the slot used to position the feeder bearing
bearing_screw_size = 4.5; //the size of the screw that holds on the feeder bearing

bowden_nut_diameter = 10; //the diameter of the nut threaded on to the bowden cable.
bowden_nut_length = 5; //the length of the nut along the axis of the bowden cable
bowden_cable_diameter = 6.5;

bearing_radius = 13/2;

bearing_mount_type = 1; //1 = single screw slot mount, 2 = flat pack spring mount
displayed_part = 0; // 0 = all; 1-3 = each individual part of the design

extruder_frame_height = 45; // 45 = mount type 1; 70 = type 2
extruder_frame_length = 90; //90 = mount type 1; 86 = type 2
extruder_frame_back_inset = 48;

if (displayed_part == 0 || displayed_part == 1) extruder_frame_front();
if (displayed_part == 0 || displayed_part == 2) extruder_frame_back();
if (displayed_part == 0 || displayed_part == 3) extruder_frame_middle();


bowden_nut_hole_x = (extruder_frame_height/2-bowden_nut_length-4);
expansion_factor = 4;
//draw the bearing tensioner block
if(bearing_mount_type == 2) translate([0,30])
{
	//top peices
	for (z=[-12,-3,6]) translate([0,0,z*expansion_factor]) extruder_bearing_tensioner(include_screw_trap=false,include_bearing_screw_holder=true);
	//screw traps
	for (z=[-6.5,0]) translate([0,0,z*expansion_factor]) extruder_bearing_tensioner(include_screw_trap=true,include_bearing_screw_holder=false);
	//middle peice(s)
	for (z=[-3]) translate([0,0,z*expansion_factor]) extruder_bearing_tensioner(include_screw_trap=false,include_bearing_screw_holder=false);
}


module extruder_bearing_tensioner(include_screw_trap=false,include_bearing_screw_holder=true)
{
	translate([0,extruder_frame_length/2-bearing_screw_slot_length-bearing_screw_size-2])
	{
		difference()
		{
			translate([-extruder_frame_height/2,0]) square ([extruder_frame_height, 30],center=false);
			union()
			{
				//screw traps
				translate([0,19]) extruder_bearing_tensioner_screw_traps(false, include_screw_trap);
				for (x=[-1,1]) translate([(extruder_frame_height/2-4)*x,25.75]) circle(3.5/2);
				
				if (include_bearing_screw_holder == true)
				{
					//cutting away excess for the bearing screw holder
					for (x=[-1,1]) translate([(extruder_frame_height/2-30/2)*x,22.5/2]) square([30,22.5], center = true);
					//bearing screw hole
					translate([0, 4.5/2+2]) circle(4.5/2);
				}
				else
				{
					translate([0,22.5/2]) square([extruder_frame_height,22.5], center = true);
				}	
			}
		}
	}
}


module extruder_frame_front()
{
	difference()
	{
		union()
		{
			square([extruder_frame_height,extruder_frame_length],center=true);
		}
		union()
		{
			translate([0,-extruder_frame_length/2+23])
			{
				stepper_motor_mount(17, slide_distance = 5, mochup = false);
				//stepper_motor_mount(23);
				//printed gear
				//%translate([0,0,5]) import_stl("resources/11t17p.stl", convexity = 5);
				//cut gear
				%translate([0,0,5]) linear_extrude(file = "resources/n11_m1.50_c0.70_s0.08.dxf",height = 5, center = true, convexity = 10);

			
			translate([0, 37.5]) //empirical measurement
			{
				bearing_hole(outer_radius=bearing_radius);
				//gear mochup
				//printed gear
				//%translate([0,0,5]) rotate(360/39/2.8) import_stl("resources/39t17p.stl", convexity = 5);
				//cut gear
				%translate([0,0,5]) rotate(360*(11/39)*1.5) linear_extrude(file = "resources/n39_m1.50_c0.70_s0.08.dxf",height = 5, center = true, convexity = 10);
				
				//screw mochup
				%translate([0,0,-30/2+10])cylinder(h=30,r=5/2, center = true);

				bowden_nut_holes();

				translate([0,bearing_radius+bearing_screw_size/2+0.5])
				{
					//screw
					extruder_feeder_bearing_screw_slot();
					%translate([0,0,-30/2])
					{
						cylinder(h=30,r=4/2, center = true);
					}
					
					//filament feeder bearing mochup
					%translate([0,0,-3.5])bearing_hole(outer_radius=bearing_radius, hole=false);
				}
			}
			}
		}
		extruder_frame_screws(include_mochups=true);
	}
}


module extruder_frame_back()
{
	translate([0,0,-7]) difference()
	{
		union()
		{
			translate([0,extruder_frame_back_inset/2]) square([extruder_frame_height,extruder_frame_length-extruder_frame_back_inset],center=true);
		}
		union() translate([0,-extruder_frame_length/2+23])
		{
			
			translate([0, 37.5,0]) //empirical measurement
			{
				//bearing is centered opposing the gear
				bearing_hole(outer_radius=bearing_radius);

				bowden_nut_holes();

				translate([0,bearing_radius+bearing_screw_size/2+0.5])
				{
					//screw
					extruder_feeder_bearing_screw_slot();
				}
			}
		}
		extruder_frame_screws();
	}
}


frame_middle_hole_length = extruder_frame_length-extruder_frame_back_inset-10-12;
frame_middle_b_length = 10;
module extruder_frame_middle()
{
	translate([0,0,-4]) difference()
	{
		union()
		{
			square([extruder_frame_height,extruder_frame_length],center=true);
		}
		union()
		translate([0,extruder_frame_back_inset-extruder_frame_length/2+frame_middle_hole_length/2+12]) square([extruder_frame_height-(extruder_frame_height/2 - bowden_nut_hole_x)*2,frame_middle_hole_length],center=true);
		translate([0,-extruder_frame_length/2+23])
		{
			stepper_motor_mount(17, slide_distance = 5);

			translate([0, 37.5,0]) //empirical measurement
			{
				//bearing is centered opposing the gear this smaller screw hole traps the bearing
				circle(10.5/2);

				bowden_nut_holes();


				translate([0,bearing_radius+bearing_screw_size/2+0.5+bearing_screw_slot_length])
				{
					//screw
					%translate([0,0,-30/2+4])
					{
						cylinder(h=30,r=4/2, center = true);
					}
					//filament feeder bearing mochup
					translate([0,0,4-3.5])bearing_hole(outer_radius=bearing_radius);

				}
			}

		}
		extruder_frame_screws();
	}
}


module extruder_feeder_bearing_screw_slot()
{
	union()
	{
			circle(r=bearing_screw_size/2);
			translate([-bearing_screw_size/2,0]) square([bearing_screw_size,bearing_screw_slot_length]);
			translate([0,bearing_screw_slot_length,0])
			{
				if (bearing_mount_type == 1) circle(r=bearing_screw_size/2);
				if (bearing_mount_type == 2) square(bearing_screw_size, center=true);
			}
		if(bearing_mount_type == 2)
		{
			//Replaces feeder screw slots with nut traps for the bearing tensionion block
			extruder_bearing_tensioner_screw_traps();
		}

	}
}

module extruder_bearing_tensioner_screw_traps(include_nut_trap = true, include_screw_trap = true)
{
	for (x=[-1,1]) translate([x*(extruder_frame_height/2-17),bearing_screw_slot_length+bearing_screw_size/2-(4+9)/2,0]) rotate(180) flat_pack_nut_trap(4.5,16, 7, 4, true, false, include_screw_trap, include_nut_trap);
}


module extruder_frame_screws(include_mochups = false)
{
	for (x=[-1,1]) for(y=[-1,1])
	{
		translate([(extruder_frame_height/2-5)*x,extruder_frame_back_inset/2+((extruder_frame_length-extruder_frame_back_inset)/2-5)*y])
		{
			circle(4.5/2);
			if (include_mochups == true)
			{
				%translate([0,0,-16/2]) cylinder(r=4/2, h=16, center = true);
			}
		}
	}
}

module bowden_nut_holes()
{
	for (x=[-1,1])
	{
		translate([bowden_nut_hole_x*x,bearing_screw_size/2+1])
		{
			//nut hole
			square([bowden_nut_length, bowden_nut_diameter], center=true);
			//cable hole
			translate([(extruder_frame_height/2 - bowden_nut_hole_x)/2*x,0])square([extruder_frame_height/2 - bowden_nut_hole_x, bowden_cable_diameter], center=true);
		}
	}
}