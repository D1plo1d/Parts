d_radius = (4.57)/2; //the distance from opposing side of the shaft to the d divided by 2
shaft_radius = (4.91+0.1)/2;

$fn = 70;

//d_shaft();

module d_shaft()
{
difference()
{
	circle(shaft_radius);
	translate([d_radius-(shaft_radius-d_radius),-shaft_radius])
	{
		square([(shaft_radius-d_radius)*2,shaft_radius*2]);
	}
//verified the distance with this
//translate([-shaft_radius,0]) square([d_radius*2-0.04,1]);
}
}