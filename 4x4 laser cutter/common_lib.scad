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

//Laser Cutter Lib
//===============

plate_width = (12+1/4)/2;
plate_length = 4+5/8;

x_rod_spacing = 3;

bearing_screw_size = 0.29;

bearing_radius = (1 + 1/4)/2;
bearing_radius2 = (1+3/4)/2; //aproximate
bearing_height = 0.37;
bearing_collar_height = 0.27;
bearing_collar_radius = 0.45/2;

rod_radius = 1/2;

$fn = 72;

module bearing_hole()
{
	drill_hole(bearing_screw_size/2);
	%translate([0,0, 0.75+bearing_height+bearing_collar_height*2+0.1]) cylinder(r1=bearing_radius, r2= bearing_radius2, h=bearing_height);
	%translate([0,0, 0.75+bearing_height/2+bearing_collar_height*3/2+0.1]) cylinder(r=bearing_collar_radius, h=bearing_collar_height);

	%translate([0,0, 0.75+bearing_height/2+bearing_collar_height/2]) cylinder(r=bearing_collar_radius, h=bearing_collar_height);
	%translate([0,0, 0.75]) cylinder(r2=bearing_radius, r1= bearing_radius2, h=bearing_height);
}

module drill_hole(size)
{
	square([size,size*0.1],center=true);
	square([size*0.1,size],center=true);
	%circle(size);
}

