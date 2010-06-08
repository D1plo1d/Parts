//test
//	gear(number_of_teeth=11,diametric_pitch=2);
//translate([12,0])rotate(360/11*2+4)
	gear(number_of_teeth=11,diametric_pitch=2);

//test();

module test()
{
for (i=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])
{
	echo(polar_to_cartesian([involute_intersect_angle( 0.1,i) , i ]));
	//translate(polar_to_cartesian([involute_intersect_angle( 0.1,i) , i ])) circle($fn=15, r=0.5);

	translate( involute_intersection_point(0.1,i,0) ) circle($fn=15, r=0.5);

}
}


PI = 3.1415926535;


//gear geometry: http://www.cartertools.com/involute.html
module gear(number_of_teeth, diametric_pitch, pressure_angle=20, simplify = true)
{
	addendum = 1/diametric_pitch;
	dedenum = 1.157/diametric_pitch;
	
	pitch_diameter  =  number_of_teeth / diametric_pitch;
	root_diameter = pitch_diameter-2*dedenum;
	base_diameter = pitch_diameter*cos(pressure_angle);
	outside_diameter = pitch_diameter+2*addendum;
	
	gear_tooth_spacing = 360/number_of_teeth;
	
	union()
	{
		circle($fn=number_of_teeth, r=root_diameter/2);
		for (i= [1:number_of_teeth])
		{
		//	rotate([0,0,-gear_tooth_spacing*i])
		//	{
				involute_gear_tooth(
					pitch_diameter/2,
					root_diameter/2,
					base_diameter/2,
					outside_diameter/2,
					gear_tooth_spacing);
		//	}
		}
	}
}


module involute_gear_tooth(
					pitch_radius,
					root_radius,
					base_radius,
					outside_radius,
					gear_tooth_spacing
					)
{
	//echo("======");
	//echo( involute_intersect_angle(root_diameter, pitch_diameter) );
	//echo( involute_intersect_angle(root_diameter, outside_diameter) );
	
	zero_angle = involute_intersect_angle(root_radius, base_radius) - gear_tooth_spacing/4;
	
	echo(zero_angle);
	//echo(base_radius);
	//echo(outside_radius);
	
	for (i=[0,1]) mirror([0, i]) polygon(
		//     _
		//   /   \
		// _|    |_
		points = [
			//gear side
			//[0,involute_intersection_point( base_radius,  base_radius,  zero_angle )[1]],
			
			//involute points
			involute_intersection_point( base_radius,  base_radius,  zero_angle ),
			involute_intersection_point( base_radius,  (outside_radius-base_radius)*2/8+base_radius,  zero_angle ),
			involute_intersection_point( base_radius,  (outside_radius-base_radius)*4/8+base_radius,  zero_angle ),
			involute_intersection_point( base_radius,  (outside_radius-base_radius)*6/8+base_radius,  zero_angle ),
			involute_intersection_point( base_radius,  outside_radius,  zero_angle ),
			
			// gear top and side
			// (0,0 to the involute forms the side)
			[involute_intersection_point( base_radius,  outside_radius,  zero_angle )[0],0],
			[0,0]
		],
		convexity = 3);
}

// Finds the intersection of the involute about the base radius with a cricle of the given radius in cartesian coordinates [x,y].
function involute_intersection_point(base_radius, radius, zero_angle) =
	polar_to_cartesian([  involute_intersect_angle(base_radius, radius)-zero_angle  ,  radius  ]);





//			[0, 0], //		|
			//[pitch_diameter/2, 0], //		/
			//polar_to_cartesian([involute_intersect_angle(root_diameter/2, outside_diameter/2)-zero_angle, outside_diameter/2]), //	_
//			polar_to_cartesian([involute_intersect_angle(root_diameter/2, outside_diameter/2)+gear_top_degrees, outside_diameter/2]),

			//[polar_to_cartesian([involute_intersect_angle(root_diameter, outside_diameter), outside_diameter])[0],[1]],
			//polar_to_cartesian([0, outside_diameter]),
//			[1,1]


//		points = [
//			[0,polar_to_cartesian([-gear_tooth_spacing*1/8-gear_top_degrees/2, root_diameter])[1]],
//			polar_to_cartesian([-gear_tooth_spacing*1/8-gear_top_degrees/2, pitch_diameter]),
//			polar_to_cartesian([-gear_top_degrees/2, outside_diameter]),
//			polar_to_cartesian([0, outside_diameter]),
//			[0,0]
//		],



// Finds the angle of the involute about the base radius at the given distance (radius) from it's center.
function involute_intersect_angle(base_radius, radius) = sqrt( pow(radius,2) - pow(base_radius,2) ) / base_radius - acos(base_radius / radius);

// Polar coord [angle, radius] to cartesian coord [x,y]
function polar_to_cartesian(polar) = [
	polar[1]*cos(polar[0]),
	polar[1]*sin(polar[0])
];

function rotation_matrix(degrees) = [ [cos(degrees), -sin(degrees)] , [sin(degrees), cos(degrees)] ];

//converts the length of a circle segment to degrees given it's radius and circumfrence
function radial_distance_to_degrees(radial_distance, radius) = 360 * radial_distance/circumfrence(radius);

function circumfrence(radius) = 2*PI*radius;