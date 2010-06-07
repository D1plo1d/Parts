//test
	gear(number_of_teeth=11,diametric_pitch=2);
//translate([12,0])rotate(360/11*2+4)
//	gear(number_of_teeth=11,diametric_pitch=2);

PI = 3.14159;


//gear geometry: http://www.cartertools.com/involute.html
module gear(number_of_teeth, diametric_pitch, pressure_angle=20, simplify = true)
{
	addendum = 1/diametric_pitch;
	dedenum = 1.157/diametric_pitch;
	
	pitch_diameter  =  number_of_teeth / diametric_pitch;
	
	root_diameter = pitch_diameter-2*dedenum;
	outside_diameter = pitch_diameter+2*addendum;

	gear_tooth_spacing = 360/number_of_teeth;
	
	union()
	{
		circle($fn=number_of_teeth, r=root_diameter);
		for (i= [1:number_of_teeth])
		{
			rotate([0,0,-gear_tooth_spacing*i])
			{
				if (simplify==true) simplified_gear_tooth(pitch_diameter, root_diameter, outside_diameter,gear_tooth_spacing);
				
				if (simplify==false) involute_gear_tooth(number_of_teeth, pitch_diameter, pressure_angle);
			}
		}
	}
}


module simplified_gear_tooth(pitch_diameter, root_diameter, outside_diameter,gear_tooth_spacing)
{
	//The size of the top of each gear is still pure bs.
	gear_top_degrees = gear_tooth_spacing*(1/4);
	echo("======");
	echo(involute_intersect_angle(root_diameter, pitch_diameter));
	echo(involute_intersect_angle(root_diameter, outside_diameter));
	for (i=[0,1]) mirror([0,i,0]) polygon(
//		points = [
//			[0,polar_to_cartesian([-gear_tooth_spacing*1/8-gear_top_degrees/2, root_diameter])[1]],
//			polar_to_cartesian([-gear_tooth_spacing*1/8-gear_top_degrees/2, pitch_diameter]),
//			polar_to_cartesian([-gear_top_degrees/2, outside_diameter]),
//			polar_to_cartesian([0, outside_diameter]),
//			[0,0]
//		],
		//     _
		//   /   \
		// _|    |_
		points = [
			[0, polar_to_cartesian([-involute_intersect_angle(root_diameter, pitch_diameter), pitch_diameter])[1]],
			//	|
			polar_to_cartesian([-involute_intersect_angle(root_diameter, pitch_diameter), pitch_diameter]),
			//	/
			polar_to_cartesian([-involute_intersect_angle(root_diameter, outside_diameter), outside_diameter]),
			//	_
			polar_to_cartesian([0, outside_diameter]),
			[0,0]
		],
		convexity = 3);
}

// Finds the angle of the involute about the base radius at the given distance (radius) from it's center.
function involute_intersect_angle(base_radius, radius) = sqrt( pow(radius,2) - pow(base_radius,2) ) / (base_radius - acos(base_radius / radius));

// Polar coord [angle, radius] to cartesian coord [x,y]
function polar_to_cartesian(polar) = [
	polar[1]*cos(polar[0]),
	polar[1]*sin(polar[0])
];

//converts the length of a circle segment to degrees given it's radius and circumfrence
function radial_distance_to_degrees(radial_distance, radius) = 360 * radial_distance/circumfrence(radius);

function circumfrence(radius) = 2*PI*radius;