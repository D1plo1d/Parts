	tooth_width = 3;
	contact_radius = 3;
	contact_point = 10;
	inner_circle_radius = 7.5;
%circle(1);

gear(number_of_teeth=12,diametric_pitch=1.2);

PI = 3.14159;

module gear(number_of_teeth, diametric_pitch, pressure_angle=20, simplify = true)
{
	inner_radius = number_of_teeth/diametric_pitch;
	
	pitch_diameter  = diametric_pitch * number_of_teeth / PI; //http://www.cs.cmu.edu/~rapidproto/mechanisms/chpt7.html
	
	
	union()
	{
		circle(inner_radius);
		for (i= [1:number_of_teeth])
		{
			rotate([0,0,-360*i/number_of_teeth])
			{
				if (simplify==true) simplified_gear_tooth(diametric_pitch, pressure_angle);
				if (simplify==false) involute_gear_tooth(number_of_teeth, pitch_diameter, pressure_angle);
			}
		}
	}
}


module simplified_gear_tooth(diametric_pitch)
{
	for (i=[0,1]) mirror([0,i,0]) polygon(
		points = [
			[0, -tooth_width/2],
			[contact_point-contact_radius/2, -tooth_width/2],
			[contact_point+contact_radius/2, -tooth_width/4],
			[contact_point+contact_radius/2, 0],
			[0,0]
		],
		convexity = 3);
}






















// I don't know why this doesn't work. I give up. If you can fix it then go for it!
module involute_gear_tooth(number_of_teeth, pitch_diameter, pressure_angle)
{
	mod = pitch_diameter/number_of_teeth;
	tc = pitch_diameter*sin((PI/2) / number_of_teeth);     //Chordal thickness
	bc = pitch_diameter*cos(pressure_angle*PI/180);     //Base circle
	od = pitch_diameter+2*mod;                          //Outside diameter
	ded = 1.57*mod;                                     //Dedendum 'need to find the analytical method that generates this 1.157 value
	rd = pitch_diameter - 2*ded;                           //??? (hey, i just work here)

	start_angle = PI/2 + asin( tc / pitch_diameter ) - (pressure_angle*PI/180) + sqrt(pow((pitch_diameter/bc),2)-1);

	end_angle = start_angle - sqrt(pow( (od/bc),2 )-1);
	angle_mod = (rd > bc)? sqrt(pow( (rd/bc),2 )-1):0;
			
	//tooth polygon properties
	polys_per_half_tooth = 6;
	step = (start_angle - angle_mod-end_angle)/polys_per_half_tooth;

	invo_end = p_invo(polys_per_half_tooth*step, bc, angle_mod)[0];
	gear_center_line = cartesian([ invo_end[0], invo_end[1] ]);
	

	echo("=======");
	echo([step, bc, angle_mod, start_angle]);
	echo(start_angle);
	echo(end_angle);
	//for (m=[0,1]) mirror(gear_center_line)
	//{
		polygon(
			points= [
				cartesian(p_invo(0*step, bc, angle_mod, start_angle)),
				cartesian(p_invo(1*step, bc, angle_mod, start_angle)),
				cartesian(p_invo(2*step, bc, angle_mod, start_angle)),
				cartesian(p_invo(3*step, bc, angle_mod, start_angle)),
				cartesian(p_invo(4*step, bc, angle_mod, start_angle)),
				cartesian(p_invo(5*step, bc, angle_mod, start_angle)),
				[0,0]
				],
		convexity = 3);
	//}
}

//function invo_x(radius, t) = radius*( cos(t) + t*sin(t) );
//function invo_y(radius, t) = radius*( sin(t) - t*cos(t) );

// Polar coord [angle, radius] to cartesian coord [x,y]
function cartesian(polar) = [
	polar[1]*cos(polar[0]),
	polar[1]*sin(polar[0])
];

// [ angle, length ]
function p_invo(i, base_circle, angle_mod, start_angle) =
[
	start_angle - angle_mod - i + atan(i+angle_mod),
	sqrt( pow((i+angle_mod)*base_circle/2,2) + pow(base_circle/2,2))
];
