//test
//	gear(number_of_teeth=11,diametral_pitch=17);
//translate([12,0])rotate(360/11*2+4)
//	gear(number_of_teeth=24,diametrial_pitch=180/20);
	gear(number_of_teeth=24,circular_pitch=20);

//test();

module test()
{
for (i=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])
{
	//echo(polar_to_cartesian([involute_intersect_angle( 0.1,i) , i ]));
	//translate(polar_to_cartesian([involute_intersect_angle( 0.1,i) , i ])) circle($fn=15, r=0.5);

	//translate( involute_intersection_point(0.1,i,0) ) circle($fn=15, r=0.5);
}
}


//	circular_pitch = pitch_diameter*180/ number_of_teeth;


// Geometry Sources:
//	http://www.cartertools.com/involute.html
//	gears.py (inkscape extension: /usr/share/inkscape/extensions/gears.py)
// Usage:
//	Diametrial pitch: Number of teeth per unit length.
//	Circular pitch: Length of the arc from one tooth to the next
//	Clearance: Radial distance between top of tooth on one gear to bottom of gap on another.

module gear(number_of_teeth, circular_pitch,
		pressure_angle=20, clearance = 0)
{
	// Pitch diameter: Diameter of pitch circle.
	pitch_diameter  =  number_of_teeth * circular_pitch / 180;
	pitch_radius = pitch_diameter/2;
	
	// Base Circle
	base_diameter = pitch_diameter*cos(pressure_angle);
	base_radius = base_diameter/2;

	// Diametrial pitch: Number of teeth per unit length.
	pitch_diametrial = number_of_teeth / pitch_diameter;
	
	// Addendum: Radial distance from pitch circle to outside circle.
	addendum = 1/pitch_diametrial;
	
	//Outer Circle
	outer_radius = pitch_radius+addendum;
	
	// Dedendum: Radial distance from pitch circle to root diameter
	dedendum = addendum + clearance;

	// Root diameter: Diameter of bottom of tooth spaces.
	root_radius = pitch_radius-dedendum;
		
	half_thick_angle = 360 / (4 * number_of_teeth);
	echo(half_thick_angle);
	gear_tooth_spacing = 360/number_of_teeth;
	
	union()
	{
		circle($fn=number_of_teeth, r=root_radius);
		
		for (i= [1:number_of_teeth])
		//for (i = [0])
		{
			rotate([0,0,gear_tooth_spacing*i])
			{
				involute_gear_tooth(
					pitch_radius = pitch_radius,
					root_radius = root_radius,
					base_radius = base_radius,
					outer_radius = outer_radius,
					half_thick_angle = half_thick_angle);
			}
		}
	}
}


module involute_gear_tooth(
					pitch_radius,
					root_radius,
					base_radius,
					outer_radius,
					half_thick_angle
					)
{
	pitch_to_base_angle  = involute_intersect_angle( base_radius, pitch_radius );
	
	pitch_to_outer_angle = involute_intersect_angle( base_radius, outer_radius ) - pitch_to_base_angle;

	pitch1 = 0 - half_thick_angle;
	base1 = pitch1 - pitch_to_base_angle;
	outer1 = pitch1 + pitch_to_outer_angle;
	
	pitch2 = 0 + half_thick_angle+0;
	base2 = pitch2 + pitch_to_base_angle;
	outer2 = pitch2 - pitch_to_outer_angle;
	
	b1 = polar_to_cartesian([ base1, base_radius ]);
	p1 = polar_to_cartesian([ pitch1, pitch_radius ]);
	o1 = polar_to_cartesian([ outer1, outer_radius ]);
	
	b2 = polar_to_cartesian([ base2, base_radius ]);
	p2 = polar_to_cartesian([ pitch2, pitch_radius ]);
	o2 = polar_to_cartesian([ outer2, outer_radius ]);
	
	// ( root_radius > base_radius variables )
		pitch_to_root_angle = pitch_to_base_angle - involute_intersect_angle(base_radius, root_radius );
		root1 = pitch1 - pitch_to_root_angle;
		root2 = pitch2 + pitch_to_root_angle;
		r1_t =  polar_to_cartesian([ root1, root_radius ]);
		r2_t =  polar_to_cartesian([ root2, root_radius ]);
	
	// ( else )
		r1_f =  polar_to_cartesian([ base1, root_radius ]);
		r2_f =  polar_to_cartesian([ base2, root_radius ]);
	
	if (root_radius > base_radius)
	{
		echo("true");
		polygon( points = [
			r1_t,p1,o1,o2,p2,r2_t
		], convexity = 3);
	}
	else
	{
		//echo("false");
		//echo([r1_f,b1,p1,o1,o2]);
		translate(r1_f) circle(r=0.01);
		translate(b1) circle(r=0.01);
		translate(p1) circle(r=0.01);
		translate(o1) circle(r=0.01);
		//translate(o2) circle(r=0.01);
		//translate(p2) circle(r=0.01);
		//translate(b2) circle(r=0.01);
		//translate(r2_f) circle(r=0.01);


		polygon( points = [
		//	r1_f, b1,p1,o1,o2,p2,b2,r2_f
		//	r1_f, b1,p2,o2,o1,p1,b2,r2_f
			r1_f, b1,p2,p1,b2,r2_f
		//	p1, o1, o2, p2
		], convexity = 3);
	}
	
}



// Finds the angle of the involute about the base radius at the given distance (radius) from it's center.

function involute_intersect_angle(base_radius, radius) = sqrt( pow(radius,2) - pow(base_radius,2) ) / base_radius - acos(base_radius / radius);


// Polar coord [angle, radius] to cartesian coord [x,y]

function polar_to_cartesian(polar) = [
	polar[1]*cos(polar[0]),
	polar[1]*sin(polar[0])
];


// == LEGACY ==
// Finds the intersection of the involute about the base radius with a cricle of the given radius in cartesian coordinates [x,y].

//function involute_intersection_point(base_radius, radius, zero_angle) = polar_to_cartesian([  involute_intersect_angle(base_radius, radius)-zero_angle  ,  radius  ]);

//function rotation_matrix(degrees) = [ [cos(degrees), -sin(degrees)] , [sin(degrees), cos(degrees)] ];
